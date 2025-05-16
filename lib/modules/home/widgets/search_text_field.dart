import 'package:collegefied/config/theme/colors.dart';
import 'package:collegefied/modules/product/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class SearchTextField extends StatelessWidget {
  SearchTextField({super.key});
  final productController = Get.find<ProductController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.dividerColor.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: AppColors.dividerColor.withOpacity(0.2),
              offset: Offset(5, 10),
              spreadRadius: 1,
              blurRadius: 10,
            )
          ]),
      child: TextField(
        onChanged: (val) {
          productController.searchProduct(query: val);
        },
        onSubmitted: (val) {
          productController.searchProduct(query: val);
          FocusScope.of(context).unfocus();
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Search here...',
          labelStyle: TextStyle(color: Colors.black87),
          hintStyle: TextStyle(color: Colors.black38),
        ),
      ),
    );
  }
}
