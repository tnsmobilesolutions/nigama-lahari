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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.song.songTitle ?? ""),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              ElevatedButton(
                onPressed: () async {
                  if (_selectedOption == null) {
                    Fluttertoast.showToast(msg: "ଦୟାକରି ବିଭାଗ ଚୟନ କରନ୍ତୁ");
                  } else if (_titleController.text.isEmpty) {
                    Fluttertoast.showToast(msg: "ଦୟାକରି ଗୀତ ନାମ ଲେଖନ୍ତୁ");
                  } else if (_lyricsController.text.isEmpty) {
                    Fluttertoast.showToast(msg: "ଦୟାକରି ଗୀତର ଲେଖା ଦିଅନ୍ତୁ");
                  } else {
                    await HomeScreen();
                  }
                  // Navigator.pop(context);
                  // await Fluttertoast.showToast(
                  //     msg: 'Upload Successfully');
                  // Navigator.pop(context);

                  if (_formKey.currentState!.validate()) {
                    Song songsModel = Song(
                      isEditable: true,
                      //songCategory: _selectedOption,
                      songAttribute: _attributeController.text,
                      songTitle: _titleController.text,
                      singerName: _singerNameController.text,
                      songText: _lyricsController.text,
                    );

                    final SongDetails = SongAPI().updateSong(songsModel);
                    print(songsModel);
                    print(SongDetails);

                    await ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Data Updated.')),
                    );

                    Navigator.pop(context, HomeScreen());
                  } else
                    return null;
                },
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
