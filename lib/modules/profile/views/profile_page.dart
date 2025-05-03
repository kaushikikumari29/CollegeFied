import 'package:collegefied/config/routes/app_routes.dart';
import 'package:collegefied/config/theme/colors.dart';
import 'package:collegefied/modules/profile/controllers/profile_controller.dart';
import 'package:collegefied/shared/utils/app_paddings.dart';
import 'package:collegefied/shared/utils/app_sizes.dart';
import 'package:collegefied/shared/utils/app_text_styles.dart';
import 'package:collegefied/shared/widgets/app_back_button.dart';
import 'package:collegefied/shared/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  Widget _buildProfileField(String label, String value) {
    return ListTile(
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
      leading: const Icon(Icons.arrow_right, size: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
     controller.fetchProfileData();

    return Scaffold(
      body: Obx(() {
        // if (controller.isLoading.value) {
        //   return const Center(child: CircularProgressIndicator());
        // }

        final data = controller.profileData;

        // if (data.isEmpty) {
        //   return const Center(child: Text('No profile data found.'));
        // }

        return SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(AppPaddings.pagePadding),
                child: Column(
                  children: [
                    SizedBox(height: AppPaddings.xxLarge),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          data['image'] != null && data['image'].isNotEmpty
                              ? NetworkImage(data['image'])
                              : const AssetImage('assets/placeholder.png')
                                  as ImageProvider,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      data['name'] ?? 'N/A',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.star, color: Colors.amber),
                        Text((data['average_rating'] ?? 0.0).toStringAsFixed(1)),
                      ],
                    ),
                    Divider(
                      height: 30,
                      thickness: 1,
                      color: AppColors.dividerColor,
                    ),
                    _buildProfileField("Address", data['address'] ?? 'N/A'),
                    _buildProfileField("Course", data['course'] ?? 'N/A'),
                    _buildProfileField(
                        "College Year", data['college_year'].toString()),
                    _buildProfileField("Gender", data['gender'] ?? 'N/A'),
                  ],
                ),
              ),
              Positioned(
                left: AppPaddings.pagePadding,
                top: AppPaddings.pagePadding,
                child: AppBackButton(),
              ),
              Positioned(
                right: AppPaddings.pagePadding,
                top: AppPaddings.pagePadding,
                child: AppButton(
                  onTap: () {
                    Get.toNamed(AppRoutes.editProfile);
                  },
                  text: "Edit Profile",
                  textStyle:
                      AppTextStyles.f12w500.copyWith(color: AppColors.bg),
                  height: 35,
                  // width: 70,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
