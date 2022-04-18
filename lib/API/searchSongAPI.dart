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
    final lstSongs = songs.get().then(
      (querySnapshot) {
        List<Song>? lstSong = [];
        //print(querySnapshot.docs.length);
        querySnapshot.docs.forEach(
          (element) {
            final resultSongs = element.data() as Map<String, dynamic>;
            //print(resultSongs);
            final song = Song.fromMap(resultSongs);
            if ((song.songTitle ?? '')
                    .toLowerCase()
                    .contains(name.toLowerCase()) ||
                (song.songTitleInEnglish ?? '')
                    .toLowerCase()
                    .contains(name.toLowerCase())) {
              lstSong.add(song);
            }
          },
        );
        return lstSong;
      },
    );
    return lstSongs;
  }

  Future<List<Song>?> getSongBySingerName(String singerName) {
    CollectionReference songs = FirebaseFirestore.instance.collection('songs');
    final lstSongs = songs.get().then(
      (querySnapshot) {
        List<Song>? lstSong = [];
        querySnapshot.docs.forEach(
          (element) {
            final resultSongs = element.data() as Map<String, dynamic>;
            final song = Song.fromMap(resultSongs);
            if ((song.singerName ?? '').startsWith(singerName)) {
              lstSong.add(song);
            }
          },
        );
        return lstSong;
      },
    );
    return lstSongs;
  }

  // Future<List<Song>?> getSingersName() {
  //   CollectionReference songs = FirebaseFirestore.instance.collection('songs');
  //   final lstSingers = songs.get().then(
  //     (querySnapshot) {
  //       List<Song>? lstSinger = [];
  //       querySnapshot.docs.forEach(
  //         (element) {
  //           final resultSongs = List<String>.from(querySnapshot.element);
  //           // final resultSongs = element.data() as Map<String, dynamic>;
  //           final song = Song.fromMap(resultSongs);
  //           if ((song.singerName ?? '').startsWith(singerName)) {
  //             lstSinger.add(song);
  //           }
  //         },
  //       );
  //       return lstSinger;
  //     },
  //   );
  //   return lstSingers;
  // }

  Future<List<Song>?> getSongByAttribute(String? attribute) {
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
            if ((song.songAttribute ?? '').startsWith(attribute!)) {
              lstSong.add(song);
            }
          },
        );
        return lstSong;
      },
    );
    return lstSongs;
  }

  Future<List<Song>?> getSongByCategory(String category) {
    CollectionReference songs = FirebaseFirestore.instance.collection('songs');
    final lstSongs = songs.get().then(
      (querySnapshot) {
        List<Song>? lstSong = [];
        querySnapshot.docs.forEach(
          (element) {
            final resultSongs = element.data() as Map<String, dynamic>;
            final song = Song.fromMap(resultSongs);
            if ((song.songCategory ?? '').startsWith(category)) {
              lstSong.add(song);
            }
          },
        );
        return lstSong;
      },
    );
    return lstSongs;
  }

  Future<List<Song>?> getSongByDuration(String value) {
    var small = DateTime.parse('2000-01-01 00:05:00');
    var medium = DateTime.parse('2000-01-01 00:08:00');

    CollectionReference songs = FirebaseFirestore.instance.collection('songs');
    final lstSongs = songs.get().then(
      (querySnapshot) {
        List<Song>? lstSong = [];
        querySnapshot.docs.forEach(
          (element) {
            final resultSongs = element.data() as Map<String, dynamic>;
            final song = Song.fromMap(resultSongs);
            final songDurationInString = song.songDuration?.padLeft(8, '0');
            var songDurationInDate =
                DateTime.parse('2000-01-01 $songDurationInString');
            switch (value) {
              case 'small':
                if (songDurationInDate == small ||
                    songDurationInDate.isBefore(small)) {
                  lstSong.add(song);
                }

                break;
              case 'medium':
                if (songDurationInDate.isAfter(small) &&
                    songDurationInDate.isBefore(medium)) {
                  lstSong.add(song);
                }
                break;
              case 'long':
                if (songDurationInDate.isAfter(medium)) {
                  lstSong.add(song);
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

  Future<List<Song>?> getAllSongsByIds(List<dynamic>? songIds) {
    CollectionReference songs = FirebaseFirestore.instance.collection('songs');
    final lstResult = songs.get().then(
      (querySnapshot) {
        List<Song>? lstSongIds = [];
        querySnapshot.docs.forEach(
          (element) {
            final songMap = element.data() as Map<String, dynamic>;

            final song = Song.fromMap(songMap);
            if (songIds != null && songIds.contains(song.songId)) {
              lstSongIds.add(song);
            }
          },
        );
        lstSongIds
            .sort((a, b) => (a.songTitle ?? "").compareTo(b.songTitle ?? ""));

        return lstSongIds;
      },
    );

    return lstResult;
  }

  // Future<List<String>?> getAllAvailableAttribute() {
  //   CollectionReference songs = FirebaseFirestore.instance.collection('songs');
  //   final lstAttributes = songs.get().then(
  //     (querySnapshot) {
  //       List<String>? lstAttribute = [];
  //       var value;
  //       querySnapshot.docs.forEach(
  //         (element) {
  //           final resultSongs = element.data() as Map<String, dynamic>;
  //           final song = resultSongs.values.toList();
  //           print('$song');
  //           // if (song != null) {
  //           //   lstAttribute.add(song);
  //           // }
  //         },
  //       );
  //       return lstAttribute;
  //     },
  //   );
  //   return lstAttributes;
  // }
}
