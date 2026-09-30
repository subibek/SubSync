import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subsync/models/schedule_details_model.dart';
import 'package:subsync/models/schedule_model.dart';
import 'package:subsync/services/user_token_service.dart';

class ScheduleService {

  static Dio dio = Dio();

  static Future<AllScheduleModel?> getUserSchedule() async {
    
    const String url = 'http://10.0.2.2:8000/api/v1/user/schedule';

    try{
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization' : 'Bearer ${UserTokenService.accessToken}',
          }
        )
      );
      return AllScheduleModel.fromJson(response.data);

    }
    on DioException catch(e){
      if(e.response != null){
        print (e.response!.data['message']);
        return null;
      }
      return null;
    }
  
  }

  static Future<ScheduleDetailsModel?> getScheduleDetails(String id) async {
    
    final String url = 'http://10.0.2.2:8000/api/v1/user/schedule/$id';

    try{
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization' : 'Bearer ${UserTokenService.accessToken}',
          }
        )
      );
      return ScheduleDetailsModel.fromJson(response.data);

    }
    on DioException catch(e){
      if(e.response != null){
        print (e.response!.data['message']);
        return null;
      }
      return null;
    }
  
  }
}
