import 'dart:convert';

class DashboardModel {
    final String message;
    final Data data;
    final int status;
    final dynamic error;

    DashboardModel({
        required this.message,
        required this.data,
        required this.status,
        required this.error,
    });

    factory DashboardModel.fromRawJson(String str) => DashboardModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
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
    final Sites sites;
    final Services services;
    final Invoices invoices;
    final Earnings earnings;

    Data({
        required this.sites,
        required this.services,
        required this.invoices,
        required this.earnings,
    });

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        sites: Sites.fromJson(json["sites"]),
        services: Services.fromJson(json["services"]),
        invoices: Invoices.fromJson(json["invoices"]),
        earnings: Earnings.fromJson(json["earnings"]),
    );

    Map<String, dynamic> toJson() => {
        "sites": sites.toJson(),
        "services": services.toJson(),
        "invoices": invoices.toJson(),
        "earnings": earnings.toJson(),
    };
}

class Earnings {
    final int approvedInvoiceCount;
    final double totalEarnings;

    Earnings({
        required this.approvedInvoiceCount,
        required this.totalEarnings,
    });

    factory Earnings.fromRawJson(String str) => Earnings.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Earnings.fromJson(Map<String, dynamic> json) => Earnings(
        approvedInvoiceCount: json["approved_invoice_count"],
        totalEarnings: json["total_earnings"],
    );

    Map<String, dynamic> toJson() => {
        "approved_invoice_count": approvedInvoiceCount,
        "total_earnings": totalEarnings,
    };
}

class Invoices {
    final int pending;
    final int approved;
    final int rejected;

    Invoices({
        required this.pending,
        required this.approved,
        required this.rejected,
    });

    factory Invoices.fromRawJson(String str) => Invoices.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Invoices.fromJson(Map<String, dynamic> json) => Invoices(
        pending: json["pending"],
        approved: json["approved"],
        rejected: json["rejected"],
    );

    Map<String, dynamic> toJson() => {
        "pending": pending,
        "approved": approved,
        "rejected": rejected,
    };
}

class Services {
    final int scheduled;
    final int completed;
    final int inProgress;
    final int missed;
    final int cancelled;

    Services({
        required this.scheduled,
        required this.completed,
        required this.inProgress,
        required this.missed,
        required this.cancelled,
    });

    factory Services.fromRawJson(String str) => Services.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Services.fromJson(Map<String, dynamic> json) => Services(
        scheduled: json["scheduled"],
        completed: json["completed"],
        inProgress: json["in_progress"],
        missed: json["missed"],
        cancelled: json["cancelled"],
    );

    Map<String, dynamic> toJson() => {
        "scheduled": scheduled,
        "completed": completed,
        "in_progress": inProgress,
        "missed": missed,
        "cancelled": cancelled,
    };
}

class Sites {
    final int assigned;

    Sites({
        required this.assigned,
    });

    factory Sites.fromRawJson(String str) => Sites.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Sites.fromJson(Map<String, dynamic> json) => Sites(
        assigned: json["assigned"],
    );

    Map<String, dynamic> toJson() => {
        "assigned": assigned,
    };
}
