import 'dart:convert';

class ClockInModel {
    final String message;
    final Data data;
    final int status;
    final dynamic error;

    ClockInModel({
        required this.message,
        required this.data,
        required this.status,
        required this.error,
    });

    factory ClockInModel.fromRawJson(String str) => ClockInModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ClockInModel.fromJson(Map<String, dynamic> json) => ClockInModel(
        message: json["message"],
        data: Data.fromJson(json["data"]),
        status: json["status"],
        error: json["error"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
        "status": status,
        "error": error,
    };
}

class Data {
    final String id;
    final String schedule;
    final DateTime checkInTime;
    final String location;

    Data({
        required this.id,
        required this.schedule,
        required this.checkInTime,
        required this.location,
    });

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        schedule: json["schedule"],
        checkInTime: DateTime.parse(json["check_in_time"]),
        location: json["location"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "schedule": schedule,
        "check_in_time": checkInTime.toIso8601String(),
        "location": location,
    };
}
