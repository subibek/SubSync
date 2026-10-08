import 'dart:convert';

class InvoiceListModel {
    final String message;
    final Data data;
    final int status;
    final dynamic error;

    InvoiceListModel({
        required this.message,
        required this.data,
        required this.status,
        required this.error,
    });

    factory InvoiceListModel.fromRawJson(String str) => InvoiceListModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory InvoiceListModel.fromJson(Map<String, dynamic> json) => InvoiceListModel(
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
    final List<InvoiceModel> results;
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
        results: List<InvoiceModel>.from(json["results"].map((x) => InvoiceModel.fromJson(x))),
        page: json["page"],
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "total_page": totalPage,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "page": page,
    };
}

class InvoiceModel {
    final String id;
    final String invoiceNumber;
    final Site site;
    final DateTime invoiceDate;
    final DateTime servicePeriodStart;
    final DateTime servicePeriodEnd;
    final String amount;
    final String remarks;
    final String status;

    InvoiceModel({
        required this.id,
        required this.invoiceNumber,
        required this.site,
        required this.invoiceDate,
        required this.servicePeriodStart,
        required this.servicePeriodEnd,
        required this.amount,
        required this.remarks,
        required this.status,
    });

    factory InvoiceModel.fromRawJson(String str) => InvoiceModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
        id: json["id"],
        invoiceNumber: json["invoice_number"],
        site: Site.fromJson(json["site"]),
        invoiceDate: DateTime.parse(json["invoice_date"]),
        servicePeriodStart: DateTime.parse(json["service_period_start"]),
        servicePeriodEnd: DateTime.parse(json["service_period_end"]),
        amount: json["amount"],
        remarks: json["remarks"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "invoice_number": invoiceNumber,
        "site": site.toJson(),
        "invoice_date": "${invoiceDate.year.toString().padLeft(4, '0')}-${invoiceDate.month.toString().padLeft(2, '0')}-${invoiceDate.day.toString().padLeft(2, '0')}",
        "service_period_start": "${servicePeriodStart.year.toString().padLeft(4, '0')}-${servicePeriodStart.month.toString().padLeft(2, '0')}-${servicePeriodStart.day.toString().padLeft(2, '0')}",
        "service_period_end": "${servicePeriodEnd.year.toString().padLeft(4, '0')}-${servicePeriodEnd.month.toString().padLeft(2, '0')}-${servicePeriodEnd.day.toString().padLeft(2, '0')}",
        "amount": amount,
        "remarks": remarks,
        "status": status,
    };
}

class Site {
    final String id;
    final String name;

    Site({
        required this.id,
        required this.name,
    });

    factory Site.fromRawJson(String str) => Site.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Site.fromJson(Map<String, dynamic> json) => Site(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
