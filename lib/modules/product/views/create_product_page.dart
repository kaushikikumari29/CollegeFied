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
import 'package:image_picker/image_picker.dart'; // Add this import

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({super.key});

  @override
  State<CreateProductPage> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  String? selectedCategory;
  String? selectedCategoryId;
  String? selectedStatus;
  final _formKey = GlobalKey<FormState>();

  final List<String> statusOptions = [
    'Available',
    'Reserved',
    'Unavailable',
    'Sold',
  ];

  final bool isProfileComplete = true;

  final ProductController _productController = Get.put(ProductController());

  List<File>? selectedImage=[]; // Store selected image file

  final ImagePicker _picker = ImagePicker(); // ImagePicker instance

  @override
  void initState() {
    super.initState();
    _productController.getCategories();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage?.add(File(image.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
          child: Stack(children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(AppPaddings.pagePadding),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppPaddings.xxLarge + AppPaddings.large),
                    Text('Sell Product', style: AppTextStyles.f24w600),
                    SizedBox(height: AppSizes.s12),
                    if (!isProfileComplete) ...[
                      Text(
                        'Please complete your profile to create or buy a product.',
                        style: AppTextStyles.f14w400
                            .copyWith(color: AppColors.error),
                      ),
                      SizedBox(height: AppSizes.s12),
                      AppButton(
                        onTap: () => Get.toNamed(AppRoutes.profile),
                        text: 'Complete Profile',
                      ),
                      returnSizedBoxBottom(),
                    ],
                    AppTextField(
                      titleText: 'Title',
                      hintText: 'Enter product title',
                      controller: titleController,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Enter title' : null,
                    ),
                    AppTextField(
                      titleText: 'Description',
                      hintText: 'Enter product description',
                      controller: descriptionController,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter description'
                          : null,
                    ),
                    AppTextField(
                      titleText: 'Price',
                      hintText: 'Enter price',
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter price';
                        }
                        final price = double.tryParse(value);
                        if (price == null || price <= 0) {
                          return 'Enter valid price';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: AppSizes.s6),
                    Text(
                      'Product Image',
                      style: AppTextStyles.f14w600
                          .copyWith(color: AppColors.darkGreyTextColor),
                    ),
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
                        child: selectedImage!.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.file(
                                  selectedImage!.first,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              )
                            : const Center(child: Text('Upload Image')),
                      ),
                    ),
                    SizedBox(height: AppSizes.s12 + AppSizes.s6),

                    // Category Dropdown
                    Obx(() {
                      if (_productController.categories.isEmpty) {
                        return const CircularProgressIndicator();
                      }
                      return Container(
                        decoration: BoxDecoration(
                          color: AppColors.textFieldBgColor,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: AppPaddings.pagePadding),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: Text("Select Category",
                              style: AppTextStyles.f14w400),
                          value: selectedCategory,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCategory = newValue;
                              selectedCategoryId = _productController.categories
                                  .firstWhere((category) =>
                                      category['name'] == selectedCategory)['id']
                                  .toString();
                            });
                          },
                          items: _productController.categories
                              .map<DropdownMenuItem<String>>((category) {
                            return DropdownMenuItem<String>(
                              value: category['name'],
                              child:
                                  Text(category['name'], style: AppTextStyles.f14w400),
                            );
                          }).toList(),
                          underline: const SizedBox(),
                        ),
                      );
                    }),
                    SizedBox(height: AppSizes.s12 + AppSizes.s6),
                    Obx(() => AppButton(
                          onTap: () async {
                            if (!isProfileComplete) {
                              Get.snackbar('Incomplete Profile',
                                  'Please complete your profile first.');
                              return;
                            }

                            if (_formKey.currentState?.validate() ?? false) {
                              if (selectedImage == null) {
                                Get.snackbar(
                                    'No Image', 'Please upload a product image');
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
                                prodImage: selectedImage!
                                // Pass the image file if you modify controller
                              );
                              Navigator.pop(context);
                            }
                          },
                          text: 'Submit Product',
                          isLoading: _productController.isLoading.value,
                        )),
                  ],
                ),
              ),
            ),
            Positioned(
                left: AppPaddings.pagePadding,
                top: AppPaddings.pagePadding,
                child: AppBackButton()),
          ]),
        ));
  }

  Widget returnSizedBoxBottom() => SizedBox(height: AppSizes.s12);
}
