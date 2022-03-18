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
        //print(songMap);
        final song = Song.fromMap(songMap);
        //print(song);
        if (song.songCategory != null &&
            !lstCategories.contains(song.songCategory)) {
          lstCategories.add(song.songCategory ?? "No Category");
          //print(lstCategories);
        }
      });
      return lstCategories;
    });
    return lstResult;
  }

  Future<List<Song>?> getAllSongsInCategory(String categoryName) {
    CollectionReference songs = FirebaseFirestore.instance.collection('songs');
    final lstResult = songs.get().then(
      (querySnapshot) {
        List<Song>? lstSongs = [];
        querySnapshot.docs.forEach(
          (element) {
            final songMap = element.data() as Map<String, dynamic>;

            final song = Song.fromMap(songMap);
            if (song.songCategory == categoryName) {
              lstSongs.add(song);
            }
          },
        );
        print(lstSongs);
        return lstSongs;
      },
    );

    return lstResult;
  }

  Future<List<Song>?> getSongByName(String name) {
    CollectionReference songs = FirebaseFirestore.instance.collection('songs');
    final lstSongs = songs.get().then((querySnapshot) {
      List<Song>? lstSong = [];
      print(querySnapshot.docs.length);
      querySnapshot.docs.forEach((element) {
        final receiptSongs = element.data() as Map<String, dynamic>;
        print(receiptSongs);
        final song = Song.fromMap(receiptSongs);
        if ((song.songTitle ?? '').startsWith(name)) {
          lstSong.add(song);
        }
      });
      return lstSong;
    });
    return lstSongs;
  }

  Future<List<Song>?> getSongBySingerName(String singerName) {
    CollectionReference songs = FirebaseFirestore.instance.collection('songs');
    final lstSongs = songs.get().then((querySnapshot) {
      List<Song>? lstSong = [];
      print(querySnapshot.docs.length);
      querySnapshot.docs.forEach((element) {
        final receiptSongs = element.data() as Map<String, dynamic>;
        print(receiptSongs);
        final song = Song.fromMap(receiptSongs);
        if ((song.singerName ?? '').startsWith(singerName)) {
          lstSong.add(song);
        }
      });
      return lstSong;
    });
    return lstSongs;
  }

  Future<List<Song>?> getSongByAttribute(String attribute) {
    CollectionReference songs = FirebaseFirestore.instance.collection('songs');
    final lstSongs = songs.get().then((querySnapshot) {
      List<Song>? lstSong = [];
      print(querySnapshot.docs.length);
      querySnapshot.docs.forEach((element) {
        final receiptSongs = element.data() as Map<String, dynamic>;
        //print(receiptSongs);
        final song = Song.fromMap(receiptSongs);
        if ((song.songAttribute ?? '').startsWith(attribute)) {
          lstSong.add(song);
        }
      });
      return lstSong;
    });
    return lstSongs;
  }

  Future<List<Song>?> getSongByCategory(String category) {
    CollectionReference songs = FirebaseFirestore.instance.collection('songs');
    final lstSongs = songs.get().then((querySnapshot) {
      List<Song>? lstSong = [];
      print(querySnapshot.docs.length);
      querySnapshot.docs.forEach((element) {
        final receiptSongs = element.data() as Map<String, dynamic>;
        print(receiptSongs);
        final song = Song.fromMap(receiptSongs);
        print(song);
        if ((song.songCategory ?? '').startsWith(category)) {
          lstSong.add(song);
        }
      });
      return lstSong;
    });
    return lstSongs;
  }

  Future<List<Song>?> getSongByDuration(String duration) {
    CollectionReference songs = FirebaseFirestore.instance.collection('songs');
    final lstSongs = songs.get().then((querySnapshot) {
      List<Song>? lstSong = [];
      print(querySnapshot.docs.length);
      querySnapshot.docs.forEach((element) {
        final receiptSongs = element.data() as Map<String, dynamic>;
        //print(receiptSongs);
        final song = Song.fromMap(receiptSongs);
        if (song.songDuration!.isNotEmpty) {
          lstSong.add(song);
        }
      });
      return lstSong;
    });
    return lstSongs;
  }
}
