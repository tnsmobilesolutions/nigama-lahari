import 'dart:convert';

class AppUser {
  AppUser({
    this.uid,
    this.email,
    this.mobile,
    this.name,
    this.favouriteSong,
  });

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source));

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'],
      email: map['email'],
      mobile: map['mobile'],
      name: map['name'],
      favouriteSong: map['favouriteSong'],
    );
  }

  String? email;
  String? mobile;
  String? name;
  String? uid;
  String? favouriteSong;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppUser &&
        other.uid == uid &&
        other.email == email &&
        other.mobile == mobile &&
        other.name == name &&
        other.favouriteSong == favouriteSong;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        email.hashCode ^
        mobile.hashCode ^
        name.hashCode ^
        favouriteSong.hashCode;
  }

  @override
  String toString() {
    return 'AppUser(uid: $uid, email: $email, mobile: $mobile, name: $name, favouriteSong: $favouriteSong)';
  }

  AppUser copyWith({
    String? uid,
    String? email,
    String? mobile,
    String? name,
    String? favouriteSong,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      name: name ?? this.name,
      favouriteSong: favouriteSong ?? this.favouriteSong,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'mobile': mobile,
      'name': name,
      'favouriteSong': favouriteSong,
    };
  }

  String toJson() => json.encode(toMap());
}
