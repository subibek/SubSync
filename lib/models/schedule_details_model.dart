class ScheduleDetailsModel {
  final String message;
  final ScheduleDetailsData data;
  final int status;
  final dynamic error;

  ScheduleDetailsModel({
    required this.message,
    required this.data,
    required this.status,
    this.error,
  });

  factory ScheduleDetailsModel.fromJson(Map<String, dynamic> json) {
    return ScheduleDetailsModel(
      message: json["message"],
      data: ScheduleDetailsData.fromJson(json["data"]),
      status: json["status"],
      error: json["error"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "data": data.toJson(),
      "status": status,
      "error": error,
    };
  }
}

class ScheduleDetailsData {
  final String id;
  final SiteDetails site;
  final DateTime scheduledDate;
  final String scheduledTime;
  final String notes;
  final String status;
  final CreatedBy createdBy;

  ScheduleDetailsData({
    required this.id,
    required this.site,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.notes,
    required this.status,
    required this.createdBy,
  });

  factory ScheduleDetailsData.fromJson(Map<String, dynamic> json) {
    return ScheduleDetailsData(
      id: json["id"],
      site: SiteDetails.fromJson(json["site"]),
      scheduledDate: DateTime.parse(json["scheduled_date"]),
      scheduledTime: json["scheduled_time"],
      notes: json["notes"],
      status: json["status"],
      createdBy: CreatedBy.fromJson(json["created_by"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "site": site.toJson(),
      "scheduled_date":
          "${scheduledDate.year.toString().padLeft(4, '0')}-"
          "${scheduledDate.month.toString().padLeft(2, '0')}-"
          "${scheduledDate.day.toString().padLeft(2, '0')}",
      "scheduled_time": scheduledTime,
      "notes": notes,
      "status": status,
      "created_by": createdBy.toJson(),
    };
  }
}

class SiteDetails {
  final String id;
  final String name;
  final String address;
  final String cleaningFrequency;
  final String cleaningInstructions;
  final AssignedContractor assignedContractor;

  SiteDetails({
    required this.id,
    required this.name,
    required this.address,
    required this.cleaningFrequency,
    required this.cleaningInstructions,
    required this.assignedContractor,
  });

  factory SiteDetails.fromJson(Map<String, dynamic> json) {
    return SiteDetails(
      id: json["id"],
      name: json["name"],
      address: json["address"],
      cleaningFrequency: json["cleaning_frequency"],
      cleaningInstructions: json["cleaning_instructions"],
      assignedContractor:
          AssignedContractor.fromJson(json["assigned_contractor"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "address": address,
      "cleaning_frequency": cleaningFrequency,
      "cleaning_instructions": cleaningInstructions,
      "assigned_contractor": assignedContractor.toJson(),
    };
  }
}

class AssignedContractor {
  final String id;
  final String username;

  AssignedContractor({
    required this.id,
    required this.username,
  });

  factory AssignedContractor.fromJson(Map<String, dynamic> json) {
    return AssignedContractor(
      id: json["id"],
      username: json["username"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
    };
  }
}

class CreatedBy {
  final String id;
  final String username;

  CreatedBy({
    required this.id,
    required this.username,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      id: json["id"],
      username: json["username"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
    };
  }
}