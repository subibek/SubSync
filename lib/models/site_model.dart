import 'dart:convert';

class AllSitesModel {
    final String message;
    final Data data;
    final int status;
    final dynamic error;

    AllSitesModel({
        required this.message,
        required this.data,
        required this.status,
        required this.error,
    });

    factory AllSitesModel.fromRawJson(String str) => AllSitesModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory AllSitesModel.fromJson(Map<String, dynamic> json) => AllSitesModel(
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
    final List<Result> results;
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
        results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
        page: json["page"],
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "total_page": totalPage,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "page": page,
    };
}

class Result {
    final String id;
    final String name;
    final String address;
    final String cleaningFrequency;
    final String price;
    final String clientId;
    final String cleaningInstructions;
    final List<dynamic> images;
    final String assignedContractor;

    Result({
        required this.id,
        required this.name,
        required this.address,
        required this.cleaningFrequency,
        required this.price,
        required this.clientId,
        required this.cleaningInstructions,
        required this.images,
        required this.assignedContractor,
    });

    factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        cleaningFrequency: json["cleaning_frequency"],
        price: json["price"],
        clientId: json["client_id"],
        cleaningInstructions: json["cleaning_instructions"],
        images: List<dynamic>.from(json["images"].map((x) => x)),
        assignedContractor: json["assigned_contractor"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "cleaning_frequency": cleaningFrequency,
        "price": price,
        "client_id": clientId,
        "cleaning_instructions": cleaningInstructions,
        "images": List<dynamic>.from(images.map((x) => x)),
        "assigned_contractor": assignedContractor,
    };
}
