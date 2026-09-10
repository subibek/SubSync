import 'dart:async';
import 'package:flutter/material.dart';
import 'package:subsync/utils/colors.dart';


final themeBloc = ThemeBloc();


class ThemeBloc extends ChangeNotifier{

  late AppTheme _currentTheme;
  final _themeController = StreamController<AppTheme>.broadcast();
  bool _isDarkMode = true;
  Color _currentColor = SubSyncColors.brand50;
  Stream<AppTheme> get themeStream => _themeController.stream;


  AppTheme get currentTheme => _currentTheme;
  bool get isDarkMode => _isDarkMode;
  Color get currentColor => _currentColor;

  ThemeBloc(){
    _currentTheme = AppTheme(data: buildAppTheme(_currentColor, _isDarkMode));
    _themeController.sink.add(_currentTheme);
  }

  @override
  void dispose() {
    _themeController.close();
    super.dispose();
  }

  void toggleDarkMode(bool isDarkMode) {
    _isDarkMode = isDarkMode;
    _currentTheme = AppTheme(data: buildAppTheme(_currentColor, _isDarkMode));
    _themeController.sink.add(_currentTheme);
    notifyListeners();
  }

  void updateColor(Color color) {
    _currentColor = color;
    _currentTheme = AppTheme(data: buildAppTheme(_currentColor, _isDarkMode));
    _themeController.sink.add(_currentTheme);
    notifyListeners();
  }

  ThemeData buildAppTheme(Color seedColor, bool isDarkMode) {
    return ThemeData(
      scaffoldBackgroundColor: isDarkMode ? SubSyncColors.gray100 : SubSyncColors.gray10,
      // fontFamily: '', 
      // pageTransitionsTheme: 
      // textTheme: 
      primaryColor: seedColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: _isDarkMode ? Brightness.dark : Brightness.light
      ),

      useMaterial3:  true,
      appBarTheme:  AppBarTheme(
        // centerTitle: true,
        backgroundColor: isDarkMode ? SubSyncColors.gray90 : SubSyncColors.gray5,
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDarkMode ? SubSyncColors.gray80 : SubSyncColors.gray0,
        height: 60,
        indicatorColor: isDarkMode ? SubSyncColors.gray90 : SubSyncColors.gray5,
        // indicatorShape: null
      )
    );
  }
}


class AppTheme {
  final ThemeData data;
  
  AppTheme({ required this.data});
}