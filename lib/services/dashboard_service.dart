import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subsync/models/dashboard_model.dart';
import 'package:subsync/services/user_token_service.dart';

class DashboardService {

  static Dio dio = Dio();

  static Future<DashboardModel?> getDashboard() async {
    
    String url = "http://10.0.2.2:8000/api/v1/user/dashboard/";

    try{

      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization' : 'Bearer ${UserTokenService.accessToken}',
          }
         ) 
      );

      final result = DashboardModel.fromJson(response.data);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userDashboard', jsonEncode(result));

      return result;

    } on DioException catch(e){
        print('Exception when fetching dashboard ${e.message}');
        return null;
    }

  }

}