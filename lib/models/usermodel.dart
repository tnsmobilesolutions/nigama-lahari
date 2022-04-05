import 'dart:convert';

class AppUser {
  AppUser({
    this.uid,
    this.email,
    this.mobile,
    this.name,
    this.favouriteSongs,
  });

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source));

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'],
      email: map['email'],
      mobile: map['mobile'],
      name: map['name'],
      favouriteSongs: map['favouriteSongs'],
    );
  }

  String? email;
  String? mobile;
  String? name;
  String? uid;
  String? favouriteSongs;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppUser &&
        other.uid == uid &&
        other.email == email &&
        other.mobile == mobile &&
        other.name == name &&
        other.favouriteSongs == favouriteSongs;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        email.hashCode ^
        mobile.hashCode ^
        name.hashCode ^
        favouriteSongs.hashCode;
  }

  @override
  String toString() {
    return 'AppUser(uid: $uid, email: $email, mobile: $mobile, name: $name, favouriteSong: $favouriteSongs)';
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
      favouriteSongs: favouriteSongs ?? this.favouriteSongs,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'mobile': mobile,
      'name': name,
      'favouriteSong': favouriteSongs,
    };
  }

  String toJson() => json.encode(toMap());
}
