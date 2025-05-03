import 'package:collegefied/modules/product/controllers/product_controller.dart';
import 'package:collegefied/modules/profile/controllers/profile_controller.dart';
import 'package:get/get.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductController>(() => ProductController());
  }
}
