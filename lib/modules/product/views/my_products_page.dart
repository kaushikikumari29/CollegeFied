import 'package:collegefied/modules/product/controllers/product_controller.dart';
import 'package:collegefied/modules/product/views/edit_product_page.dart';
import 'package:collegefied/shared/usecases/usecases.dart';
import 'package:collegefied/shared/utils/app_images.dart';
import 'package:collegefied/shared/widgets/app_back_button.dart';
import 'package:collegefied/shared/widgets/app_data_states/empty_state.dart';
import 'package:collegefied/shared/widgets/app_data_states/loading_state.dart';
import 'package:collegefied/shared/widgets/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collegefied/config/routes/app_routes.dart';
import 'package:collegefied/config/theme/colors.dart';
import 'package:collegefied/shared/utils/app_paddings.dart';
import 'package:collegefied/shared/utils/app_sizes.dart';
import 'package:collegefied/shared/utils/app_text_styles.dart';
import 'package:collegefied/shared/widgets/app_button.dart';

class MyProductPage extends StatefulWidget {
  const MyProductPage({super.key});

  @override
  State<MyProductPage> createState() => _MyProductPageState();
}

class _MyProductPageState extends State<MyProductPage> {
  final controller = Get.find<ProductController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.products.isEmpty) {
        controller.getMyProducts();
      }
    });
  }

  Color _getStatusColor(String status) {
    switch (ProductStatus.values
        .firstWhere((e) => e.toString().split('.').last == status)) {
      case ProductStatus.available:
        return AppColors.availableProduct;
      case ProductStatus.reserved:
        return AppColors.reservedProduct;
      case ProductStatus.unavailable:
        return AppColors.unavailableProduct;
      case ProductStatus.sold:
        return AppColors.soldProduct;
      default:
        return AppColors.availableProduct;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: AppPaddings.small),
          child: Text(
            "My Products",
            style: AppTextStyles.f18w600,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: LoadingState(lottieAsset: AppImages.loadingLottie),
          );
        } else if (controller.products.isEmpty) {
          return Center(
            child: EmptyDataState(
              title: "No Products Found",
              subtitle: "Please check back later.",
              lottieAsset: AppImages.noDataLottie,
            ),
          );
        } else {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: AppPaddings.pagePadding),
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPaddings.pagePadding,
                    vertical: AppSizes.s6,
                  ),
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.64,
                  ),
                  itemBuilder: (context, index) {
                    final product = controller.products[index];
                    return _productTile(product);
                  },
                ),
              ),

              // Full screen loader during delete
              Obx(() => controller.isDeleting.value
                  ? Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.1),
                        child: Center(
                            child: LoadingState(
                                lottieAsset: AppImages.loadingLottie)),
                      ),
                    )
                  : SizedBox.shrink()),
            ],
          );
        }
      }),
    );
  }

  Widget _productTile(Map<String, dynamic> product) {
    final String title = product['title'] ?? 'No title';
    final String subTitle = product['description'] ?? 'No description';
    final String price = product['price']?.toString() ?? 'N/A';
    final String discount = product['discount'] ?? '';
    final String imageUrl = _getImageUrl(product);
    final int id = product['id'];
    final String status = product['status'];
    final String catId = product['category']['id'].toString();

    final statusColor = _getStatusColor(status);

    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.productDetail, arguments: {'id': id});
      },
      child: Stack(
        children: [
          _buildProductContainer(
            imageUrl,
            title,
            subTitle,
            price,
            id,
            status,
            catId,
            statusColor,
          ),
          _buildDiscountBadge(discount),
          _buildEditProductButton(title, subTitle, price, id, catId),
          _buildDeleteProductButton(id),
        ],
      ),
    );
  }

  Widget _buildProductContainer(
    String imageUrl,
    String title,
    String subTitle,
    String price,
    int id,
    String status,
    String catId,
    Color statusColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.s6),
        color: AppColors.bg,
        boxShadow: [
          BoxShadow(
            color: AppColors.greyTextColor.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImage(imageUrl),
          _buildInfoSection(
              title, subTitle, price, id, status, catId, statusColor),
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
    return 'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png';
  }

  Widget _buildImage(String imagePath) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(AppSizes.s6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppSizes.s6),
            topRight: Radius.circular(AppSizes.s6),
          ),
          image: DecorationImage(
            image: NetworkImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(
    String title,
    String subTitle,
    String price,
    int id,
    String status,
    String categoryId,
    Color statusColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoText(
                  title, AppTextStyles.f16w600, AppColors.darkGreyTextColor),
              _infoText(capitalizeFirstLetter(status), AppTextStyles.f14w600,
                  statusColor),
              _infoText("₹$price", AppTextStyles.f14w400,
                  AppColors.darkGreyTextColor),
            ],
          ),
        ),
        _buildActionButton(status, id),
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

  Widget _buildActionButton(String status, int id) {
    return status == 'sold'
        ? Padding(
            padding: const EdgeInsets.all(
              AppSizes.s4,
            ),
            child: AppButton(
              text: "Sold out",
              borderRadius: AppSizes.s6,
              backgroundColor: AppColors.greyTextColor,
              height: 35,
              onTap: () {},
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(
              AppSizes.s4,
            ),
            child: AppButton(
              text: "Mark as Sold",
              borderRadius: AppSizes.s6,
              backgroundColor: AppColors.primary,
              height: 35,
              onTap: () {
                controller.updateProduct(productId: id, status: "sold");
              },
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
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.s6, vertical: AppSizes.s6),
        child: Text(
          discount,
          style: AppTextStyles.f12w900.copyWith(color: AppColors.bg),
        ),
      ),
    );
  }

  Widget _buildEditProductButton(
    String title,
    String subTitle,
    String price,
    int id,
    String catId,
  ) {
    final product = controller.products.firstWhere((e) => e['id'] == id);
    final List<String> imageUrls = (product['images'] as List<dynamic>?)
            ?.map((img) => img['image'].toString())
            .toList() ??
        [];

    return Positioned(
      left: 0,
      child: InkWell(
        onTap: () {
          Get.toNamed(
            AppRoutes.updateProduct,
            arguments: {
              'title': title,
              'description': subTitle,
              'price': price,
              'id': id,
              'categoryId': catId,
              'images': imageUrls,
            },
          );
        },
        child: Container(
          height: 28,
          width: 28,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSizes.s6),
              bottomRight: Radius.circular(AppSizes.s6),
            ),
            color: AppColors.bg,
            boxShadow: [
              BoxShadow(
                color: AppColors.greyTextColor.withOpacity(0.3),
                blurRadius: 5,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.edit,
              size: AppSizes.s12 + AppSizes.s4,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteProductButton(
    int id,
  ) {
    return Positioned(
      right: 0,
      child: InkWell(
        onTap: () {
          AppDialogs.showDeleteProductDialog(
            context: context,
            onConfirm: () async {
              await controller.deleteProduct(productId: id);
            },
          );
        },
        child: Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(AppSizes.s6),
              bottomLeft: Radius.circular(AppSizes.s6),
            ),
            color: AppColors.bg,
            boxShadow: [
              BoxShadow(
                color: AppColors.greyTextColor.withOpacity(0.3),
                blurRadius: 5,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.delete,
              color: AppColors.error,
              size: AppSizes.s12 + AppSizes.s4,
            ),
          ),
        ),
      ),
    );
  }
}
