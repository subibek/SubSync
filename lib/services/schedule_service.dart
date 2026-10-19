import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subsync/models/schedule_details_model.dart';
import 'package:subsync/models/schedule_model.dart';
import 'package:subsync/services/user_token_service.dart';

class ScheduleService {

  static Dio dio = Dio();

  // static Future<AllScheduleModel?> getUserSchedule() async {
    
  //   const String url = 'http://10.0.2.2:8000/api/v1/user/schedule';

  //   try{
  //     final response = await dio.get(
  //       url,
  //       options: Options(
  //         headers: {
  //           'Authorization' : 'Bearer ${UserTokenService.accessToken}',
  //         }
  //       )
  //     );

  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     prefs.setString('userSchedule', jsonEncode(response.data));

  //     AllScheduleModel schedule = AllScheduleModel.fromJson(response.data);

  //     return schedule;

  //   }
  //   on DioException catch(e){
  //     if(e.response != null){
  //       print (e.response!.data['message']);
  //       return null;
  //     }
  //     return null;
  //   }
  
  // }



static Future<AllScheduleModel?> getUserSchedule() async {
  const String baseUrl =
      'http://10.0.2.2:8000/api/v1/user/schedule';

  try {
    final options = Options(
      headers: {'Authorization':'Bearer ${UserTokenService.accessToken}'});

    final List<dynamic> allResults = [];
    Map<String, dynamic>? firstPage;

    int page = 1;
    int totalPages = 1;

    // Fetch every page from the API.
    do {
      final response = await dio.get(
        baseUrl,
        queryParameters: {'page': page},
        options: options,
      );

      final responseBody = Map<String, dynamic>.from(response.data as Map);

      // Extract the nested "data" object.
      final data = Map<String, dynamic>.from(responseBody['data'] as Map);

      firstPage ??= data;

      // Collect results from the current page.
      final results = data['results'];

      if (results is List) {
        allResults.addAll(results);
      } else if (results != null) {
        throw FormatException(
          'Expected results to be a List, '
          'got ${results.runtimeType}',
        );
      }
      totalPages =
          int.tryParse(data['total_page'].toString()) ?? 1;

      page++;
    } while (page <= totalPages);

    final mergedData = {
      ...firstPage,
      'results': allResults,
      'page': 1,
    };

    final mergedResponse = <String, dynamic>{
      'message': 'User cleaning schedules retrieved successfully.',
      'data': mergedData,
      'status': 200,
      'error': null,
    };

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userSchedule',jsonEncode(mergedResponse));

    // Parse the full response using your existing model.
    return AllScheduleModel.fromJson(mergedResponse);
  } on DioException catch (e) {
    return null;
  } catch (e, stackTrace) {
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
        // print (e.response!.data['message']);
        return null;
      }
      return null;
    }
  
  }
}
