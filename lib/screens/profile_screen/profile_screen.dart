import 'dart:collection';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:subsync/blocs/theme_bloc.dart';
import 'package:subsync/utils/colors.dart';
import 'package:subsync/utils/route/route_names.dart';

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
          _buildAppBarListTile(icon: Icon(Icons.local_activity, color: SubSyncColors.gray20,), title: 'Activity', onTap: (){}),
          const SizedBox(height: 10),
          _buildAppBarListTile(icon: Icon(Icons.comment, color: SubSyncColors.gray20,), title: 'Get Help', onTap: (){}),
          const SizedBox(height: 10),
          _buildAppBarListTile(icon: Icon(Icons.settings, color: SubSyncColors.gray20,), title: 'Settings',
            onTap: (){
                  context.go("${RouteNames.profileScreen}${RouteNames.profileSettingsScreen}");

            }
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24), 
            child: Divider(height: 1, color: themeBloc.isDarkMode ? SubSyncColors.gray70 : SubSyncColors.gray20)
          ),
          _buildAppBarListTile(icon: Icon(Icons.exit_to_app, color: SubSyncColors.destructive60,), title: 'Sign Out', iconColor: SubSyncColors.destructive60, onTap: (){})
        ],
      ),
    );
  }

  Widget _buildAppBarListTile({required Widget icon, required String title, Color? iconColor, required GestureCancelCallback onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
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