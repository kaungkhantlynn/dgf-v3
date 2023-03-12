class VehiclesFilter {
  int? all;
  int? driving;
  int? parking;
  int? idling;
  int? offline;

  VehiclesFilter(
      {this.all, this.driving, this.parking, this.idling, this.offline});

  VehiclesFilter.fromJson(Map<String, dynamic> json) {
    all = json['all'];
    driving = json['driving'];
    parking = json['parking'];
    idling = json['idling'];
    offline = json['offline'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['all'] = all;
    data['driving'] = driving;
    data['parking'] = parking;
    data['idling'] = idling;
    data['offline'] = offline;
    return data;
  }
}
