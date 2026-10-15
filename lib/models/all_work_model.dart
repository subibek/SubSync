import 'dart:convert';

class AllWorkModel {
    final String message;
    final Data data;
    final int status;
    final dynamic error;

    AllWorkModel({
        required this.message,
        required this.data,
        required this.status,
        required this.error,
    });

    factory AllWorkModel.fromRawJson(String str) => AllWorkModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory AllWorkModel.fromJson(Map<String, dynamic> json) => AllWorkModel(
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
    final List<WorkModel> results;
    final int page;

    Data({
        required this.total,
        required this.totalPage,
        required this.results,
        required this.page,
    });

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        total: json["total"],
        totalPage: json["total_page"],
        results: List<WorkModel>.from(json["results"].map((x) => WorkModel.fromJson(x))),
        page: json["page"],
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "total_page": totalPage,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "page": page,
    };
}

class WorkModel {
    final String id;
    final String schedule;
    final String status;
    final DateTime checkInTime;
    final DateTime? checkOutTime;
    final dynamic completionNotes;
    final String location;
    final List<dynamic> images;

    WorkModel({
        required this.id,
        required this.schedule,
        required this.status,
        required this.checkInTime,
        required this.checkOutTime,
        required this.completionNotes,
        required this.location,
        required this.images,
    });

    factory WorkModel.fromRawJson(String str) => WorkModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory WorkModel.fromJson(Map<String, dynamic> json) => WorkModel(
        id: json["id"],
        schedule: json["schedule"],
        status: json["status"],
        checkInTime: DateTime.parse(json["check_in_time"]),
        checkOutTime: json["check_out_time"] == null ? null : DateTime.parse(json["check_out_time"]),
        completionNotes: json["completion_notes"],
        location: json["location"],
        images: List<dynamic>.from(json["images"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "schedule": schedule,
        "status": status,
        "check_in_time": checkInTime.toIso8601String(),
        "check_out_time": checkOutTime?.toIso8601String(),
        "completion_notes": completionNotes,
        "location": location,
        "images": List<dynamic>.from(images.map((x) => x)),
    };
}
