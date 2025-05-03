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


class EditProductPage extends StatefulWidget {
  String title;
  String description;
  String price;
  int id;
  String categoryId;
  EditProductPage({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    required this.id,
    required this.categoryId,
  });

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

  final ProductController _productController = Get.put(ProductController());

  @override
  void initState() {
    super.initState();
    titleController.text = widget.title;
    descriptionController.text = widget.description;
    priceController.text = widget.price;
    selectedCategoryId = widget.categoryId; // Set the initial category ID

    // Fetch categories when the page is initialized
    _productController.getCategories().then((_) {
      // Set the initial category based on the passed category ID
      var category = _productController.categories.firstWhere(
          (cat) => cat['id'].toString() == selectedCategoryId,
          orElse: () => null);
      if (category != null) {
        selectedCategory = category['name'];
        setState(() {});
      }
    });
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppPaddings.xxLarge + AppPaddings.large),
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
                    Text(
                      'Product Image',
                      style: AppTextStyles.f14w600
                          .copyWith(color: AppColors.darkGreyTextColor),
                    ),
                    SizedBox(height: AppSizes.s8),
                    Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.textFieldBgColor,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Center(child: Text('Upload Image')),
                    ),
                    SizedBox(height: AppSizes.s12 + AppSizes.s6),

                    // Category Dropdown
                    Obx(() {
                      if (_productController.categories.isEmpty) {
                        return CircularProgressIndicator();
                      }
                      return Container(
                        decoration: BoxDecoration(
                          color: AppColors.textFieldBgColor,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: AppPaddings.pagePadding, ),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: Text("Select Category", style: AppTextStyles.f14w400),
                          value: selectedCategory,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCategory = newValue;
                              selectedCategoryId = _productController.categories
                                  .firstWhere(
                                      (category) => category['name'] == selectedCategory)
                                  ['id']
                                  .toString(); // Set selected category ID
                            });
                          },
                          items: _productController.categories
                              .map<DropdownMenuItem<String>>((category) {
                            return DropdownMenuItem<String>(
                              value: category['name'],
                              child: Text(category['name'], style: AppTextStyles.f14w400),
                            );
                          }).toList(),
                          underline: SizedBox(),
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
                                productId: widget.id,
                                catId: selectedCategoryId!,
                              );
                              Navigator.pop(context);
                            }
                          },
                          text: 'Update Product',
                          isLoading: _productController.isLoading.value,
                        )),

                    SizedBox(height: AppSizes.s12 + AppSizes.s6),
                    Obx(() => AppButton(
                          onTap: () async {
                            await _productController.deleteProduct(productId: widget.id);
                            Navigator.pop(context);
                          },
                          text: 'Delete Product',
                          isLoading: _productController.isLoading.value,
                        )),
                  ],
                ),
              ),
            ),
            Positioned(
              left: AppPaddings.pagePadding,
              top: AppPaddings.pagePadding,
              child: AppBackButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget returnSizedBoxBottom() => SizedBox(height: AppSizes.s12);
}
