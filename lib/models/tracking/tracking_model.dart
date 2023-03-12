import 'package:fleetmanagement/models/tracking/track_data.dart';

class TrackingModel {
  bool? success;
  int? status;
  int? result;
  Pagination? pagination;
  List<TracksData>? tracks;

  TrackingModel(
      {this.success, this.status, this.result, this.pagination, this.tracks});

  TrackingModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    result = json['result'];
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['tracks'] != null) {
      tracks = [];
      json['tracks'].forEach((v) {
        tracks!.add(TracksData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['status'] = status;
    data['result'] = result;
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    if (tracks != null) {
      data['tracks'] = tracks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pagination {
  int? totalRecords;
  int? startRecord;
  int? currentPage;
  // Null sortParams;
  int? pageRecords;
  bool? hasPreviousPage;
  // Null qtype;
  bool? page;
  int? totalPages;
  // Null pagin;
  int? previousPage;
  int? nextPage;
  // Null rp;
  String? primaryKey;
  bool? directQuery;
  bool? hasNextPage;
  int? endRecord;

  Pagination(
      {this.totalRecords,
      this.startRecord,
      this.currentPage,
      this.pageRecords,
      this.hasPreviousPage,
      this.page,
      this.totalPages,
      this.previousPage,
      this.nextPage,
      this.primaryKey,
      this.directQuery,
      this.hasNextPage,
      this.endRecord});

  Pagination.fromJson(Map<String, dynamic> json) {
    totalRecords = json['totalRecords'];
    startRecord = json['startRecord'];
    currentPage = json['currentPage'];

    pageRecords = json['pageRecords'];
    hasPreviousPage = json['hasPreviousPage'];

    page = json['page'];
    totalPages = json['totalPages'];

    previousPage = json['previousPage'];
    nextPage = json['nextPage'];

    primaryKey = json['primaryKey'];
    directQuery = json['directQuery'];
    hasNextPage = json['hasNextPage'];
    endRecord = json['endRecord'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['totalRecords'] = totalRecords;
    data['startRecord'] = startRecord;
    data['currentPage'] = currentPage;

    data['pageRecords'] = pageRecords;
    data['hasPreviousPage'] = hasPreviousPage;

    data['page'] = page;
    data['totalPages'] = totalPages;

    data['previousPage'] = previousPage;
    data['nextPage'] = nextPage;

    data['primaryKey'] = primaryKey;
    data['directQuery'] = directQuery;
    data['hasNextPage'] = hasNextPage;
    data['endRecord'] = endRecord;
    return data;
  }
}
