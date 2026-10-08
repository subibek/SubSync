import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subsync/models/user_info_model.dart';
import 'package:subsync/models/user_model.dart';
import 'package:subsync/screens/profile_screen/sub_screens/profile_info_screen.dart';
import 'package:subsync/services/user_token_service.dart';

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

        //Store and assign token to be accessable
        final userTokenService = UserTokenService();
        userTokenService.init();

        //Get user info
        Future.delayed(Duration(seconds: 1),() async {
          await getUserInfo();
        });

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

  static Future<String?> updateUserInfo(UserInfoModel currentUserInfo, String firstname, String lastname, String number) async {
    const String url = "http://10.0.2.2:8000/api/v1/user/user-detail/";
    try{
      Response response = await dio.put(
        url,
        options: Options(
          headers: {
            'Authorization' : 'Bearer ${UserTokenService.accessToken}',
          }
        ),
        data: {
          "first_name": firstname,
          "last_name": lastname,
          "phone": number
        }
      );

      if(response.statusCode == 200){

        currentUserInfo.data.firstName = response.data['data']['first_name'];
        currentUserInfo.data.lastName = response.data['data']['last_name'];  
        currentUserInfo.data.phone = response.data['data']['phone']; 

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("currentUserInfo", jsonEncode(currentUserInfo));

        ProfileInfoScreen.firstNameController.text = currentUserInfo.data.firstName;
        ProfileInfoScreen.lastNameController.text = currentUserInfo.data.lastName;
        ProfileInfoScreen.phoneNumberController.text = currentUserInfo.data.phone;

        return "Success";
      } else {
        return null;
      }


    } on DioException catch(e){

      if (e.response != null){
        (e.response!.data['message']);
        return null;
      }
      return null;
    }

  }


  static Future<String> getUserInfo() async {
    
    const String url = "http://10.0.2.2:8000/api/v1/user/user-info/";
    try{
      Response response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization' : 'Bearer ${UserTokenService.accessToken}',
          }
        )
      );


      if(response.statusCode == 200){

        Map<String, dynamic> data = response.data;

        UserInfoModel userInfo = UserInfoModel.fromJson(data);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("currentUserInfo", jsonEncode(userInfo));

        ProfileInfoScreen.usernameController.text = userInfo.data.username;
        ProfileInfoScreen.firstNameController.text = userInfo.data.firstName;
        ProfileInfoScreen.lastNameController.text = userInfo.data.lastName;
        ProfileInfoScreen.emailController.text = userInfo.data.email;
        ProfileInfoScreen.phoneNumberController.text = userInfo.data.phone;
        ProfileInfoScreen.roleController.text = userInfo.data.role;


        return "Success";
      } else {
        return response.statusCode.toString();
      }


    } on DioException catch(e){

      if (e.response != null){
        return(e.response!.data['message']);
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
