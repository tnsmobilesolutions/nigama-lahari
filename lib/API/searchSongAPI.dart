import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/songs_model.dart';

class SearchSongAPI {
  Future<List<SongsModel>?> getAllSongs() {
    CollectionReference songs = FirebaseFirestore.instance.collection('songs');

    final lstSongs = songs.get().then((querySnapshot) {
      List<SongsModel>? lstSong = [];
      querySnapshot.docs.forEach((element) {
        final receiptSongs = element.data() as Map<String, dynamic>;
        print(receiptSongs);
        final songs = SongsModel.fromMap(receiptSongs);
        lstSong.add(songs);
      });
      return lstSong;
    });
    return lstSongs;
  }

  Future<List<SongsModel>?> getSongByName(String name) {
    CollectionReference songs = FirebaseFirestore.instance.collection('songs');

    print('all receipt here');
    print(songs);
    print(name);

    final lstSongs = songs.get().then((querySnapshot) {
      List<SongsModel>? lstSong = [];
      print(querySnapshot.docs.length);
      querySnapshot.docs.forEach((element) {
        final receiptSongs = element.data() as Map<String, dynamic>;
        print(receiptSongs);
        final receipt = SongsModel.fromMap(receiptSongs);
        if ((receipt.songText ?? '').startsWith(name)) {
          lstSong.add(receipt);
        }
      });
      return lstSong;
    });
    return lstSongs;
  }
}
