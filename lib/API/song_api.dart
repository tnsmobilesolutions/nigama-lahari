import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_1/API/firebaseAPI.dart';
import 'package:flutter_application_1/models/songs_model.dart';
import 'package:path/path.dart' as path;

UploadTask? task;
File? file;
String? _selectedOption;

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

    final Reference = await songs.doc(songsModel.songId).set({
      "songId": songsModel.songId,
      "songCategory": songsModel.songCategory,
      "songAttribute": songsModel.songAttribute,
      "songTitle": songsModel.songTitle,
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
}
