import 'dart:convert';

class AppUser {
  String? uid;
  String? email;
  String? mobile;
  String? name;
  bool? allowEdit;
  AppUser({
    this.uid,
    this.email,
    this.mobile,
    this.name,
    this.allowEdit,
  });
  //List<String>? favouriteSongs;

  AppUser copyWith({
    String? uid,
    String? email,
    String? mobile,
    String? name,
    bool? allowEdit,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      name: name ?? this.name,
      allowEdit: allowEdit ?? this.allowEdit,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'mobile': mobile,
      'name': name,
      'allowEdit': allowEdit,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'],
      email: map['email'],
      mobile: map['mobile'],
      name: map['name'],
      allowEdit: map['allowEdit'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppUser(uid: $uid, email: $email, mobile: $mobile, name: $name, allowEdit: $allowEdit)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppUser &&
        other.uid == uid &&
        other.email == email &&
        other.mobile == mobile &&
        other.name == name &&
        other.allowEdit == allowEdit;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        email.hashCode ^
        mobile.hashCode ^
        name.hashCode ^
        allowEdit.hashCode;
  }
}
