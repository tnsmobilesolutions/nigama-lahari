import 'package:flutter/material.dart';

class EditSong extends StatefulWidget {
  EditSong({Key? key}) : super(key: key);

  @override
  State<EditSong> createState() => _Edit_SongState();
}

class _Edit_SongState extends State<EditSong> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Edit Song'),
      ),
    );
  }
}
