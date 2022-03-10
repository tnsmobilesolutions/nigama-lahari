import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/songs_model.dart';

class SongAPI {
  Future<String> createNewSong(Song songsModel) async {
    CollectionReference songs = FirebaseFirestore.instance.collection('songs');

    final Reference = await songs.add({
      "songId": songsModel.songId,

      "songCategory": songsModel.songCategory,
      //"songAttributes": songsModel.songAttribute,

      "songCatageory": songsModel.songCategory,
      "songAttribute": songsModel.songAttribute,
      "songTitle": songsModel.songTitle,
      "singerName": songsModel.singerName,
      "songText": songsModel.songText,
      "isEditable": songsModel.isEditable,
      "songDuration": songsModel.songDuration,
      "songURL": songsModel.songURL,
    });
    return Reference.id;
  }
}
