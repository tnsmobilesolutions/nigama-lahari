import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant.dart';
import 'package:flutter_application_1/search_functionality/result_song.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../API/searchSongAPI.dart';
import '../login/common_widgets/common_style.dart';
import '../models/songs_model.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<String> _songs = ["Name", "Singer", "Attribute", "Category", "Duration"];
  String? _selectedOption;
  String _value = '';

  final _nameController = TextEditingController();
  final _singerNameController = TextEditingController();
  final _attributeController = TextEditingController();
  final _categoryController = TextEditingController();
  final _durationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topLeft,
        //     end: Alignment.bottomRight,
        //     colors: [Colors.purple, Colors.teal],
        //   ),
        // ),
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: Text('ଖୋଜନ୍ତୁ'),
          ),
          body: Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                // Text("Search By",
                //    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                DropdownButton(
                  style: TextStyle(color: Constant.white),
                  dropdownColor: Constant.lightblue,
                  hint: Text(
                    'ସଂଗୀତ ଖୋଜନ୍ତୁ',
                    style: TextStyle(color: Constant.white),
                  ),
                  value: _selectedOption,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedOption = newValue as String?;
                    });
                  },
                  items: _songs.map(
                    (songs) {
                      return DropdownMenuItem(
                        child: new Text(songs),
                        value: songs,
                      );
                    },
                  ).toList(),
                ),

                getNameWidget(_selectedOption),
                getSingerNameWidget(_selectedOption),
                getAttributeSong(_selectedOption),
                getCategorySong(_selectedOption),
                getDurationWidget(_selectedOption),
                ElevatedButton(
                  style: CommonStyle.elevatedSubmitButtonStyle(),
                  child: Text("ଖୋଜନ୍ତୁ"),
                  onPressed: () async {
                    print('search btn pressrd');
                    if (_selectedOption == null) {
                      Fluttertoast.showToast(msg: "କୌଣସି ଏକ ବିକଳ୍ପ ଚୟନ କରନ୍ତୁ");
                    } else {
                      final List<Song>? allSongs;

                      final searchAPI = SearchSongAPI();

                      if (_selectedOption == "Name") {
                        allSongs =
                            await searchAPI.getSongByName(_nameController.text);
                      } else if (_selectedOption == "Singer") {
                        allSongs = await searchAPI
                            .getSongBySingerName(_singerNameController.text);
                      } else if (_selectedOption == "Attribute") {
                        allSongs = await searchAPI
                            .getSongByAttribute(_attributeController.text);
                      } else if (_selectedOption == "Category") {
                        allSongs = await searchAPI
                            .getSongByCategory(_categoryController.text);
                      } else if (_selectedOption == "Duration") {
                        allSongs = await searchAPI.getSongByDuration(_value);
                      } else {
                        allSongs = [];
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultSong(
                            songs: allSongs,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getNameWidget(String? selectedOption) {
    if (selectedOption == "Name") {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextFormField(
          keyboardType: TextInputType.name,
          controller: _nameController,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            labelText: 'Type Song $selectedOption',
            hintStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please Enter Your Name';
            } else if (!RegExp(r'^[a-zA-Z0-9]+(?:[\w -]*[a-zA-Z0-9]+)*$')
                .hasMatch(value)) {
              return 'Please Enter Correct Name';
            }
            return null;
          },
          // style: TextStyle(height: 0.5),
        ),
      );
    } else {
      return SizedBox(width: 0, height: 0);
    }
  }

  Widget getSingerNameWidget(String? selectedOption) {
    if (selectedOption == "Singer") {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextFormField(
          style: TextStyle(color: Constant.white),
          keyboardType: TextInputType.name,
          controller: _singerNameController,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please Enter Your Name';
            } else if (!RegExp(r'^[a-zA-Z0-9]+(?:[\w -]*[a-zA-Z0-9]+)*$')
                .hasMatch(value)) {
              return 'Please Enter Correct Name';
            }
            return null;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            labelText: 'Type $selectedOption Name',
            hintStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          ),
        ),
      );
    } else {
      return SizedBox(width: 0, height: 0);
    }
  }

  Widget getAttributeSong(String? selectedOption) {
    if (selectedOption == "Attribute") {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextFormField(
          keyboardType: TextInputType.name,
          controller: _attributeController,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please Enter Your Name';
            } else if (!RegExp(r'^[a-zA-Z0-9]+(?:[\w -]*[a-zA-Z0-9]+)*$')
                .hasMatch(value)) {
              return 'Please Enter Correct Name';
            }
            return null;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            labelText: 'Type Song $selectedOption',
            hintStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          ),
        ),
      );
    } else {
      return SizedBox(width: 0, height: 0);
    }
  }

  Widget getCategorySong(String? selectedOption) {
    if (selectedOption == "Category") {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextFormField(
          keyboardType: TextInputType.name,
          controller: _categoryController,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please Enter Your Name';
            } else if (!RegExp(r'^[a-zA-Z0-9]+(?:[\w -]*[a-zA-Z0-9]+)*$')
                .hasMatch(value)) {
              return 'Please Enter Correct Name';
            }
            return null;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            labelText: 'Type Song $selectedOption',
            hintStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          ),
        ),
      );
    } else {
      return SizedBox(width: 0, height: 0);
    }
  }

  Widget getDurationWidget(String? selectedOption) {
    if (selectedOption == "Duration") {
      return Theme(
        data: ThemeData(unselectedWidgetColor: Colors.teal),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
              title: Text(
                'Small',
                style: TextStyle(color: Colors.white),
              ),
              leading: Radio<String>(
                value: 'small',
                groupValue: _value,
                onChanged: (value) {
                  setState(() {
                    _value = value!; //'0:04:00 - 0:07:00';
                  });
                },
              ),
            ),
            ListTile(
              title: Text(
                'Medium',
                style: TextStyle(color: Colors.white),
              ),
              leading: Radio<String>(
                groupValue: _value,
                value: 'medium',
                onChanged: (value) {
                  setState(() {
                    _value = value!; //'0:07:00 - 0:10:00';
                  });
                },
              ),
            ),
            ListTile(
              title: Text(
                'Long',
                style: TextStyle(color: Colors.white),
              ),
              leading: Radio<String>(
                groupValue: _value,
                value: 'long',
                onChanged: (value) {
                  setState(() {
                    _value = value!; //'> 0:10:00';
                  });
                },
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox(width: 0, height: 0);
    }
  }
}
