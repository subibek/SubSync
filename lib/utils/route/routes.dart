
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:subsync/screens/authentication_screens/forgot_password.dart';
import 'package:subsync/screens/authentication_screens/sign_in_screen.dart';
import 'package:subsync/screens/home_screen/home_screen.dart';
import 'package:subsync/screens/home_screen/punch_screen.dart';
import 'package:subsync/screens/main_screen.dart';
import 'package:subsync/screens/notification_screen.dart';
import 'package:subsync/screens/profile_screen/profile_screen.dart';
import 'package:subsync/screens/profile_screen/profile_settings_screen.dart';
import 'package:subsync/screens/schedule_screen/schedule_screen.dart';
import 'package:subsync/screens/services_screen/services_screen.dart';
import 'package:subsync/screens/splash_screen/splash_screen.dart';
import 'package:subsync/utils/route/route_names.dart';

class AppRoutes {
  static GlobalKey<NavigatorState> rootNavigationKey = GlobalKey<NavigatorState>(debugLabel: 'root');
  static GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

  static GoRouter router = GoRouter(
    initialLocation: '/',
    // initialLocation: '/homeScreen',

    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state){
          return const SplashScreen();
        }
      ),
      GoRoute(
        path: RouteNames.signInScreen,
        builder: (BuildContext context, GoRouterState state) {
          return const SignInScreen();
        } 
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        builder: (BuildContext context, GoRouterState state) {
          return const ForgotPasswordScreen();
        } 
      ),


      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => MainScreen(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: RouteNames.homeScreen,
                builder: (context, state) => const HomeScreen(), 
                routes: [
                  GoRoute(
                    path: RouteNames.punchScreen,
                    builder: (context, state) => const PunchScreen(), 
                  ),
                   GoRoute(
                    path: RouteNames.notificationScreen,
                    builder: (context, state) => const NotificationScreen(), 
                  )
                ]
              )
            ] 
          ),

          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: RouteNames.scheduleScreen,
                builder: (context, state) => const ScheduleScreen(), 
              )
            ] 
          ),

          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: RouteNames.servicesScreen,
                builder: (context, state) => const ServicesScreen(), 
              )
            ] 
          ),

          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: RouteNames.profileScreen,
                builder: (context, state) => const ProfileScreen(), 
                routes: [
                  GoRoute(
                    path: RouteNames.profileSettingsScreen,
                    builder: (context, state) => const ProfileSettingsScreen(), 
                  )
                ]
              )
            ] 
          )
        ]
      )
    ] 
  );
}