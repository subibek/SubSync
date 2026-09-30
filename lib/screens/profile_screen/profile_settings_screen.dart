import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:subsync/blocs/theme_bloc.dart';
import 'package:subsync/models/user_model.dart';
import 'package:subsync/services/user_service.dart';
import 'package:subsync/utils/app_version.dart';
import 'package:subsync/utils/colors.dart';
import 'package:subsync/utils/route/route_names.dart';
import 'package:subsync/widgets/custom_circular_image_container.dart';
import 'package:subsync/widgets/custom_profile_settings_container.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  _buildStreakContainer(),
                  const SizedBox(height: 32),
                  _buildCustomSection(title: 'General Settings', child: _buildGeneralSettingsContent(containerHeight: 320)),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 25), child: Divider(color: themeBloc.isDarkMode ? SubSyncColors.gray70 : SubSyncColors.gray20)),

                  _buildCustomSection(title: 'Notifications', child: _buildNotificationContent(containerHeight: 184)),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 25), child: Divider(color: themeBloc.isDarkMode ? SubSyncColors.gray70 : SubSyncColors.gray20)),

                  _buildCustomSection(title: 'Security', child: _buildSecurityContent(containerHeight: 184)),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 25), child: Divider(color: themeBloc.isDarkMode ? SubSyncColors.gray70 : SubSyncColors.gray20)),

                  _buildCustomSection(title: 'Help & Support', child: _buildHelpAndSupportContent(containerHeight: 184)),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 25), child: Divider(color: themeBloc.isDarkMode ? SubSyncColors.gray70 : SubSyncColors.gray20)),

                  _buildCustomSection(title: 'Account', child:  CustomProfileSettingsContainer(leadingIconPath: 'assets/icons/TrashSimple.svg', text: 'Close Account', onTap: (){})),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25), 
                    child: _buildSignOutTextButton(onTap: () async {
                      String response = await UserService.logout();
                      if(response == "Success"){
                        context.go(RouteNames.signInScreen);
                      }
                    })),
                  
                  Column(
                    children: [
                      Text(
                        AppVersion.version,
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                        // style: Theme.of(context).textTheme.textSm.copyWith(fontWeight: PiggyTextStyles.semiBold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'All rights reserved, 2026©',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                        // style: Theme.of(context).textTheme.textXs.copyWith(color: themeBloc.isDarkMode ? PiggyColors.gray30 : PiggyColors.gray60),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20)
                ],
              ), 
            ),
          )
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      forceMaterialTransparency: false,
      centerTitle: false,
      expandedHeight: 500,
      leading: _buildArrowBackButton(context),
      actions: [
        _buildBellIconButton(),
        const SizedBox(width: 15)
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        titlePadding: const EdgeInsetsDirectional.only(bottom: 60),
        background: _buildAppBarContent(context),
      ),
    );
  }

  Widget _buildSignOutTextButton({required GestureTapCallback onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/icons/SignOut.svg', width: 20, colorFilter: const ColorFilter.mode(SubSyncColors.destructive60, BlendMode.srcIn)),
            const SizedBox(width: 8),
            Text(
              'Sign Out',
              style: TextStyle(fontWeight: FontWeight.w800, color: SubSyncColors.destructive60),
              // style: Theme.of(context).textTheme.textSm.copyWith(fontWeight: PiggyTextStyles.semiBold, color: SubSyncColors.destructive60),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHelpAndSupportContent({ required double containerHeight}) {
    return SizedBox(
      height: containerHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomProfileSettingsContainer(leadingIconPath: 'assets/icons/ChatDots.svg', text: 'Live Chat', onTap: (){
          context.push('${RouteNames.profileScreen}${RouteNames.profileSettingsScreen}${RouteNames.helpCenterScreen}');
          }),
          CustomProfileSettingsContainer(leadingIconPath: 'assets/icons/Star.svg', text: 'Feature Request', onTap: (){
          }, trailingWidget: _buildArrowSquareOutIcon()),
          CustomProfileSettingsContainer(leadingIconPath: 'assets/icons/ThumbsUp.svg', text: "What's New", onTap: (){
          }, trailingWidget: _buildArrowSquareOutIcon())
        ],
      ),
    );
  }

   Widget _buildSecurityContent({ required double containerHeight}) {
    return SizedBox(
      height: containerHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomProfileSettingsContainer(leadingIconPath: 'assets/icons/Shield.svg', text: 'Change Password', onTap: (){}),
          CustomProfileSettingsContainer(leadingIconPath: 'assets/icons/Numpad.svg', text: 'Change Passcode', onTap: (){
          }),
          CustomProfileSettingsContainer(leadingIconPath: 'assets/icons/Password.svg', text: 'Change Pin', onTap: (){}, trailingWidget: _buildArrowSquareOutIcon())
        ],
      ),
    );
  }

  SvgPicture _buildArrowSquareOutIcon() => SvgPicture.asset('assets/icons/ArrowSquareOut.svg', width: 24, fit: BoxFit.scaleDown, colorFilter: ColorFilter.mode(themeBloc.isDarkMode ? SubSyncColors.gray0 : SubSyncColors.gray80, BlendMode.srcIn)); 

  Widget _buildNotificationContent({required double containerHeight}) {
    return SizedBox(
      height: containerHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomProfileSettingsContainer(leadingIconPath: 'assets/icons/Bell_Outlined.svg', text: 'Push Notifications', 
          onTap: (){
            context.push('${RouteNames.profileScreen}${RouteNames.profileSettingsScreen}${RouteNames.notificationSettingsScreen}');
          }),
          CustomProfileSettingsContainer(leadingIconPath: 'assets/icons/SpeakerSimpleHigh.svg', text: 'Sound Notification', onTap: (){}),
          CustomProfileSettingsContainer(leadingIconPath: 'assets/icons/EnvelopeSimple.svg', text: 'Email Notification', onTap: (){})
        ],
      ),
    );
  }


  Widget _buildGeneralSettingsContent({ required double containerHeight}) {
    return SizedBox(
      height: containerHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomProfileSettingsContainer(leadingIconPath: 'assets/icons/User.svg', text: 'Profile Info', onTap: (){
            context.push('${RouteNames.profileScreen}${RouteNames.profileSettingsScreen}${RouteNames.profileInfoScreen}');
          }),
          CustomProfileSettingsContainer(leadingIconPath: 'assets/icons/Palette.svg', text: 'Display & Appearence', onTap: (){
            context.push('${RouteNames.profileScreen}${RouteNames.profileSettingsScreen}${RouteNames.appearanceModeScreen}');
          }),
          CustomProfileSettingsContainer(leadingIconPath: 'assets/icons/GearSix.svg', text: 'Preferences', onTap: (){}),
          CustomProfileSettingsContainer(leadingIconPath: 'assets/icons/CurrencyDollarSimple.svg', text: 'Currency', onTap: (){}),
          CustomProfileSettingsContainer(leadingIconPath: 'assets/icons/info_outlined.svg', text: 'About Us', onTap: (){}),
        ],
      ),
    );
  } 

  Widget _buildAppBarContent(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 215,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/profileSettingsBgImage.png'),
              fit: BoxFit.cover
            )
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 157, left: 15, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              CustomCircularImageContainer(
                isChildEmpty: false, 
                child: SizedBox(height:100, child: Icon(Icons.person))
              ),
              const SizedBox(height: 24),
              _buildUserDetails(context),
              const SizedBox(height: 20),
              _buildAchievementList(context)
            ],
          ),
        )
      ],
    );
  }

  GestureDetector _buildStreakContainer() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (){},
      child: Container(
        height: 156,
        decoration: _boxDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.construction_sharp, size: 40),
              // SvgPicture.asset('assets/icons/Teardrop.svg', width: 40, fit: BoxFit.scaleDown,),
              LinearProgressIndicator(
                backgroundColor: themeBloc.isDarkMode ? SubSyncColors.brand90 : SubSyncColors.brand10,
                value: 0.8,
                minHeight: 8,
                color: themeBloc.currentColor,
                borderRadius: BorderRadius.circular(24),
              ),
              Column(children: [
                Text(
                  'You have 4 remaining',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                // Text(
                //   'Keep using the app to get benefits & bonus!',
                //   style: TextStyle(color: themeBloc.isDarkMode ? SubSyncColors.gray30 : SubSyncColors.gray60),
                // )
              ],)
            ],
          ),
        ),
      ),
    );
  }

    Widget _buildCustomSection({
    required String title,
    required Widget child,
    Widget? trailingWidget
    }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w800),
                // style: Theme.of(context).textTheme.textMd.copyWith(fontWeight: PiggyTextStyles.bold),
              ),
              if(trailingWidget!= null) trailingWidget 
            ],
          ),
          const SizedBox(height: 12),
          child
        ],
    );
  }

  BoxDecoration _boxDecoration({
    Color? backgroundColor,
    Color? borderColor,
  }) {
    return BoxDecoration(
        color: backgroundColor ?? (themeBloc.isDarkMode ? SubSyncColors.gray80 : SubSyncColors.gray0),
        borderRadius: BorderRadius.circular(16),
        border:  Border.all( width: 1, color: borderColor ?? Colors.transparent)
      );
  }

  SizedBox _buildAchievementList(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        children: [
          _buildAchievementListItem(icon: Icons.construction_rounded, title: '4', subtitle: 'In-progress'),
          _buildAchievementListItem(icon: Icons.check_circle_outlined, title: '14', subtitle: 'Total Sites', border: Border.symmetric(vertical: BorderSide(width: 1, color: themeBloc.isDarkMode ? SubSyncColors.gray70 : SubSyncColors.gray30))),
          _buildAchievementListItem(icon: Icons.attach_money_rounded, title: '44K', subtitle: 'Earnings'),
        ],
      ),
    );
  }

    Expanded _buildAchievementListItem({
    Border? border,
    // required String iconPath,
    required IconData icon,
    required String title,
    required String subtitle
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: border ?? const Border()
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // SvgPicture.asset(iconPath, width: 24, fit: BoxFit.scaleDown),
            Icon(icon),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              subtitle,
              style: TextStyle(color: themeBloc.isDarkMode ? SubSyncColors.gray30 : SubSyncColors.gray60),
            ),
          ],
        ),
      ) 
    );
  }

  SizedBox _buildUserDetails(BuildContext context) {
    return SizedBox(
      height: 86,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Member since April 2024',
            style: TextStyle(fontWeight: FontWeight.w600, color: themeBloc.isDarkMode ? SubSyncColors.gray30 : SubSyncColors.gray60),
          ),
          Text(
            'Melissa Johnson',
            style: TextStyle(fontWeight: FontWeight.w600, color: themeBloc.isDarkMode ? SubSyncColors.gray30 : SubSyncColors.gray60),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Female',
                style: TextStyle(fontWeight: FontWeight.w600, color: themeBloc.isDarkMode ? SubSyncColors.gray30 : SubSyncColors.gray60),
              ),
              const SizedBox(width: 12),
              Container(
                padding: EdgeInsets.all(2),
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: themeBloc.isDarkMode ? SubSyncColors.gray70 : SubSyncColors.gray20),
                ),
              const SizedBox(width: 12),
              Text(
                '26 year old',
                style: TextStyle(fontWeight: FontWeight.w600, color: themeBloc.isDarkMode ? SubSyncColors.gray30 : SubSyncColors.gray60),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBellIconButton() {
    return GestureDetector(
      onTap: () => (),
      child: Icon(Icons.notifications, size: 24, color: themeBloc.isDarkMode ? SubSyncColors.gray5 : SubSyncColors.gray80,),
    );
  }

  Widget _buildArrowBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pop(),
      child: Icon(Icons.arrow_back_ios, size: 24, color: themeBloc.isDarkMode ? SubSyncColors.gray5 : SubSyncColors.gray80,),
    );
  }
}