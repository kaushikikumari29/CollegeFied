import 'package:collegefied/config/theme/colors.dart';
import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({super.key});

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
