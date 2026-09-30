import 'dart:convert';

class UserInfoModel {
    final String message;
    final Data data;
    final int status;
    final dynamic error;

    UserInfoModel({
        required this.message,
        required this.data,
        required this.status,
        required this.error,
    });

    factory UserInfoModel.fromRawJson(String str) => UserInfoModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory UserInfoModel.fromJson(Map<String, dynamic> json) => UserInfoModel(
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
    final String username;
    final String email;
    final dynamic firstName;
    final dynamic lastName;
    final String role;
    final dynamic phone;

    Data({
        required this.id,
        required this.username,
        required this.email,
        required this.firstName,
        required this.lastName,
        required this.role,
        required this.phone,
    });

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        role: json["role"],
        phone: json["phone"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "role": role,
        "phone": phone,
    };
}
