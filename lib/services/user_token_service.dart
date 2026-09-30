
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserTokenService {
  static String? accessToken;
  static String? refreshToken;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final tokens = prefs.getString('currentUser');
    if(tokens != null){
      final currentUser = jsonDecode(tokens);

      accessToken = currentUser['data']['token']['access'];
      refreshToken = currentUser['data']['token']['refresh'];
    }
  }
}
