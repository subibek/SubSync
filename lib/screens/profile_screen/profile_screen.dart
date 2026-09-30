import 'dart:collection';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:subsync/blocs/theme_bloc.dart';
import 'package:subsync/utils/colors.dart';
import 'package:subsync/utils/route/route_names.dart';
import 'package:subsync/utils/text_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      key: scaffoldKey,
      drawer: Drawer(
        shape: const Border(),
        width: 300,
        backgroundColor: themeBloc.isDarkMode ? SubSyncColors.gray80 : SubSyncColors.gray5,
        child: Column(
          children: [
            _buildDrawerContent(),
            const SizedBox(height: 24),
            _buildListTiles(),
          ],
        ),
      ),
      body: Center(
        child: Text(
          'Profile Screen',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

  Padding _buildListTiles() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildAppBarListTile(iconPath: 'assets/icons/ClockClockwise.svg', title: 'Activity', onTap: (){}),
          const SizedBox(height: 10),
          _buildAppBarListTile(iconPath: 'assets/icons/Chat.svg', title: 'Get Help', onTap: () => context.go('${RouteNames.profileScreen}${RouteNames.profileSettingsScreen}${RouteNames.helpCenterScreen}')),
          const SizedBox(height: 10),
          _buildAppBarListTile(iconPath: 'assets/icons/GearSix.svg', title: 'Settings', onTap: () => context.go("${RouteNames.profileScreen}${RouteNames.profileSettingsScreen}")),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24), 
            child: Divider(height: 1, color: themeBloc.isDarkMode ? SubSyncColors.gray70 : SubSyncColors.gray20)
          ),
          _buildAppBarListTile(iconPath: 'assets/icons/SignOut.svg', title: 'Sign Out', iconColor: SubSyncColors.destructive60, onTap: (){})
        ],
      ),
    );
  }

  Widget _buildAppBarListTile({required String iconPath, required String title, Color? iconColor, required GestureCancelCallback onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            SvgPicture.asset(iconPath, width: 24, colorFilter: ColorFilter.mode((iconColor != null) ? iconColor :SubSyncColors.gray40, BlendMode.srcIn)),
            const SizedBox(width: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.textSm.copyWith(fontWeight: SubSyncTextStyles.medium)
            )
          ],
        ),  
      ),
    );
  }

  Column _buildDrawerContent(){
    return Column(
      children: [
        Container(
          height: 190,
          color: themeBloc.currentColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: SubSyncColors.gray10,
                        border: Border.all(width: 0.4, color: SubSyncColors.gray40),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 8),
                            blurRadius: 16,
                            spreadRadius: 0,
                            color: const Color(0xff1C191708)
                          ),
                          BoxShadow(
                            offset: const Offset(0, 4),
                            blurRadius: 8,
                            spreadRadius: 0,
                            color: const Color(0xff1C191708).withOpacity(0.03)
                          )
                        ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                        child: Icon(Icons.person), 
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.notifications)
                  ],
                )
              ],
            ), 
          ),
        )
      ],
    );
  }
}