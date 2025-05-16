import 'package:collegefied/config/routes/app_routes.dart';
import 'package:collegefied/config/theme/colors.dart';
import 'package:collegefied/shared/utils/app_sizes.dart';
import 'package:collegefied/shared/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  bool isShowDrawer;
  ProfileCard({super.key, this.isShowDrawer = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isShowDrawer)
          Padding(
            padding: const EdgeInsets.only(top: 1.0),
            child: InkWell(
              child: Icon(
                Icons.notes,
                size: 30,
              ),
              onTap: () {
                Scaffold.of(context).openDrawer(); // Open the drawer
              },
            ),
          ),
        if (isShowDrawer)
          SizedBox(
            width: AppSizes.s12,
          ),
        CircleAvatar(
          radius: 25,
          backgroundColor: AppColors.primary.shade50,
        ),
        SizedBox(
          width: AppSizes.s12,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello Praveen,",
                style: AppTextStyles.f12w500,
              ),
              Text(
                "Buy & Sell Effortlessly!",
                style: AppTextStyles.f20w900,
              ),
            ],
          ),
        ),
        if (isShowDrawer)
          SizedBox(
            width: AppSizes.s12,
          ),
        if (isShowDrawer)
          InkWell(
            child: Icon(
              Icons.notifications_active,
              size: 22,
            ),
            onTap: () {
              // Scaffold.of(context).openDrawer(); // Open the drawer
            },
          ),
      ],
    );
  }
}
