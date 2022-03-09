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

  // All fields or methods to be accessible from outside
  List<Song>? allSongs;
  List<String>? allCategories;
  bool get isUserLoggedIn {
    return FirebaseAuth.instance.currentUser != null;
  }

  // All Private methods
  loadAllData() async {
    // Load all songs
    allSongs = await SearchSongAPI().getAllSongs();
    getAllCategories();
    print(allCategories);
  }

  getAllCategories() {
    print('calling getAllCategories');
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
    allCategories = result;
  }
}
