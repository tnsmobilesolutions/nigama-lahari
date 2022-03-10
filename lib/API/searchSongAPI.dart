import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/songs_model.dart';

class SearchSongAPI {
  Future<List<Song>?> getAllSongs() {
    CollectionReference songs = FirebaseFirestore.instance.collection('songs');

    final lstSongs = songs.get().then((querySnapshot) {
      List<Song>? lstSong = [];
      querySnapshot.docs.forEach((element) {
        final songMap = element.data() as Map<String, dynamic>;
        // print(songMap);
        final song = Song.fromMap(songMap);
        lstSong.add(song);
      });
      return lstSong;
    });
    return lstSongs;
  }

  Future<List<String>?> getAllCategories() {
    CollectionReference songs = FirebaseFirestore.instance.collection('songs');

    final lstResult = songs.get().then((querySnapshot) {
      List<String>? lstCategories = [];
      querySnapshot.docs.forEach((element) {
        final songMap = element.data() as Map<String, dynamic>;
        // print(songMap);
        final song = Song.fromMap(songMap);
        if (song.songCategory != null &&
            !lstCategories.contains(song.songCategory)) {
          lstCategories.add(song.songCategory ?? "No Category");
        }
      });
      return lstCategories;
    });
    return lstResult;
  }

  Future<List<Song>?> getAllSongsInCategory(String categoryName) {
    CollectionReference songs = FirebaseFirestore.instance.collection('songs');

    final lstResult = songs.get().then((querySnapshot) {
      List<Song>? lstSongs = [];
      querySnapshot.docs.forEach(
        (element) {
          final songMap = element.data() as Map<String, dynamic>;
          // print(songMap);
          final song = Song.fromMap(songMap);
          if (song.songCategory == categoryName) {
            lstSongs.add(song);
          }
        },
      );
      return lstSongs;
    });
    return lstResult;
  }

  Future<List<Song>?> getSongByName(String name) {
    CollectionReference songs = FirebaseFirestore.instance.collection('songs');

    print('all receipt here');
    print(songs);
    print(name);

    final lstSongs = songs.get().then((querySnapshot) {
      List<Song>? lstSong = [];
      print(querySnapshot.docs.length);
      querySnapshot.docs.forEach((element) {
        final receiptSongs = element.data() as Map<String, dynamic>;
        print(receiptSongs);
        final receipt = Song.fromMap(receiptSongs);
        if ((receipt.songText ?? '').startsWith(name)) {
          lstSong.add(receipt);
        }
      });
      return lstSong;
    });
    return lstSongs;
  }
}
