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
