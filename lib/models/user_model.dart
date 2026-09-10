import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    final String message;
    final Data data;
    final int status;
    final dynamic error;

    UserModel({
        required this.message,
        required this.data,
        required this.status,
        required this.error,
    });

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
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
    final Token token;
    final String role;

    Data({
        required this.token,
        required this.role,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: Token.fromJson(json["token"]),
        role: json["role"],
    );

    Map<String, dynamic> toJson() => {
        "token": token.toJson(),
        "role": role,
    };
}

class Token {
    final String refresh;
    final String access;

    Token({
        required this.refresh,
        required this.access,
    });

    factory Token.fromJson(Map<String, dynamic> json) => Token(
        refresh: json["refresh"],
        access: json["access"],
    );

    Map<String, dynamic> toJson() => {
        "refresh": refresh,
        "access": access,
    };
}
