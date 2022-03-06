import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/songs_model.dart';

class SongAPI {
  Future<String> createNewSong(SongsModel songsModel) async {
    CollectionReference songs = FirebaseFirestore.instance.collection('songs');

    final Reference = await songs.add({
      "isEditable": songsModel.isEditable,
      "singerName": songsModel.singerName,
      "songAttributes": songsModel.songAttribute,
      "songDration": songsModel.songDuration,
      "songUrl": songsModel.songURL,
      "songcatageory": songsModel.songCategory,
    });
    return Reference.id;
  }
}
