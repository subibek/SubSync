import 'package:dio/dio.dart';
import 'package:subsync/models/invoice_details_model.dart';
import 'package:subsync/models/invoice_model.dart';
import 'package:subsync/services/user_token_service.dart';

class InvoiceService {

  static Dio dio = Dio();

  static Future<InvoiceListModel?> getInvoicesList() async {
    
    const String url = 'http://10.0.2.2:8000/api/v1/user/invoices/';

    try{
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization' : 'Bearer ${UserTokenService.accessToken}',
          }
        )
      );

      return InvoiceListModel.fromJson(response.data);

    }
    on DioException catch(e){
      if(e.response != null){
        print (e.response!.data['message']);
        return null;
      }
      return null;
    }
  
  }

    static Future<InvoiceDetailsModel?> getInvoiceDetails(String id) async {
    
    final String url = 'http://10.0.2.2:8000/api/v1/user/invoice/$id';

    try{
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization' : 'Bearer ${UserTokenService.accessToken}',
          }
        )
      );

      return InvoiceDetailsModel.fromJson(response.data);

    }
    on DioException catch(e){
      if(e.response != null){
        print (e.response!.data['message']);
        return null;
      }
      return null;
    }
  
  }

    static Future<InvoiceListModel?> getInvoicesListWithFilter(String? invoiceDate, String? status) async {
    
    String url = 'http://10.0.2.2:8000/api/v1/user/invoices/';
    
    if(invoiceDate != null) url = '$url?invoice_date=$invoiceDate';
    if(status != null) url = '$url&status=${status!.toUpperCase()}'; 

    try{
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization' : 'Bearer ${UserTokenService.accessToken}',
          }
        )
      );

      return InvoiceListModel.fromJson(response.data);

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