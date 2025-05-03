import 'dart:io';
import 'package:collegefied/config/theme/colors.dart';
import 'package:collegefied/modules/profile/controllers/profile_controller.dart';
import 'package:collegefied/shared/utils/app_sizes.dart';
import 'package:collegefied/shared/utils/app_text_styles.dart';
import 'package:collegefied/shared/widgets/app_back_button.dart';
import 'package:collegefied/shared/widgets/app_drop_down_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:collegefied/shared/utils/app_paddings.dart';
import 'package:collegefied/shared/widgets/app_button.dart';
import 'package:collegefied/shared/widgets/app_text_field.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final courseController = TextEditingController();
  final genderController = TextEditingController();
  final collegeYearController = TextEditingController();
  File? _profileImage;

  final _formKey = GlobalKey<FormState>();

  final _imagePicker = ImagePicker();

  void _pickImage() async {
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
     final controller = Get.find<ProfileController>();
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(AppPaddings.pagePadding),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    SizedBox(height: AppPaddings.xxLarge),
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: AppSizes.buttonSize,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                        child: _profileImage == null
                            ? Icon(
                                Icons.person,
                                size: 35,
                                color: Colors.grey.shade600,
                              )
                            : null,
                      ),
                    ),
                    SizedBox(height: AppPaddings.medium),
                    AppTextField(
                      titleText: 'Name',
                      hintText: "Enter your name",
                      controller: nameController,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter your name'
                          : null,
                    ),
                    AppTextField(
                      titleText: 'Address',
                      hintText: "Enter your address",
                      controller: addressController,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter your address'
                          : null,
                    ),
                    AppDropdownField(
                      titleText: "Course",
                      hintText: "Select your course",
                      items: [
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
                      validator: (value) => value == null || value.isEmpty
                          ? 'Select your course'
                          : null,
                    ),
                    SizedBox(height: AppPaddings.medium),
                    AppDropdownField(
                      titleText: "Gender",
                      hintText: "Select your gender",
                      items: ['Male', 'Female', 'Other'],
                      value: genderController.text,
                      onChanged: (val) => setState(() {
                        genderController.text = val ?? '';
                      }),
                      validator: (value) =>
                      value == null || value.isEmpty ? 'Select your gender' : null,
                    ),
                    SizedBox(height: AppPaddings.medium),
                    AppDropdownField(
                      titleText: "College Year",
                      hintText: "Select your year",
                      items: [
                        '1',
                        '2',
                        '3',
                        '4',
                      ],
                      value: collegeYearController.text,
                      onChanged: (val) => setState(() {
                        collegeYearController.text = val ?? '';
                      }),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Select your year'
                          : null,
                    ),
                    SizedBox(height: AppPaddings.xLarge),
                    AppButton(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          var body={
                            'address':addressController.text,
                            'name':nameController.text,
                            'course':courseController.text,
                            'gender':genderController.text,
                            'college_year':collegeYearController.text
                          };
                          controller.updateProfileData(body);
                          
                        }
                      },
                      text: 'Save Changes',
                       isLoading: controller.isLoading.value,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                left: AppPaddings.pagePadding,
                top: AppPaddings.pagePadding,
                child: AppBackButton()),
            // Positioned(
            //     top: AppPaddings.small + AppPaddings.small,
            //     child: Center(
            //       child: Text(
            //         "Edit profile",
            //         style: AppTextStyles.f16w600,
            //       ),
            //     )),
          ],
        ),
      ),
    );
  }
}
