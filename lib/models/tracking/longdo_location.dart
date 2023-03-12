
class LongdoLocation {
  String? geocode;
  String? country;
  String? province;
  String? district;
  String? subdistrict;
  String? postcode;
  int? elevation;
  String? road;
  double? roadLon;
  double? roadLat;

  LongdoLocation(
      {this.geocode,
        this.country,
        this.province,
        this.district,
        this.subdistrict,
        this.postcode,
        this.elevation,
        this.road,
        this.roadLon,
        this.roadLat});

  LongdoLocation.fromJson(Map<String, dynamic> json) {
    geocode = json['geocode'];
    country = json['country'];
    province = json['province'] ?? '-';
    district = json['district'] ?? '-';
    subdistrict = json['subdistrict']?? '-';
    postcode = json['postcode'];
    elevation = json['elevation'];
    road = json['road'];
    roadLon = json['road_lon'];
    roadLat = json['road_lat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['geocode'] = geocode;
    data['country'] = country;
    data['province'] = province;
    data['district'] = district;
    data['subdistrict'] = subdistrict;
    data['postcode'] = postcode;
    data['elevation'] = elevation;
    data['road'] = road;
    data['road_lon'] = roadLon;
    data['road_lat'] = roadLat;
    return data;
  }
}