import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subsync/models/clock_in_model.dart';
import 'package:subsync/models/schedule_model.dart';
import 'package:subsync/services/user_token_service.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:collection/collection.dart';


class LocationService {

  final double siteLatitude;
  final double siteLongitude;
  final double allowRadiusMeters;

  LocationService({
    required this.siteLatitude,
    required this.siteLongitude,
    required this.allowRadiusMeters
  });

  Dio dio = Dio();

  Future<bool> ensurePermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }
    if(permission == LocationPermission.deniedForever){
      return false;
    }
    if(!await Geolocator.isLocationServiceEnabled()){
      return false;
    }
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  Future<String> canClockIn(String siteAddress) async {
    final hasPermission = await ensurePermission();
    if(!hasPermission){
      return "Denied. No location service.";
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high)
    );

    if(position.isMocked){return "Denied. mock location detected.";}

    final distance = Geolocator.distanceBetween(
      position.latitude, position.longitude,
      siteLatitude,
      siteLongitude
    );

    if(distance <= allowRadiusMeters) {

      final result = await clockIn(siteAddress);
      return result;
    } else {
      return "Denied: you are ${distance.toStringAsFixed(0)}m from site.";
    }
  }

  Future<String> clockIn(String siteAddress) async {
    const String url = "http://10.0.2.2:8000/api/v1/user/clock-in/";
    try{

      String? scheduleId = await getScheduleId(siteAddress);
      if(scheduleId == "No Schedule"){ return "No schedule found for this site";}

      Response response = await dio.post(
        url,
        options: Options(
          headers: {
            'Authorization' : 'Bearer ${UserTokenService.accessToken}',
          }
        ),
        data: {
          "schedule": scheduleId,
          "location": siteAddress
        }
      );

      ClockInModel clockInDetails = ClockInModel.fromJson(response.data);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(scheduleId, jsonEncode(clockInDetails));

      if(response.statusCode == 201){
        return "Success";
      } else {
        return response.extra['error'];
      }


    } on DioException catch(e){

      if (e.response != null){
        print(e.response!.data['message']);
      }
      return e.response?.data['error'] ?? "Failed";
    }
  }

    Future<String> clockOut(String siteAddress, String? completionNotes, List? images) async {

      String? scheduleId = await getScheduleId(siteAddress);
      if(scheduleId == "No Schedule"){ return "No schedule found for this site";}

      SharedPreferences prefs = await SharedPreferences.getInstance();
      final clockInDetails = prefs.getString(scheduleId);
      ClockInModel details = ClockInModel.fromJson(jsonDecode(clockInDetails!));

      String url = "http://10.0.2.2:8000/api/v1/user/clock-out/${details.data.id}/";
    try{

      Response response = await dio.patch(
        url,
        options: Options(
          headers: {
            'Authorization' : 'Bearer ${UserTokenService.accessToken}',
          }
        ),
        data: {
          "completion_notes": completionNotes,
          "location": siteAddress,
          "images": images 
        }
      );

      if(response.statusCode == 200){

        return "Success";
      } else {
        return "Failed";
      }


    } on DioException catch(e){

      if (e.response != null){
        print(e.response!.data['message']);
      }
      return "Failed";
    }
  }

  Future<String> getScheduleId(String siteAddress) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userSchedule = prefs.getString('userSchedule');

    AllScheduleModel allSchedule = AllScheduleModel.fromJson(jsonDecode(userSchedule!));

    ScheduleModel? schedule = allSchedule.data.results.firstWhereOrNull((item) =>
        item.site.address == siteAddress 
        && isSameDay(item.scheduledDate, DateTime.now())
        && item.status == "SCHEDULED",
    );
    if(schedule == null) return "No Schedule";
    return schedule.id;
  }

}
