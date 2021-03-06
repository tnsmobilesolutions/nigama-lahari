import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_application_1/models/songs_model.dart';

/// This is a singleton class to hold all application level data in one place and
/// to be used across all screens w/o fetching from server again and again.
class DataStore {
  factory DataStore() {
    return _instance;
  }

  DataStore._privateConstructor();

  // All fields or getters to be accessible from outside
  List<Song>? allSongs;

  static final DataStore _instance = DataStore._privateConstructor();

  bool get isUserLoggedIn {
    return FirebaseAuth.instance.currentUser != null;
  }

  // All public methods
  Future<void> loadAllData() async {
    // Load all songs
    // allSongs = await SearchSongAPI().getAllSongs();
  }
}
