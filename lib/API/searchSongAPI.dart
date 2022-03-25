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
        lstSongs
            .sort((a, b) => (a.songTitle ?? "").compareTo(b.songTitle ?? ""));

        return lstSongs;
      },
    );

    return lstResult;
  }

  Future<List<Song>?> getSongByName(String name) {
    CollectionReference songs = FirebaseFirestore.instance.collection('songs');
    final lstSongs = songs.get().then((querySnapshot) {
      List<Song>? lstSong = [];
      //print(querySnapshot.docs.length);
      querySnapshot.docs.forEach((element) {
        final resultSongs = element.data() as Map<String, dynamic>;
        //print(resultSongs);
        final song = Song.fromMap(resultSongs);
        if ((song.songTitle ?? '').toLowerCase().contains(name.toLowerCase()) ||
            (song.songTitleInEnglish ?? '')
                .toLowerCase()
                .contains(name.toLowerCase())) {
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
      // print(querySnapshot.docs.length);
      querySnapshot.docs.forEach((element) {
        final resultSongs = element.data() as Map<String, dynamic>;
        //print(resultSongs);
        final song = Song.fromMap(resultSongs);
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
      //print(querySnapshot.docs.length);
      querySnapshot.docs.forEach((element) {
        final resultSongs = element.data() as Map<String, dynamic>;
        //print(resultSongs);
        final song = Song.fromMap(resultSongs);
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
      //print(querySnapshot.docs.length);
      querySnapshot.docs.forEach(
        (element) {
          final resultSongs = element.data() as Map<String, dynamic>;
          //print(resultSongs);
          final song = Song.fromMap(resultSongs);
          //print(song);
          if ((song.songCategory ?? '').startsWith(category)) {
            lstSong.add(song);
          }
        },
      );
      return lstSong;
    });
    return lstSongs;
  }

  Future<List<Song>?> getSongByDuration(String value) {
    var s1 = '00:00:00';
    var s2 = '00:05:00';
    var s3 = '00:10:00';

    var t1 = DateTime.parse('2000-01-01 $s1');
    var t2 = DateTime.parse('2000-01-01 $s2');
    var t3 = DateTime.parse('2000-01-01 $s3');

    CollectionReference songs = FirebaseFirestore.instance.collection('songs');
    final lstSongs = songs.get().then(
      (querySnapshot) {
        List<Song>? lstSong = [];
        //print(querySnapshot.docs.length);
        querySnapshot.docs.forEach(
          (element) {
            final resultSongs = element.data() as Map<String, dynamic>;
            //print(resultSongs);
            final song = Song.fromMap(resultSongs);
            switch (value) {
              case 'small':
                if (song.songDuration!.isNotEmpty) {
                  lstSong.add(song);
                  lstSong.forEach(
                    (element) {
                      final resultDuration = element.songDuration;
                      print(resultDuration);
                    },
                  );
                }
                break;
              case 'medium':
                if (song.songDuration!.isNotEmpty) {
                  lstSong.add(song);
                  lstSong.forEach(
                    (element) {
                      final resultDuration = element.songDuration;
                      print(resultDuration);
                    },
                  );
                }
                break;
              case 'long':
                if (song.songDuration!.isNotEmpty) {
                  lstSong.add(song);
                  lstSong.forEach(
                    (element) {
                      final resultDuration = element.songDuration;
                      print(resultDuration);
                    },
                  );
                }
                break;
              default:
            }
          },
        );
        return lstSong;
      },
    );
    return lstSongs;
  }
}
