import 'package:collegefied/modules/home/widgets/categories.dart';
import 'package:collegefied/modules/home/widgets/home_drawer.dart';
import 'package:collegefied/modules/home/widgets/profile_card.dart';
import 'package:collegefied/modules/home/widgets/search_text_field.dart';
import 'package:collegefied/modules/product/controllers/product_controller.dart';
import 'package:collegefied/modules/profile/controllers/profile_controller.dart';
import 'package:collegefied/shared/utils/app_paddings.dart';
import 'package:collegefied/shared/utils/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/popular_packages.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductController _productController = Get.put(ProductController());

  @override
  void initState() {
    
    _productController.getCategories();
    _productController.getAllProducts();
   
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      drawer: HomeDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppPaddings.medium,
                  AppPaddings.medium,
                  AppPaddings.medium,
                  0.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppSizes.s12),
                    ProfileCard(),
                    SizedBox(height: AppSizes.s12 + AppSizes.s12),
                    SearchTextField(),
                    SizedBox(height: AppSizes.s12 + AppSizes.s12),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Categories(),
                    PopularPackages(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;

  _StickyHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // final double progress =
    //     (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    // final double categoryOpacity = 1.0 - progress;
    // final double categoryHeight =
    //     (90 * categoryOpacity).clamp(60.0, 90.0); // fix here
    return Container(
      height: maxHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        // gradient: AppColors.primaryGradient,
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppPaddings.medium,
          AppPaddings.medium,
          AppPaddings.medium,
          0.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSizes.s12),
            ProfileCard(),
            SizedBox(height: AppSizes.s12 + AppSizes.s12),
            SearchTextField(),
            Spacer(),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) => true;
}
