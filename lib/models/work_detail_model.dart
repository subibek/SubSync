import 'dart:convert';

class WorkDetailModel {
    final String message;
    final Data data;
    final int status;
    final dynamic error;

    WorkDetailModel({
        required this.message,
        required this.data,
        required this.status,
        required this.error,
    });

    factory WorkDetailModel.fromRawJson(String str) => WorkDetailModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory WorkDetailModel.fromJson(Map<String, dynamic> json) => WorkDetailModel(
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
    final Schedule schedule;
    final String status;
    final DateTime checkInTime;
    final DateTime checkOutTime;
    final dynamic completionNotes;
    final String location;
    final List<dynamic> images;

    Data({
        required this.id,
        required this.schedule,
        required this.status,
        required this.checkInTime,
        required this.checkOutTime,
        required this.completionNotes,
        required this.location,
        required this.images,
    });

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        schedule: Schedule.fromJson(json["schedule"]),
        status: json["status"],
        checkInTime: DateTime.parse(json["check_in_time"]),
        checkOutTime: DateTime.parse(json["check_out_time"]),
        completionNotes: json["completion_notes"],
        location: json["location"],
        images: List<dynamic>.from(json["images"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "schedule": schedule.toJson(),
        "status": status,
        "check_in_time": checkInTime.toIso8601String(),
        "check_out_time": checkOutTime.toIso8601String(),
        "completion_notes": completionNotes,
        "location": location,
        "images": List<dynamic>.from(images.map((x) => x)),
    };
}

class Schedule {
    final String id;
    final Site site;
    final DateTime scheduledDate;
    final String scheduledTime;
    final String notes;
    final String status;
    final CreatedBy createdBy;

    Schedule({
        required this.id,
        required this.site,
        required this.scheduledDate,
        required this.scheduledTime,
        required this.notes,
        required this.status,
        required this.createdBy,
    });

    factory Schedule.fromRawJson(String str) => Schedule.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
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

    factory CreatedBy.fromRawJson(String str) => CreatedBy.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

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

    factory Site.fromRawJson(String str) => Site.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

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
