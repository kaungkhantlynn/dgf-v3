import 'package:fleetmanagement/models/mng/vehicles_management/vehicles/vehicle_data.dart';

class Vehicles {
  bool? success;
  int? status;
  List<VehicleData>? data;


  Vehicles({this.success, this.status, this.data});

  Vehicles.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    if (json['data'] != null) {
      data = <VehicleData>[];
      json['data'].forEach((v) {
        data!.add(VehicleData.fromJson(v));
      });
    }
    // links = json['links'] != null ? Links.fromJson(json['links']) : null;
    // meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    // if (links != null) {
    //   data['links'] = links!.toJson();
    // }
    // if (meta != null) {
    //   data['meta'] = meta!.toJson();
    // }
    return data;
  }
}


class Links {
  String? first;
  String? last;
  String? prev;
  String? next;

  Links({this.first, this.last, this.prev, this.next});

  Links.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    last = json['last'];
    prev = json['prev'];
    next = json['next'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first'] = first;
    data['last'] = last;
    data['prev'] = prev;
    data['next'] = next;
    return data;
  }
}

class Meta {
  int? currentPage;
  int? from;
  int? lastPage;
  List<Links>? links;
  String? path;
  int? perPage;
  int? to;
  int? total;

  Meta(
      {this.currentPage,
        this.from,
        this.lastPage,
        this.links,
        this.path,
        this.perPage,
        this.to,
        this.total});

  Meta.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    from = json['from'];
    lastPage = json['last_page'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(Links.fromJson(v));
      });
    }
    path = json['path'];
    perPage = json['per_page'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    data['from'] = from;
    data['last_page'] = lastPage;
    if (links != null) {
      data['links'] = links!.map((v) => v.toJson()).toList();
    }
    data['path'] = path;
    data['per_page'] = perPage;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

