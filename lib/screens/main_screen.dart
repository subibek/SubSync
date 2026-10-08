import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:subsync/blocs/theme_bloc.dart';
import 'package:subsync/services/change_notifier_service.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key, required this.navigationShell});

  StatefulNavigationShell navigationShell;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeBloc),
        ChangeNotifierProvider.value(value: changeNotifierService)
      ],
      child: Consumer<ChangeNotifierService>(
        builder: (context, notif, child){
          return Scaffold(
            bottomNavigationBar: NavigationBar(
              selectedIndex: changeNotifierService.mainScreenSelectedIndex,
              onDestinationSelected: (int index) {
                _onItemTapped(context, index);
                changeNotifierService.updateMainScreenSelectedIndex(index);
              } ,
              destinations: const <Widget>[
                NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
                NavigationDestination(icon: Icon(Icons.calendar_month), label: 'Schedule'),
                NavigationDestination(icon: Icon(Icons.design_services), label: 'Invoice'),
                NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
              ]
            ),

            body: SafeArea(
              child: widget.navigationShell,
            ),
          );
        }
      ),
    );
  }

  void _onItemTapped(BuildContext context, int index) async {
    widget.navigationShell.goBranch(index);
  }
}