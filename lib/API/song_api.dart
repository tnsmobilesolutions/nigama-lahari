import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_1/models/songs_model.dart';

UploadTask? task;
File? file;
//String? _selectedOption;

String destination = '';

String? songUrl;
String duration = '';
Duration? autoDuration;
double? sizeInMb;
var file1;
var val;

class SongAPI {
  Future<String> createNewSong(Song songsModel) async {
    CollectionReference songs = FirebaseFirestore.instance.collection('songs');

    await songs.doc(songsModel.songId).set({
      "songId": songsModel.songId,
      "songCategory": songsModel.songCategory,
      "songAttribute": songsModel.songAttribute,
      "songTitle": songsModel.songTitle,
      "songTitleInEnglish": songsModel.songTitleInEnglish,
      "singerName": songsModel.singerName,
      "songText": songsModel.songText,
      "isEditable": songsModel.isEditable,
      "songDuration": songsModel.songDuration,
      "songURL": songsModel.songURL,
    });
    return songsModel.songId ?? "0";
  }

// update
  dynamic updateSong(Song song) async {
    // Implement Update song logic here
    var collection = FirebaseFirestore.instance.collection('songs');

    collection
        .doc(song.songId) // <-- Doc ID where data should be updated.
        .update(song.toMap());
  }

  Future<Song?> getSongBySongId(String songId) {
    CollectionReference songs = FirebaseFirestore.instance.collection('songs');
    final result = songs.get().then(
      (querySnapshot) {
        Song? _song;
        //print(querySnapshot.docs.length);
        querySnapshot.docs.forEach(
          (element) {
            final resultSongs = element.data() as Map<String, dynamic>;
            //print(resultSongs);
            final song = Song.fromMap(resultSongs);
            if (song.songId == songId) {
              _song = song;
            }
          },
        );
        return _song;
      },
    );
    return result;
  }
}
