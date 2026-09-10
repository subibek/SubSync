import 'package:flutter/material.dart';
import 'package:subsync/blocs/theme_bloc.dart';
import 'package:subsync/screens/splash_screen/splash_screen.dart';
import 'package:subsync/utils/route/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppTheme>(
      stream: themeBloc.themeStream,
      initialData: themeBloc.currentTheme,
      builder: (context, snapshot) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: AppRoutes.router,
          theme: snapshot.data!.data,
          title: 'Subsync',
        );
      }
    );
  }
}


