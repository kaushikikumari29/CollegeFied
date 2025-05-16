import 'package:collegefied/config/routes/app_routes.dart';
import 'package:collegefied/config/theme/colors.dart';
import 'package:collegefied/shared/utils/app_sizes.dart';
import 'package:collegefied/shared/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collegefied/modules/product/controllers/product_controller.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find();

    return Obx(() {
      final categoriesList = productController.categories;
      if (productController.isLoading.value) {
        return SizedBox.shrink();
      } else if (productController.categories.isEmpty) {
        return SizedBox.shrink();
      } else {
        return SizedBox(
          height: 110,
          width: MediaQuery.of(context).size.width / 1,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: categoriesList.length,
            itemBuilder: (context, index) {
              final category = categoriesList[index];

              return InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
                onTap: () {
                  Get.toNamed(AppRoutes.categoryProducts,
                      arguments: category['name'].toString().toLowerCase() ==
                              "books and stationary"
                          ? "book"
                          : category['name'].toString().toLowerCase());
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      index == 0 ? 16.0 : 0.0, 0.0, 16.0, 0.0),
                  child: SizedBox(
                    height: 90,
                    width: 85, // slightly more width to reduce overflow
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          // height: 60,
                          padding: EdgeInsets.all(AppSizes.s12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.dividerColor.withOpacity(0.1),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              category['image'] ??
                                  "https://cdn-icons-png.flaticon.com/512/3982/3982361.png",
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.image_not_supported),
                            ),
                          ),
                        ),
                        SizedBox(height: AppSizes.s6),
                        Flexible(
                          child: Text(
                            category['name'],
                            style: AppTextStyles.f12w500,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2, // allow slightly longer titles
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }
    });
  }
}
