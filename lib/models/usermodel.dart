import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../API/userAPI.dart';

class AppUser extends ChangeNotifier {
  List<String>? get getFavoriteSongIdsFromUid {
    return favoriteSongIds;
  }

  addSongIdToFavoriteSongIds(String? songId) async {
    await userAPI().addSongToFavorite(songId);
    // fetch and update list of updated favSongIds
    favoriteSongIds =
        (await userAPI().getFavoriteSongIdsOfCurrentUser()).cast<String>();
    notifyListeners();
  }

  removeSongIdFromFavoriteSongIds(String? songId) async {
    await userAPI().removeSongFromFavorite(songId);
    // fetch and update list of updated favSongIds
    favoriteSongIds =
        (await userAPI().getFavoriteSongIdsOfCurrentUser()).cast<String>();
    notifyListeners();
  }

  String? uid;
  String? email;
  String? mobile;
  String? name;
  bool? allowEdit;
  List<String>? favoriteSongIds;
  AppUser({
    this.uid,
    this.email,
    this.mobile,
    this.name,
    this.allowEdit,
    this.favoriteSongIds,
  });
  //List<String>? favouriteSongs;

  AppUser copyWith({
    String? uid,
    String? email,
    String? mobile,
    String? name,
    bool? allowEdit,
    List<String>? favoriteSongIds,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      name: name ?? this.name,
      allowEdit: allowEdit ?? this.allowEdit,
      favoriteSongIds: favoriteSongIds ?? this.favoriteSongIds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'mobile': mobile,
      'name': name,
      'allowEdit': allowEdit,
      'favoriteSongIds': favoriteSongIds,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'],
      email: map['email'],
      mobile: map['mobile'],
      name: map['name'],
      allowEdit: map['allowEdit'],
      favoriteSongIds: List<String>.from(map['favoriteSongIds']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppUser(uid: $uid, email: $email, mobile: $mobile, name: $name, allowEdit: $allowEdit, favoriteSongIds: $favoriteSongIds)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppUser &&
        other.uid == uid &&
        other.email == email &&
        other.mobile == mobile &&
        other.name == name &&
        other.allowEdit == allowEdit &&
        listEquals(other.favoriteSongIds, favoriteSongIds);
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        email.hashCode ^
        mobile.hashCode ^
        name.hashCode ^
        allowEdit.hashCode ^
        favoriteSongIds.hashCode;
  }
}
