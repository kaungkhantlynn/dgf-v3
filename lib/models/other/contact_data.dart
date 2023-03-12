class ContactData {
  bool? show;
  String? display;
  String? actionValue;

  ContactData({this.show, this.display, this.actionValue});

  ContactData.fromJson(Map<String, dynamic> json) {
    show = json['show'];
    display = json['display'];
    actionValue = json['action_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['show'] = show;
    data['display'] = display;
    data['action_value'] = actionValue;
    return data;
  }
}
