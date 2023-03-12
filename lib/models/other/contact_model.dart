import 'contact_data.dart';

class ContactModel {
  bool? success;
  int? status;
  ContactData? phone;
  ContactData? facebook;
  ContactData? line;
  ContactData? mail;
  ContactData? liveChat;

  ContactModel(
      {this.success,
      this.status,
      this.phone,
      this.facebook,
      this.line,
      this.mail,
      this.liveChat});

  ContactModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    phone =
        json['phone'] != null ? ContactData.fromJson(json['phone']) : null;
    facebook = json['facebook'] != null
        ? ContactData.fromJson(json['facebook'])
        : null;
    line = json['line'] != null ? ContactData.fromJson(json['line']) : null;
    mail = json['mail'] != null ? ContactData.fromJson(json['mail']) : null;
    liveChat = json['live_chat'] != null
        ? ContactData.fromJson(json['live_chat'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['status'] = status;
    if (phone != null) {
      data['phone'] = phone!.toJson();
    }
    if (facebook != null) {
      data['facebook'] = facebook!.toJson();
    }
    if (line != null) {
      data['line'] = line!.toJson();
    }
    if (mail != null) {
      data['mail'] = mail!.toJson();
    }
    if (liveChat != null) {
      data['live_chat'] = liveChat!.toJson();
    }
    return data;
  }
}
