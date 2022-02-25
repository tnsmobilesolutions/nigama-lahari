import 'dart:convert';

class AppUser {
  String? uid;
  String? name;
  String? phonenumber;
  String? email;
  AppUser({
    this.uid,
    this.name,
    this.phonenumber,
    this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'phonenumber': phonenumber,
      'email': email,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'],
      name: map['name'],
      phonenumber: map['phonenumber'],
      email: map['email'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source));

  AppUser copyWith({
    String? uid,
    String? name,
    String? phonenumber,
    String? email,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      phonenumber: phonenumber ?? this.phonenumber,
      email: email ?? this.email,
    );
  }

  @override
  String toString() {
    return 'AppUser(uid: $uid, name: $name, phonenumber: $phonenumber, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppUser &&
        other.uid == uid &&
        other.name == name &&
        other.phonenumber == phonenumber &&
        other.email == email;
  }

  @override
  int get hashCode {
    return uid.hashCode ^ name.hashCode ^ phonenumber.hashCode ^ email.hashCode;
  }
}
