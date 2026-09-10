import 'package:flutter/material.dart';

final changeNotifierService = ChangeNotifierService();

class ChangeNotifierService with ChangeNotifier {

  int _mainScreenSelectedIndex = 0;
  // bool _showBNB = true;

  int get mainScreenSelectedIndex => _mainScreenSelectedIndex;
  // bool get showBNB => _showBNB

  void updateMainScreenSelectedIndex(int index) {
    _mainScreenSelectedIndex = index;
    notifyListeners();
  }

  // void updateShowBNB(bool value) {
  //   _showBNB = value;
  //   notifyListeners();
  // }
}