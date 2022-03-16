import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_application_1/common_widgets/common_style.dart';
import 'package:flutter_application_1/models/songs_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'API/song_api.dart';
import 'home_screen.dart';
import 'login/common_widgets/common_style.dart';

class EditSong extends StatefulWidget {
  EditSong({Key? key, required this.song}) : super(key: key);
  final Song song;
  @override
  State<EditSong> createState() => _Edit_SongState();
}

class _Edit_SongState extends State<EditSong> {
  final _formKey = GlobalKey<FormState>();
  List<String> _catagory = [
    'ଜାଗରଣ',
    'ପ୍ରତୀକ୍ଷା',
    'ଆବାହନ',
    'ଆରତୀ',
    'ବନ୍ଦନା',
    'ପ୍ରାର୍ଥନା',
    'ବିଦାୟ ପ୍ରାର୍ଥନା',
  ];

  String? _selectedOption;
  final height = 100;

  final _catagoryController = TextEditingController();
  final _titleController = TextEditingController();
  final _singerNameController = TextEditingController();
  final _attributeController = TextEditingController();
  final _lyricsController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _catagoryController.text = widget.song.songCategory ?? "";
    _titleController.text = widget.song.songTitle ?? "";
    _singerNameController.text = widget.song.singerName ?? "";
    _attributeController.text = widget.song.songAttribute ?? "";
    _lyricsController.text = widget.song.songText ?? "";
    _selectedOption = widget.song.songCategory ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.song.songTitle ?? ""),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DropdownButton(
                  hint: Text(
                    _catagoryController.text,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  value: _selectedOption,
                  dropdownColor: Colors.yellowAccent[700],
                  onChanged: (value) {
                    setState(
                      () {
                        _selectedOption = value as String?;
                        print(_selectedOption.toString());
                      },
                    );
                  },
                  items: _catagory.map(
                    (val) {
                      return DropdownMenuItem(
                        child: new Text(val),
                        value: val,
                      );
                    },
                  ).toList(),
                ),
                SizedBox(height: 15),
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: _titleController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]"))
                  ],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Name';
                    } else if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                      return 'Please Enter Correct Name';
                    }
                    return null;
                  },
                  // style: TextStyle(height: 0.5),
                  decoration: CommonStyle.textFieldStyle(
                    labelTextStr: "Song Name",
                    hintTextStr: "Enter Song name",
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: _singerNameController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]"))
                  ],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Singer Name';
                    } else if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                      return 'Please Enter Correct Singer Name';
                    }
                    return null;
                  },
                  // style: TextStyle(height: 0.5),
                  decoration: CommonStyle.textFieldStyle(
                    labelTextStr: "Singer Name",
                    hintTextStr: "Enter Singer name",
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: _attributeController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]"))
                  ],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter  Attribute Name';
                    } else if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                      return 'Please Enter Correct Attribute Name';
                    }
                    return null;
                  },
                  // style: TextStyle(height: 0.5),
                  decoration: CommonStyle.textFieldStyle(
                    labelTextStr: "Song Attribute Name",
                    hintTextStr: "Enter Song Attribute name",
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _lyricsController,
                  maxLines: height ~/ 8,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]"))
                  ],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Lyrics';
                    } else if (!RegExp(r'^[0-9 a-z A-Z]+$').hasMatch(value)) {
                      return 'Please Enter Correct Lyrics';
                    }
                    return null;
                  },
                  // style: TextStyle(height: 0.5),
                  decoration: CommonStyle.textFieldStyle(
                    labelTextStr: "Song Lyrics",
                    hintTextStr: "Enter Song Lyrics",
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _lyricsController,
                    maxLines: height ~/ 8,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]"))
                    ],
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Lyrics';
                      } else if (!RegExp(r'^[0-9 a-z A-Z]+$').hasMatch(value)) {
                        return 'Please Enter Correct Lyrics';
                      }
                      return null;
                    },
                    // style: TextStyle(height: 0.5),
                    decoration: CommonStyle.textFieldStyle(
                      labelTextStr: "Song Lyrics",
                      hintTextStr: "Enter Song Lyrics",
                    ),
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState != null &&
                          _formKey.currentState!.validate()) {
                        Song songsModel = Song(
                          isEditable: true,
                          songCategory: _selectedOption,
                          songAttribute: _attributeController.text,
                          songTitle: _titleController.text,
                          singerName: _singerNameController.text,
                          songText: _lyricsController.text,
                        );

                    if (_formKey.currentState!.validate()) {
                      Song songsModel = Song(
                        isEditable: true,
                        songCategory: _selectedOption,
                        songAttribute: _attributeController.text,
                        songTitle: _titleController.text,
                        singerName: _singerNameController.text,
                        songText: _lyricsController.text,
                      );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Data Updated.')),
                        );
                      } else {
                        return;
                      }
                      Navigator.of(context).pop();
                    },
                    child: Text('Update'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
