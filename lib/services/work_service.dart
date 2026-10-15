import 'package:dio/dio.dart';
import 'package:subsync/models/all_work_model.dart';
import 'package:subsync/models/work_detail_model.dart';
import 'package:subsync/services/user_token_service.dart';

class WorkService {

  static Dio dio = Dio();

  static Future<AllWorkModel?> getAllWork() async {
    const String url = "http://10.0.2.2:8000/api/v1/user/work/";

    try{

      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization' : 'Bearer ${UserTokenService.accessToken}'
          }
        )
      );

      return AllWorkModel.fromJson(response.data);

    } on DioException catch(e) {
      if(e.response != null){
        print('Error fetching all work ${e.response}');
      }
      return null;
    }
  }

  static Future<WorkDetailModel?> getWorkDetails(String id) async {
    
    final String url = 'http://10.0.2.2:8000/api/v1/user/work/$id';

    try{
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization' : 'Bearer ${UserTokenService.accessToken}',
          }
        )
      );

      return WorkDetailModel.fromJson(response.data);

    }
    on DioException catch(e){
      if(e.response != null){
        print (e.response!.data['message']);
        return null;
      }
      return null;
    }
  
  }

    static Future<AllWorkModel?> getAllWorkListWithFilter(String? workDate, String? status) async {
    
    String url = 'http://10.0.2.2:8000/api/v1/user/work/';
    
    if(workDate != null) url = '$url?schedule__scheduled_date=$workDate';
    if(status != null){
      if(workDate == null) {url = '$url?status=${status.toUpperCase()}';} 
      else {url = '$url&status=${status.toUpperCase()}';}
    } 

    print(url);
     

    try{
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization' : 'Bearer ${UserTokenService.accessToken}',
          }
        )
      );

      return AllWorkModel.fromJson(response.data);

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
