import 'package:carousel_slider/carousel_slider.dart';
import 'package:collegefied/config/theme/colors.dart';
import 'package:collegefied/modules/product/controllers/product_controller.dart';
import 'package:collegefied/shared/utils/app_sizes.dart';
import 'package:collegefied/shared/utils/app_text_styles.dart';
import 'package:collegefied/shared/widgets/app_back_button.dart';
import 'package:collegefied/shared/widgets/app_button.dart';
import 'package:collegefied/shared/widgets/slide_to_request_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  // Static values
  // String title = "College Notes";
  // String description =
  //     "This is the test description that is having a test texts only.";
  // String price = "200";
  final List<String> imageUrls = [
    "https://bismamisbah2.wordpress.com/wp-content/uploads/2015/09/557e983007c504c18f5a19d2f5c91729.jpg",
    "https://study-stuff.com/wp-content/uploads/2021/02/pretty-notes-this-is-art-Favim.com-6341477-845x550.jpg",
    "https://study-stuff.com/wp-content/uploads/2021/02/pretty-notes-this-is-art-Favim.com-6341477-845x550.jpg",
  ];
  int currentIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  final ProductController _productController = Get.put(ProductController());

  @override
  void initState() {
    _productController.getProductDetails(productId: Get.arguments['id']);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            leading: AppBackButton(),
            expandedHeight: MediaQuery.of(context).size.height / 3,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  CarouselSlider(
                    carouselController: _carouselController,
                    options: CarouselOptions(
                      autoPlay: true,
                      viewportFraction: 1.0,
                      height: double.infinity,
                      onPageChanged: (index, reason) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                    ),
                    items: imageUrls.map((url) {
                      return Image.network(
                        url,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    }).toList(),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 16,
                    child: Row(
                      children: List.generate(imageUrls.length, (index) {
                        final isActive = currentIndex == index;
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          width: isActive ? 32 : 16,
                          height: 6,
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.primary
                                : AppColors.greyTextColor,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Obx(() {
              return _productController.productDetails.isEmpty
                  ? Center()
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _productController.productDetails['product']
                                ['title'],
                            style: AppTextStyles.f22w900
                                .copyWith(color: AppColors.primary),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            _productController.productDetails['product']
                                ['description'],
                            style: AppTextStyles.f16w600
                                .copyWith(color: AppColors.dividerColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: AppSizes.s12),
                          Text(
                            '₹${_productController.productDetails['product']['price']} Only',
                            style: AppTextStyles.f22w500
                                .copyWith(color: AppColors.dividerColor),
                          ),
                          _productController.productDetails['product']
                                      ['request_status'] ==
                                  'accepted'
                              ? const SizedBox(height: 32)
                              : SizedBox(),
                          _productController.productDetails['product']
                                      ['request_status'] ==
                                  'accepted'
                              ? AppButton(
                                  backgroundColor: AppColors.primary,
                                  onTap: () {},
                                  text: 'Chat',
                                )
                              : SizedBox(),
                          SizedBox(
                            height: 20,
                          ),
       _productController.isMyProduct.value?SizedBox():
                                         AppButton(
                            backgroundColor: _productController
                                    .productDetails['product']['has_requested']??false
                                ? const Color.fromARGB(255, 255, 17, 0)
                                : AppColors.primary,
                            onTap: () async{
                              if (_productController.productDetails['product']
                                  ['has_requested']) {
                               await  _productController.cancelRequest(
                                    requestId: _productController
                                            .productDetails['product']
                                        ['request_id'],
                                    status: "rejected",
                                    productId: _productController
                                        .productDetails['product']['id']);
                                        _productController.getProductDetails(productId:_productController
                                        .productDetails['product']['id'] );
                              } else {
                                _productController.sendProductRequest(
                                    productId: _productController
                                        .productDetails['product']['id']);
                              }
                            },
                            text: _productController.productDetails['product']
                                    ['has_requested']
                                ? "Tap to Cancel"
                                : 'Request For This',
                          ),

                          // SlideToRequestButton(
                          //     width: MediaQuery.of(context).size.width - 32,
                          //     isCompleted: _productController
                          //         .productDetails['product']['has_requested'],
                          //     productId: _productController
                          //         .productDetails['product']['id'],
                          //     requestId:
                          //         _productController.productDetails['product']
                          //                 ['request_id'] ??
                          //             0),
                          const SizedBox(height: 20),
                        ],
                      ),
                    );
            }),
          )
        ],
      ),
    );
  }
}
