import 'dart:io';
import 'package:collegefied/modules/profile/controllers/profile_controller.dart';
import 'package:collegefied/shared/utils/app_sizes.dart';
import 'package:collegefied/shared/widgets/app_back_button.dart';
import 'package:collegefied/shared/widgets/app_drop_down_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:collegefied/shared/utils/app_paddings.dart';
import 'package:collegefied/shared/widgets/app_button.dart';
import 'package:collegefied/shared/widgets/app_text_field.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late Map<String, dynamic> profileData;
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final courseController = TextEditingController();
  final genderController = TextEditingController();
  final collegeYearController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    profileData = Get.arguments;

    // Initialize controllers with existing data
    nameController.text = profileData['name'] ?? '';
    addressController.text = profileData['address'] ?? '';
    courseController.text = profileData['course'] ?? '';
    collegeYearController.text = profileData['college_year']?.toString() ?? '';
    genderController.text = profileData['gender'] ?? '';
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    courseController.dispose();
    collegeYearController.dispose();
    genderController.dispose();
    super.dispose();
  }

  void _pickImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _profileImage = File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Scaffold(
      appBar: AppBar(leading: const AppBackButton()),
      body: Padding(
        padding: const EdgeInsets.all(AppPaddings.pagePadding),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: AppSizes.profileImageRadius,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : null,
                      child: _profileImage == null
                          ? Icon(Icons.person,
                              size: 35, color: Colors.grey.shade600)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade300),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.camera_alt,
                              size: 18, color: Colors.black54),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppPaddings.medium),
              AppTextField(
                titleText: 'Name',
                hintText: "Enter your name",
                controller: nameController,
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Enter your name'
                    : null,
              ),
              AppTextField(
                titleText: 'Address',
                hintText: "Enter your address",
                controller: addressController,
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Enter your address'
                    : null,
              ),
              AppDropdownField(
                titleText: "Course",
                hintText: "Select your course",
                items: const [
                  'B.Tech - CSE',
                  'B.Tech - IT',
                  'B.Tech - ECE',
                  'B.Tech - EN',
                  'B.Tech - ME',
                  'B.Tech - CE',
                  'M.Tech',
                  'MBA',
                  'MCA',
                  'Pharmacy',
                ],
                value: courseController.text,
                onChanged: (val) => setState(() {
                  courseController.text = val ?? '';
                }),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Select your course'
                    : null,
              ),
              const SizedBox(height: AppPaddings.medium),
              AppDropdownField(
                titleText: "Gender",
                hintText: "Select your gender",
                items: const ['Male', 'Female', 'Other'],
                value: genderController.text,
                onChanged: (val) => setState(() {
                  genderController.text = val ?? '';
                }),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Select your gender'
                    : null,
              ),
              const SizedBox(height: AppPaddings.medium),
              AppDropdownField(
                titleText: "College Year",
                hintText: "Select your year",
                items: const ['1', '2', '3', '4'],
                value: collegeYearController.text,
                onChanged: (val) => setState(() {
                  collegeYearController.text = val ?? '';
                }),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Select your year'
                    : null,
              ),
              const SizedBox(height: AppPaddings.xLarge),
              Obx(() => AppButton(
                    text: controller.isLoading.value ? null : 'Save Changes',
                    isLoading: controller.isLoading.value,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        final body = {
                          'name': nameController.text,
                          'address': addressController.text,
                          'course': courseController.text,
                          'gender': genderController.text,
                          'college_year': collegeYearController.text,
                        };
                        controller.updateProfileData(body);
                      }
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
