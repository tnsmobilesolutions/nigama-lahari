import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/API/searchSongAPI.dart';
import 'package:flutter_application_1/models/songs_model.dart';
import 'package:collection/collection.dart';

/// This is a singleton class to hold all application level data in one place and
/// to be used across all screens w/o fetching from server again and again.
class DataStore {
  DataStore._privateConstructor();

  static final DataStore _instance = DataStore._privateConstructor();

  factory DataStore() {
    return _instance;
  }

  // All fields or getters to be accessible from outside
  List<Song>? allSongs;

  List<String>? get allCategories {
    print('calling getter of allCategories');
    List<String>? result;
    if (allSongs != null) {
      var newMap = groupBy(allSongs!, (Song obj) => obj.songCategory);
      print(newMap.keys);
      newMap.keys.forEach((key) {
        if (key != null) {
          result?.add(key);
        }
      });
    }
    return result;
  }

  bool get isUserLoggedIn {
    return FirebaseAuth.instance.currentUser != null;
  }

  // All public methods
  Future<void> loadAllData() async {
    // Load all songs
    allSongs = await SearchSongAPI().getAllSongs();
  }
}
