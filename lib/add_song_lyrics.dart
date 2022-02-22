import 'package:flutter/material.dart';

class AddSongLyrics extends StatefulWidget {
  const AddSongLyrics({Key? key}) : super(key: key);

  @override
  _AddSongLyricsState createState() => _AddSongLyricsState();
}

class _AddSongLyricsState extends State<AddSongLyrics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Song Lyrics'),
      ),
    );
  }
}
