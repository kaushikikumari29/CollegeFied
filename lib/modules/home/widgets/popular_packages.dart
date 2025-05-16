import 'package:collegefied/config/routes/app_routes.dart';
import 'package:collegefied/config/theme/colors.dart';
import 'package:collegefied/modules/home/entities/popular_package_entity.dart';
import 'package:collegefied/modules/product/controllers/product_controller.dart';
import 'package:collegefied/shared/utils/app_images.dart';
import 'package:collegefied/shared/utils/app_paddings.dart';
import 'package:collegefied/shared/utils/app_sizes.dart';
import 'package:collegefied/shared/utils/app_text_styles.dart';
import 'package:collegefied/shared/widgets/app_button.dart';
import 'package:collegefied/shared/widgets/app_data_states/empty_state.dart';
import 'package:collegefied/shared/widgets/app_data_states/loading_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopularPackages extends StatelessWidget {
  PopularPackages({super.key});

  final productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (productController.isLoading.value != true)
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.s12 + AppSizes.s4, vertical: AppSizes.s6),
            child: Text(
              "Products",
              style: AppTextStyles.f18w500.copyWith(
                color: AppColors.darkGreyTextColor,
              ),
            ),
          ),
        Obx(() {
          final allProducts = productController.filteredProducts;
          if (productController.isLoading.value) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: LoadingState(lottieAsset: AppImages.loadingLottie),
              ),
            );
          } else if (productController.filteredProducts.isEmpty) {
            return Center(
              child: EmptyDataState(
                title: "No Products Found",
                subtitle: "Please check back later.",
                lottieAsset: AppImages.noDataLottie,
              ),
            );
          } else {
            return GridView.builder(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.s12, vertical: AppSizes.s6),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: allProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                final product = allProducts[index];
                return InkWell(
                  onTap: () => Get.toNamed(AppRoutes.productDetail,
                      arguments: allProducts[index]),
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
                            _buildImage(
                                'https://study-stuff.com/wp-content/uploads/2021/02/pretty-notes-this-is-art-Favim.com-6341477-845x550.jpg'),
                            _buildInfoSection(product),
                          ],
                        ),
                      ),
                      _buildDiscountBadge("15% OFF"),
                    ],
                  ),
                );
              },
            );
          }
        }),
      ],
    );
  }

  Widget _buildImage(String imagePath) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSizes.s6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.s6),
          image: DecorationImage(
            image: imagePath.isNotEmpty
                ? NetworkImage(imagePath)
                : const AssetImage("assets/placeholder.jpg") as ImageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(Map product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoText(product['title'] ?? '', AppTextStyles.f16w600,
              AppColors.darkGreyTextColor),
          _infoText(
              product['status'] ?? '',
              AppTextStyles.f14w400,
              product['status'] == 'available'
                  ? AppColors.success
                  : AppColors.darkGreyTextColor),
          _infoText("₹${product['price'] ?? ''}", AppTextStyles.f14w400,
              AppColors.darkGreyTextColor),
          SizedBox(
            height: 10,
          ),
          _button(
            "Buy Now",
            product['available'] == true
                ? AppColors.primary
                : AppColors.greyTextColor,
            product['available'] == true ? AppColors.bg : AppColors.bg,
          ),
          // _button("Buy Now", AppColors.primary, AppColors.primary),
        ],
      ),
    );
  }

  Widget _infoText(String text, TextStyle style, Color color) {
    return Text(
      text,
      style: style.copyWith(color: color),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start,
    );
  }

  Widget _button(String text, Color bgColor, Color textColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
      child: AppButton(
        borderRadius: AppSizes.s6,
        height: 35,
        onTap: () {},
        text: text,
      ),
    );
  }

  Widget _buildDiscountBadge(String discount) {
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
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.s6, vertical: AppSizes.s6),
        child: Text(
          discount,
          style: AppTextStyles.f12w900.copyWith(color: AppColors.bg),
        ),
      ),
    );
  }
}
