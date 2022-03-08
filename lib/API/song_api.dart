import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/songs_model.dart';

class SongAPI {
  Future<String> createNewSong(SongsModel songsModel) async {
    CollectionReference songs = FirebaseFirestore.instance.collection('songs');

    final Reference = await songs.add({
      "songId": songsModel.songId,
      "songcatageory": songsModel.songCategory,
      "songAttributes": songsModel.songAttribute,
      "songTitle": songsModel.songTitle,
      "singerName": songsModel.singerName,
      "songText": songsModel.songText,
      "isEditable": songsModel.isEditable,
      "songDration": songsModel.songDuration,
      "songUrl": songsModel.songURL,
    });
    return Reference.id;
  }
}
