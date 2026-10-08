import 'package:dio/dio.dart';
import 'package:subsync/models/site_model.dart';
import 'package:subsync/services/user_token_service.dart';

class SiteService{

  static Dio dio = Dio();

  static Future<AllSitesModel?> getAllSites() async {
    const String url = "http://10.0.2.2:8000/api/v1/user/user-sites/";
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
        AllSitesModel allSites = AllSitesModel.fromJson(data);

        return allSites;
      } else {
        return null;
      }


    } on DioException catch(e){

      if (e.response != null){
        print(e.response!.data['message']);
      }
      return null;
    }
  }

}