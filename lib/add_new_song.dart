import 'package:flutter/material.dart';

class AddNewSong extends StatefulWidget {
  const AddNewSong({Key? key}) : super(key: key);

  @override
  _AddNewSongState createState() => _AddNewSongState();
}

class _AddNewSongState extends State<AddNewSong> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add New Song'),
      ),
    );
  }
}
