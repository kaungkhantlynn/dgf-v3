class TracksData {
  String? mlng;
  String? mlat;

  TracksData({this.mlng, this.mlat});

  TracksData.fromJson(Map<String, dynamic> json) {
    mlng = json['mlng'];
    mlat = json['mlat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['mlng'] = mlng;
    data['mlat'] = mlat;

    return data;
  }
}
