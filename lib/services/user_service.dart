import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subsync/models/user_model.dart';

class UserService {

  static Dio dio = Dio();

  static Future<String> login(String username, String password) async {
    
    const String url = "http://10.0.2.2:8000/api/v1/user/login/";
    final data = {'username':username, 'password':password};
    
    try{

      Response response = await dio.post(
        url,
        data: data,
        options: Options(
          headers: {'Content-Type':'application/json', 'Accept':'application/json'}
        ),
      );

      if(response.statusCode == 200){

        Map<String, dynamic> data = response.data;

        UserModel user = UserModel.fromJson(data);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("currentUser", jsonEncode(user));
        prefs.setBool("isUserLoggedIn", true);

        return "Success";
      } else {
        return response.statusCode.toString();
      }


    } on DioException catch(e){
      if (e.response != null){
        return e.response!.data['message'];
      }
      return "Failed";
    }

  } 


  static Future<String> logout() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentUser');
    await prefs.setBool('isUserLoggedIn', false);

    return 'Success';
  }

}
