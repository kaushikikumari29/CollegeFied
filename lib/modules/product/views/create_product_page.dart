import 'dart:io';

import 'package:collegefied/config/routes/app_routes.dart';
import 'package:collegefied/config/theme/colors.dart';
import 'package:collegefied/modules/product/controllers/product_controller.dart';
import 'package:collegefied/shared/services/shared_pref.dart';
import 'package:collegefied/shared/utils/app_paddings.dart';
import 'package:collegefied/shared/utils/app_sizes.dart';
import 'package:collegefied/shared/utils/app_text_styles.dart';
import 'package:collegefied/shared/widgets/app_back_button.dart';
import 'package:collegefied/shared/widgets/app_button.dart';
import 'package:collegefied/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({super.key});

  @override
  State<CreateProductPage> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _productController = Get.put(ProductController());
  final _picker = ImagePicker();

  String? selectedCategory;
  String? selectedCategoryId;

  List<File> selectedImages = [];

  @override
  void initState() {
    super.initState();
    _productController.getCategories();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => selectedImages.add(File(image.path)));
    }
  }

  Widget _buildCategoryDropdown() {
    return Obx(() {
      if (_productController.categories.isEmpty) {
        return const CircularProgressIndicator();
      }
      return Container(
        decoration: BoxDecoration(
          color: AppColors.textFieldBgColor,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey.shade300),
        ),
        padding: EdgeInsets.symmetric(horizontal: AppPaddings.pagePadding),
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text("Select Category", style: AppTextStyles.f14w400),
          value: selectedCategory,
          onChanged: (String? newValue) {
            setState(() {
              selectedCategory = newValue;
              selectedCategoryId = _productController.categories
                  .firstWhere((cat) => cat['name'] == newValue)['id']
                  .toString();
            });
          },
          items: _productController.categories
              .map<DropdownMenuItem<String>>(
                (cat) => DropdownMenuItem<String>(
                  value: cat['name'],
                  child: Text(cat['name'], style: AppTextStyles.f14w400),
                ),
              )
              .toList(),
          underline: const SizedBox(),
        ),
      );
    });
  }

  void _submitProduct() async {
    if (!SharedPrefs.isProfileComplete) {
      Get.snackbar('Incomplete Profile', 'Please complete your profile first.');
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      if (selectedImages.isEmpty) {
        Get.snackbar('No Image', 'Please upload a product image');
        return;
      }
      int? sellerID = await SharedPrefs.getUserId();
      final price = double.parse(priceController.text);
      await _productController.createProduct(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        price: price,
        sellerId: sellerID!,
        cateId: selectedCategoryId!,
        prodImage: selectedImages,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(AppPaddings.pagePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppPaddings.xxLarge + AppPaddings.medium),
                  Text('Sell Product', style: AppTextStyles.f24w600),
                  SizedBox(height: AppSizes.s12),
                  SharedPrefs.isProfileComplete == true
                      ? _buildCreateProductForm()
                      : _buildIncompleteProfileView(),
                ],
              ),
            ),
            const Positioned(
              left: 0.0,
              top: 0.0,
              child: AppBackButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncompleteProfileView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Please complete your profile to create or buy a product.',
          style: AppTextStyles.f14w400.copyWith(color: AppColors.error),
        ),
        SizedBox(height: AppSizes.s12),
        AppButton(
          onTap: () => Get.toNamed(AppRoutes.profile),
          text: 'Complete Profile',
        ),
        SizedBox(height: AppSizes.s12),
      ],
    );
  }

  Widget _buildCreateProductForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            titleText: 'Title',
            hintText: 'Enter product title',
            controller: titleController,
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Title is required.' : null,
          ),
          AppTextField(
            titleText: 'Description',
            hintText: 'Enter product description',
            controller: descriptionController,
            validator: (value) => (value == null || value.isEmpty)
                ? 'Description is required.'
                : null,
          ),
          AppTextField(
            titleText: 'Price',
            hintText: 'Enter price',
            controller: priceController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Price is required.';
              final price = double.tryParse(value);
              return (price == null || price <= 0) ? 'Enter valid price' : null;
            },
          ),
          SizedBox(height: AppSizes.s6),
          Text('Product Image',
              style: AppTextStyles.f14w600
                  .copyWith(color: AppColors.darkGreyTextColor)),
          SizedBox(height: AppSizes.s8),
          InkWell(
            onTap: _pickImage,
            child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.textFieldBgColor,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: selectedImages.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.file(
                        selectedImages.first,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    )
                  : const Center(child: Text('Upload Image')),
            ),
          ),
          SizedBox(height: AppSizes.s12 + AppSizes.s6),
          _buildCategoryDropdown(),
          SizedBox(height: AppSizes.s12 + AppSizes.s6),
          Obx(() => AppButton(
                onTap: _submitProduct,
                text: 'Submit Product',
                isLoading: _productController.isLoading.value,
              )),
        ],
      ),
    );
  }
}
