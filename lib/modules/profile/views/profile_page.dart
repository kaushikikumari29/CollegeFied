import 'package:collegefied/config/routes/app_routes.dart';
import 'package:collegefied/config/theme/colors.dart';
import 'package:collegefied/modules/profile/controllers/profile_controller.dart';
import 'package:collegefied/shared/utils/app_paddings.dart';
import 'package:collegefied/shared/utils/app_text_styles.dart';
import 'package:collegefied/shared/widgets/app_back_button.dart';
import 'package:collegefied/shared/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final controller = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    controller.fetchProfileData();
  }

  Widget _buildProfileField(String label, String value) {
    return ListTile(
      leading: const Icon(Icons.arrow_right, size: 20),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        actions: [
          Obx(() {
            // Only show the button if profileData is not empty
            if (controller.profileData.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.only(
                  right: AppPaddings.pagePadding,
                  top:AppPaddings.small,
                ),
                child: AppButton(
                  onTap: () => Get.toNamed(
                    AppRoutes.editProfile,
                    arguments: controller.profileData.cast<String, dynamic>(),
                  ),
                  text: "Edit Profile",
                  textStyle:
                      AppTextStyles.f12w500.copyWith(color: AppColors.bg),
                  height: 35,
                ),
              );
            } else {
              return const SizedBox(); // No button while loading
            }
          }),
        ],
      ),
      body: Obx(() {
        final data = controller.profileData;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppPaddings.pagePadding),
          child: Column(
            children: [
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
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                data['email'] ?? 'N/A',
                style:
                const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                  "College Year", data['college_year']?.toString() ?? 'N/A'),
              _buildProfileField("Gender", data['gender'] ?? 'N/A'),
            ],
          ),
        );
      }),
    );
  }
}
