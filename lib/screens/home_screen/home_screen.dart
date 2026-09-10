import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:subsync/blocs/theme_bloc.dart';
import 'package:subsync/utils/colors.dart';
import 'package:subsync/utils/route/route_names.dart';
import 'package:subsync/widgets/custom_list_tile.dart';
import 'package:subsync/widgets/custom_profile_settings_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: (){
              context.push('${RouteNames.homeScreen}${RouteNames.notificationScreen}');
            },
            child: SvgPicture.asset('assets/icons/bell.svg'),
          ),
          const SizedBox(width: 20)
        ],
      ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Shortcuts', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 15),
              Row(
                spacing: 5,
                children: [
                  Expanded(
                    child: CustomListTile(
                      onTap: () => context.go('${RouteNames.homeScreen}${RouteNames.punchScreen}'),
                      child: Center(child: Text('Punch', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
                    ),
                  ),
                  Expanded(
                    child: CustomListTile(
                      onTap: () {},
                      child: Center(child: Text('My Invoices', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
                    ),
                  )
                ],
              )
            ],
          ),
        )
    );
  }
}

