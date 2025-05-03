import 'package:collegefied/config/routes/app_routes.dart';
import 'package:collegefied/config/theme/colors.dart';
import 'package:collegefied/modules/home/widgets/profile_card.dart';
import 'package:collegefied/shared/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white70,
              ),
              child: Column(
                children: [
                  ProfileCard(isShowDrawer: false),
                ],
              )),
          ListTile(
            title: Text(
              'Profile',
              style: AppTextStyles.f14w500,
            ),
            onTap: () {
              Get.back();
              Get.toNamed(AppRoutes.profile);
            },
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
          Divider(
            color: AppColors.dividerColor,
            height: 0,
          ),
          ListTile(
            title: Text(
              'Sell Product',
              style: AppTextStyles.f14w500,
            ),
            onTap: () {
              Get.back();
              Get.toNamed(AppRoutes.createProduct);
            },
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
          Divider(
            color: AppColors.dividerColor,
            height: 0,
          ),
          ListTile(
            title: Text(
              'My Products',
              style: AppTextStyles.f14w500,
            ),
            onTap: () {
              Get.back();
              Get.toNamed(AppRoutes.myProductPage);
            },
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
          Divider(
            color: AppColors.dividerColor,
            height: 0,
          ),
          ListTile(
            title: Text(
              'Requests',
              style: AppTextStyles.f14w500,
            ),
            onTap: () {
              Get.back();
              Get.toNamed(AppRoutes.manageRequest);
            },
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
           Divider(
            color: AppColors.dividerColor,
            height: 0,
          ),
          ListTile(
            title: Text(
              'Chats',
              style: AppTextStyles.f14w500,
            ),
            onTap: () {
              Get.back();
              Get.toNamed(AppRoutes.chatList);
            },
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
          Divider(
            color: AppColors.dividerColor,
            height: 0,
          ),
          ListTile(
            title: Text(
              'Buy & Sell History',
              style: AppTextStyles.f14w500,
            ),
            onTap: () {
              Get.toNamed(AppRoutes.profile);
            },
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
          Divider(
            color: AppColors.dividerColor,
            height: 0,
          ),
          ListTile(
            title: Text(
              'Reset Password',
              style: AppTextStyles.f14w500,
            ),
            onTap: () {
              Get.back();
              Get.toNamed(AppRoutes.resetPassword);
            },
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
          Divider(
            color: AppColors.dividerColor,
            height: 0,
          ),
          ListTile(
            title: Text(
              'Logout',
              style: AppTextStyles.f14w500,
            ),
            onTap: () {
              Get.back();
              Get.offAllNamed(AppRoutes.login);
            },
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
          Divider(
            color: AppColors.dividerColor,
            height: 0,
          ),
        ],
      ),
    );
  }
}
