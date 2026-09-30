// To parse this JSON data, do
//
//     final allSchedule = allScheduleFromJson(jsonString);

import 'dart:convert';

AllScheduleModel allScheduleFromJson(String str) => AllScheduleModel.fromJson(json.decode(str));

String allScheduleToJson(AllScheduleModel data) => json.encode(data.toJson());

class AllScheduleModel {
    final String message;
    final Data data;
    final int status;
    final dynamic error;

    AllScheduleModel({
        required this.message,
        required this.data,
        required this.status,
        required this.error,
    });

    factory AllScheduleModel.fromJson(Map<String, dynamic> json) => AllScheduleModel(
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
    final int total;
    final int totalPage;
    final List<ScheduleModel> results;
    final int page;

    Data({
        required this.total,
        required this.totalPage,
        required this.results,
        required this.page,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        total: json["total"],
        totalPage: json["total_page"],
        results: List<ScheduleModel>.from(json["results"].map((x) => ScheduleModel.fromJson(x))),
        page: json["page"],
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "total_page": totalPage,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "page": page,
    };
}

class ScheduleModel {
    final String id;
    final Site site;
    final DateTime scheduledDate;
    final String scheduledTime;
    final String notes;
    final String status;
    final CreatedBy createdBy;

    ScheduleModel({
        required this.id,
        required this.site,
        required this.scheduledDate,
        required this.scheduledTime,
        required this.notes,
        required this.status,
        required this.createdBy,
    });

    factory ScheduleModel.fromJson(Map<String, dynamic> json) => ScheduleModel(
        id: json["id"],
        site: Site.fromJson(json["site"]),
        scheduledDate: DateTime.parse(json["scheduled_date"]),
        scheduledTime: json["scheduled_time"],
        notes: json["notes"],
        status: json["status"],
        createdBy: CreatedBy.fromJson(json["created_by"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "site": site.toJson(),
        "scheduled_date": "${scheduledDate.year.toString().padLeft(4, '0')}-${scheduledDate.month.toString().padLeft(2, '0')}-${scheduledDate.day.toString().padLeft(2, '0')}",
        "scheduled_time": scheduledTime,
        "notes": notes,
        "status": status,
        "created_by": createdBy.toJson(),
    };
}

class CreatedBy {
    final String id;
    final String username;

    CreatedBy({
        required this.id,
        required this.username,
    });

    factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
        id: json["id"],
        username: json["username"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
    };
}

class Site {
    final String id;
    final String name;
    final String address;
    final String cleaningFrequency;
    final String cleaningInstructions;
    final CreatedBy assignedContractor;

    Site({
        required this.id,
        required this.name,
        required this.address,
        required this.cleaningFrequency,
        required this.cleaningInstructions,
        required this.assignedContractor,
    });

    factory Site.fromJson(Map<String, dynamic> json) => Site(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        cleaningFrequency: json["cleaning_frequency"],
        cleaningInstructions: json["cleaning_instructions"],
        assignedContractor: CreatedBy.fromJson(json["assigned_contractor"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "cleaning_frequency": cleaningFrequency,
        "cleaning_instructions": cleaningInstructions,
        "assigned_contractor": assignedContractor.toJson(),
    };
}
