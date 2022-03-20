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

  // // Select File
  // dynamic selectFile() async {
  //   final result = await FilePicker.platform.pickFiles(
  //     allowMultiple: false,
  //     type: FileType.audio,
  //   );
  //   print('****  $result  ****');
  //   if (result != null) {
  //     file1 = result.files.first;
  //     sizeInMb = file1.size / 1048576;
  //   } else {
  //     return;
  //   }

  //   //lenghOfAudio(file1);

  //   file1 = result.files.first;
  //   // print('++++  $file1  ++++');
  //   // print('----  ${file1.name}  ----');

  //   sizeInMb = file1.size / 1048576;

  //   final path = result.files.single.path!;
  //   // setState(() => file = File(path));
  // }

  // //Upload File

  // dynamic uploadFile() async {
  //   if (file == null) {
  //     return;
  //   } else {}
  //   final fileName = path.basename(file!.path);
  //   destination = '$_selectedOption/$fileName';

  //   task = FirebaseApi.uploadFile(destination, file!);
  //   // setState(() {});

  //   if (task == null) return;

  //   final snapshot = await task!.whenComplete(() {});
  //   songUrl = await snapshot.ref.getDownloadURL();
  //   // autoDuration = await player.setUrl(songUrl.toString());

  //   //print('****  $autoDuration  ****');
  //   //print('Download-Link: $songURL');
  // }

  // delete song
  Future<void> delete(Song song, Function deleteSong) async {
    if (song.songURL != null) {
      await FirebaseStorage.instance
          .refFromURL(song.songURL.toString())
          .delete();

      //

      print('song deleted');
    }

    await FirebaseFirestore.instance
        .collection('songs')
        .doc(song.songId)
        .delete();
    deleteSong(song);
  }
}
