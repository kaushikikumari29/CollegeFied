import 'package:collegefied/modules/category/widgets/category_products.dart';
import 'package:collegefied/modules/product/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryPage extends StatefulWidget {
  final String category;
  const CategoryPage({Key? key, required this.category}) : super(key: key);
  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final ProductController productController = Get.find<ProductController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productController.getProductsByCategory(widget.category);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.capitalizeFirst ?? 'Category',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            )),
      ),
      body: CategoryProducts(category: widget.category),
    );
  }
}
