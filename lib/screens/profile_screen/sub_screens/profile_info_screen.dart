import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subsync/blocs/theme_bloc.dart';
import 'package:subsync/models/user_info_model.dart';
import 'package:subsync/models/user_model.dart';
import 'package:subsync/services/user_service.dart';
import 'package:subsync/utils/colors.dart';
import 'package:subsync/utils/text_theme.dart';
import 'package:subsync/widgets/custom_arrow_back_button.dart';
import 'package:subsync/widgets/custom_button.dart';
import 'package:subsync/widgets/custom_text_field.dart';

class ProfileInfoScreen extends StatefulWidget {
  const ProfileInfoScreen({super.key});

  static TextEditingController usernameController = TextEditingController();
  static TextEditingController roleController = TextEditingController();
  static TextEditingController emailController = TextEditingController();
  static TextEditingController firstNameController = TextEditingController();
  static TextEditingController lastNameController = TextEditingController();
  static TextEditingController phoneNumberController = TextEditingController();

  @override
  State<ProfileInfoScreen> createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends State<ProfileInfoScreen> {

  bool isButtonLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled){
          return [const SliverAppBar(leading: CustomAppbarBackButton())];
        }, 
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(),
                const SizedBox(height: 24),
                _buildUsernameTextField(),
                const SizedBox(height: 24),
                _buildFirstNameTextField(),
                const SizedBox(height: 24),
                _buildLastNameTextField(),
                const SizedBox(height: 24),
                _buildEmailAddressTextField(),
                const SizedBox(height: 24),
                _buildPhoneTextField(),
                const SizedBox(height: 24),
                _buildRoleTextField(),
                const SizedBox(height: 24),
                CustomButton(
                  isLoading: isButtonLoading,
                  onTap: () async {
                    setState(() => isButtonLoading = true);
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  final userInfo = prefs.getString('currentUserInfo');
                  UserInfoModel currentUserInfo = UserInfoModel.fromJson(jsonDecode(userInfo!));  
                  if(
                    currentUserInfo.data.firstName == ProfileInfoScreen.firstNameController.text &&
                    currentUserInfo.data.lastName == ProfileInfoScreen.lastNameController.text &&
                    currentUserInfo.data.phone == ProfileInfoScreen.phoneNumberController.text
                  ){
                    setState(() => isButtonLoading = false);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No changes made.')));
                  } else {
                    final result = await UserService.updateUserInfo(currentUserInfo, ProfileInfoScreen.firstNameController.text, ProfileInfoScreen.lastNameController.text, ProfileInfoScreen.phoneNumberController.text);
                    setState(() => isButtonLoading = false);
                    if(result != null) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User info updated.')));
                  }
                }, outlinedBorder: false, title: 'Save changes', trailingIcon: SvgPicture.asset('assets/icons/check_mark.svg', width: 18, fit: BoxFit.scaleDown, colorFilter: const ColorFilter.mode( SubSyncColors.gray0,BlendMode.srcIn))),
                const SizedBox(height: 40),
              ],
            ), 
          ),
        )
      ),
    );
  }

  CustomTextField _buildUsernameTextField() {
    return CustomTextField(
      label: 'Username',
      enabled: false,
      controller: ProfileInfoScreen.usernameController,
      contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
      hintText: 'Doe',
      prefixIcon: 'assets/icons/UserBold.svg',
      suffixIconColor: themeBloc.isDarkMode ? SubSyncColors.gray30 : SubSyncColors.gray60,
    );
  }

  CustomTextField _buildRoleTextField() {
    return CustomTextField(
      label: 'Role',
      enabled: false,
      controller: ProfileInfoScreen.roleController,
      contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
      hintText: 'Client',
      prefixIcon: 'assets/icons/job_profile.svg',
      suffixIconColor: themeBloc.isDarkMode ? SubSyncColors.gray30 : SubSyncColors.gray60,
    );
  }

  CustomTextField _buildFirstNameTextField() {
    return CustomTextField(
      label: 'First Name',
      obscureText: false,
      keyboardType: TextInputType.text,
      controller: ProfileInfoScreen.firstNameController,
      contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
      hintText: 'John',
      prefixIcon: 'assets/icons/user_id.svg',
      activeSuffixIcon: 'assets/icons/PencilSimple.svg',
      disabledSuffixIcon: 'assets/icons/PencilSimple.svg',
      suffixIconColor: themeBloc.isDarkMode ? SubSyncColors.gray30 : SubSyncColors.gray60,
    );
  }

   CustomTextField _buildLastNameTextField() {
    return CustomTextField(
      label: 'Last Name',
      keyboardType: TextInputType.text,
      controller: ProfileInfoScreen.lastNameController,
      contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
      hintText: 'Doe',
      prefixIcon: 'assets/icons/user_id.svg',
      activeSuffixIcon: 'assets/icons/PencilSimple.svg',
      disabledSuffixIcon: 'assets/icons/PencilSimple.svg',
      suffixIconColor: themeBloc.isDarkMode ? SubSyncColors.gray30 : SubSyncColors.gray60,
    );
  }

  CustomTextField _buildPhoneTextField() {
    return CustomTextField(
      label: 'Phone Number',
      keyboardType: TextInputType.number,
      controller: ProfileInfoScreen.phoneNumberController,
      contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
      hintText: 'John',
      prefixIcon: 'assets/icons/Numpad.svg',
      activeSuffixIcon: 'assets/icons/PencilSimple.svg',
      disabledSuffixIcon: 'assets/icons/PencilSimple.svg',
      suffixIconColor: themeBloc.isDarkMode ? SubSyncColors.gray30 : SubSyncColors.gray60,
    );
  }

   CustomTextField _buildEmailAddressTextField() {
    return CustomTextField(
      label: 'Email Address',
      keyboardType: TextInputType.emailAddress,
      controller: ProfileInfoScreen.emailController,
      contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
      hintText: 'janesmith2001@gmail.com',
      prefixIcon: 'assets/icons/EnvelopeSimple.svg',
      activeSuffixIcon: 'assets/icons/PencilSimple.svg',
      disabledSuffixIcon: 'assets/icons/PencilSimple.svg',
      suffixIconColor: themeBloc.isDarkMode ? SubSyncColors.gray30 : SubSyncColors.gray60,
    );
  }

   Padding _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        'Profile Info',
        style: Theme.of(context).textTheme.headingSm.copyWith(fontWeight: SubSyncTextStyles.bold),
      ),
    );
  }
}