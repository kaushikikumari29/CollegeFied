import 'package:collegefied/modules/product/controllers/product_controller.dart';
import 'package:collegefied/modules/product/views/create_product_page.dart';
import 'package:collegefied/modules/product/views/edit_product_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collegefied/config/routes/app_routes.dart';
import 'package:collegefied/config/theme/colors.dart';
import 'package:collegefied/shared/utils/app_paddings.dart';
import 'package:collegefied/shared/utils/app_sizes.dart';
import 'package:collegefied/shared/utils/app_text_styles.dart';
import 'package:collegefied/shared/widgets/app_button.dart';

class MyProductPage extends StatelessWidget {
  const MyProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();

    if (controller.products.isEmpty) {
      controller.getMyProducts();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Products"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.products.isEmpty) {
          return const Center(child: Text('No Products Found'));
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.s12,
                  vertical: AppSizes.s6,
                ),
                child: Text(
                  "Products",
                  style: AppTextStyles.f18w500.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.s12, vertical: AppSizes.s6),
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    final Map<String, dynamic> product = controller.products[index];
                    return _productTile(product,context);
                  },
                ),
              ),
            ],
          );
        }
      }),
    );
  }

  Widget _productTile(Map<String, dynamic> product,context) {
    final String title = product['title'] ?? 'No title';
    final String subTitle = product['description'] ?? 'No description';
    final String price = product['price']?.toString() ?? 'N/A';
    final String discount = product['discount'] ?? '';
    final String imageUrl = _getImageUrl(product);
    final int id=product['id'];
    final String status=product['status'];
    final String catId=product['category']['id'].toString();
    // final String image=product['images'].first??'';

    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.productDetail,
        arguments: {
          'id':id
        }
        
        );
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.s6),
              color: AppColors.bg,
              boxShadow: [
                BoxShadow(
                  color: AppColors.greyTextColor.withOpacity(0.8),
                  blurRadius: 4,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImage(imageUrl),
                _buildInfoSection(title, subTitle, price,context,id,
                status,
                catId
                ),
              ],
            ),
          ),
          _buildDiscountBadge(discount),
        ],
      ),
    );
  }

  String _getImageUrl(Map<String, dynamic> product) {
    try {
     
      final List<dynamic> images = product['images'] ?? [];
      if (images.isNotEmpty && images[0]['image'] != null) {
        return images[0]['image'];
      }
    } catch (_) {}
    return 'https://via.placeholder.com/150';
  }

  Widget _buildImage(String imagePath) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        // child: Icon(Icons.image,size:60,color: Colors.black26,),
        padding: const EdgeInsets.all(AppSizes.s6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.s6),
          image: DecorationImage(
            image: NetworkImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String subTitle, String price,BuildContext context, int id,
  
  String status,
  String categoryId
  
   ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoText(title, AppTextStyles.f16w600, AppColors.darkGreyTextColor),
              _infoText(subTitle, AppTextStyles.f14w400, AppColors.darkGreyTextColor),
              _infoText(price, AppTextStyles.f14w400, AppColors.darkGreyTextColor),
            ],
          ),
        ),
     status=='sold'? _button(
            
            "Sold out"
            , AppColors.darkGreyTextColor, AppColors.primary, 
           (){
          
           },
          isBold: true):
         
     
     
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _button("Edit", AppColors.primary, AppColors.primary, 
            
            (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return EditProductPage(
                  title: title,
                  description: subTitle,
                  price: price.toString(),
                  id: id,
                  categoryId: categoryId,
                );
              }));
            },
            isBold: true,



            
            ),
          _button(
            
           
            "SOLD", AppColors.primary, AppColors.primary, 
           (){

            Get.find<ProductController>().updateProduct(
              productId: id,
              status: "sold"
            );
           },
          isBold: true),
         
          ],
        ),
      ],
    );
  }

  Widget _infoText(String text, TextStyle style, Color color) {
    return Text(
      text,
      style: style.copyWith(color: color),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _button(String text, Color bgColor, Color textColor,
  
  Function onTap,
   {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
      child: AppButton(
        backgroundColor: bgColor,
        // width: 60,
        borderRadius: AppSizes.s6,
        height: 35,
        onTap: () {
          onTap();
        },
        text: text,
      ),
    );
  }

  Widget _buildDiscountBadge(String discount) {
    if (discount.isEmpty) return const SizedBox();
    return Positioned(
      top: 0.0,
      right: 0.0,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.5),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.s6, vertical: AppSizes.s6),
        child: Text(
          discount,
          style: AppTextStyles.f12w900.copyWith(color: AppColors.bg),
        ),
      ),
    );
  }
}
