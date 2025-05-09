import 'dart:io';
import 'package:collegefied/config/theme/colors.dart';
import 'package:collegefied/modules/product/controllers/product_controller.dart';
import 'package:collegefied/shared/services/shared_pref.dart';
import 'package:collegefied/shared/utils/app_paddings.dart';
import 'package:collegefied/shared/utils/app_sizes.dart';
import 'package:collegefied/shared/utils/app_text_styles.dart';
import 'package:collegefied/shared/widgets/app_back_button.dart';
import 'package:collegefied/shared/widgets/app_button.dart';
import 'package:collegefied/shared/widgets/app_dialogs.dart';
import 'package:collegefied/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProductPage extends StatefulWidget {
  const EditProductPage({super.key});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  String? selectedCategory;
  String? selectedCategoryId;
  final _formKey = GlobalKey<FormState>();
  List<String> imageUrls = [];
  List<File> selectedImages = [];

  final ProductController _productController = Get.put(ProductController());
  final ImagePicker _picker = ImagePicker();

  late int productId;

  @override
  void initState() {
    super.initState();

    final args = Get.arguments;
    titleController.text = args['title'] ?? '';
    descriptionController.text = args['description'] ?? '';
    priceController.text = args['price'] ?? '';
    selectedCategoryId = args['categoryId'];
    productId = args['id'];
    imageUrls = List<String>.from(args['images'] ?? []);

    _productController.getCategories().then((_) {
      var category = _productController.categories.firstWhere(
        (cat) => cat['id'].toString() == selectedCategoryId,
        orElse: () => null,
      );
      if (category != null) {
        selectedCategory = category['name'];
        setState(() {});
      }
    });
  }

  Future<void> pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        selectedImages = pickedFiles.map((e) => File(e.path)).toList();
        imageUrls = [];
      });
    }
  }

  Widget buildImagePreview() {
    List<Widget> allImages = [];

    if (selectedImages.isNotEmpty) {
      allImages.add(ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.file(selectedImages[0],
              height: 180, width: double.infinity, fit: BoxFit.fill)));
      for (int i = 1; i < selectedImages.length; i++) {
        allImages.add(Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey.shade300),
          ),
          margin: const EdgeInsets.all(4),
          width: 80,
          height: 80,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.file(selectedImages[i], fit: BoxFit.fill)),
        ));
      }
    } else if (imageUrls.isNotEmpty) {
      allImages.add(ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(imageUrls[0],
              height: 180, width: double.infinity, fit: BoxFit.fill)));
      for (int i = 1; i < imageUrls.length; i++) {
        allImages.add(Container(
          margin: const EdgeInsets.all(4),
          width: 80,
          height: 80,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(imageUrls[i], fit: BoxFit.fill)),
        ));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: pickImages,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Product Images',
                  style: AppTextStyles.f14w600
                      .copyWith(color: AppColors.darkGreyTextColor)),
              const SizedBox(height: 8),
              ...allImages,
              if (selectedImages.isEmpty && imageUrls.isEmpty)
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.textFieldBgColor,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Center(child: Text('Tap to Upload Images')),
                )
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        leading: const AppBackButton(),
        actions: [
          _buildDeleteProductButton(productId),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppPaddings.pagePadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Edit Product', style: AppTextStyles.f24w600),
              SizedBox(height: AppSizes.s12),
              AppTextField(
                titleText: 'Title',
                hintText: 'Enter product title',
                controller: titleController,
              ),
              AppTextField(
                titleText: 'Description',
                hintText: 'Enter product description',
                controller: descriptionController,
              ),
              AppTextField(
                titleText: 'Price',
                hintText: 'Enter price',
                controller: priceController,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: AppSizes.s6),
              buildImagePreview(),
              SizedBox(height: AppSizes.s12 + AppSizes.s6),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: AppPaddings.pagePadding),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: Text("Select Category", style: AppTextStyles.f14w400),
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
                        child: Text(category['name'],
                            style: AppTextStyles.f14w400),
                      );
                    }).toList(),
                    underline: const SizedBox(),
                  ),
                );
              }),
              SizedBox(height: AppSizes.s12 + AppSizes.s6),
              Obx(() => AppButton(
                    onTap: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        int? sellerID = await SharedPrefs.getUserId();
                        final price = double.parse(priceController.text);
                        await _productController.editProduct(
                          title: titleController.text.trim(),
                          description: descriptionController.text.trim(),
                          price: price,
                          sellerId: sellerID!,
                          productId: productId,
                          catId: selectedCategoryId!,
                          images: selectedImages,
                        );
                        Navigator.pop(context);
                      }
                    },
                    text: 'Update Product',
                    isLoading: _productController.isLoading.value,
                  )),
              SizedBox(height: AppPaddings.pagePadding),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteProductButton(
    int id,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top:12.0,right:8.0),
      child: IconButton(
        onPressed: () {
          AppDialogs.showDeleteProductDialog(
            context: context,
            onConfirm: () async {
              await _productController.deleteProduct(productId: productId);
              Navigator.pop(context);
            },
          );
        },
        icon: Icon(Icons.delete),
        color: AppColors.error,
        iconSize: 25,
      ),
    );
  }
}
