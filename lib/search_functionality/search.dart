import 'package:flutter/material.dart';
import 'package:flutter_application_1/API/searchSongAPI.dart';
// import 'package:flutter_application_1/common_widgets/common_style.dart';
import 'package:flutter_application_1/models/songs_model.dart';

import 'package:flutter_application_1/search_functionality/result_song.dart';

import '../login/common_widgets/common_style.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<String> _songs = ["Name", "Singer", "Attribute", "Category", "Duration"];
  String? _selectedSong;

  final _nameController = TextEditingController();
  final _singerNameController = TextEditingController();
  final _attributeController = TextEditingController();
  final _categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   centerTitle: true,
        //   title: Text('ଖୋଜନ୍ତୁ'),
        // ),
        body: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              // Text("Search By",
              //    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              DropdownButton(
                hint: Text('ସଂଗୀତ ଖୋଜନ୍ତୁ'),
                value: _selectedSong,
                onChanged: (newValue) {
                  setState(() {
                    _selectedSong = newValue as String?;
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
              SizedBox(height: 40),
              getNameWidget(_selectedSong),
              getSingerNameWidget(_selectedSong),
              getAttributeSong(_selectedSong),
              getCategorySong(_selectedSong),
              ElevatedButton(
                  style: CommonStyle.elevatedSubmitButtonStyle(),
                  child: Text("ଖୋଜନ୍ତୁ"),
                  onPressed: () async {
                    print('search btn pressrd');

                    final List<Song>? allSongs;

                    final searchAPI = SearchSongAPI();

                    if (_selectedSong == "Name") {
                      allSongs =
                          await searchAPI.getSongByName(_nameController.text);
                    } else if (_selectedSong == "Singer") {
                      allSongs = await searchAPI
                          .getSongBySingerName(_singerNameController.text);
                    } else if (_selectedSong == "Attribute") {
                      allSongs = await searchAPI
                          .getSongByAttribute(_attributeController.text);
                    } else if (_selectedSong == "Category") {
                      allSongs = await searchAPI
                          .getSongByCategory(_categoryController.text);
                    } else {
                      allSongs = [];
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResultSong(
                                  songs: allSongs,
                                )));
                    // }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget getNameWidget(String? selectedSong) {
    if (selectedSong == "Name") {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextFormField(
          keyboardType: TextInputType.name,
          controller: _nameController,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
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

  Widget getSingerNameWidget(String? selectedSong) {
    if (selectedSong == "Singer") {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextFormField(
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
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
        ),
      );
    } else {
      return SizedBox(width: 0, height: 0);
    }
  }

  Widget getAttributeSong(String? selectedSong) {
    if (selectedSong == "Attribute") {
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
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
        ),
      );
    } else {
      return SizedBox(width: 0, height: 0);
    }
  }

  Widget getCategorySong(String? selectedSong) {
    if (selectedSong == "Category") {
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
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
        ),
      );
    } else {
      return SizedBox(width: 0, height: 0);
    }
  }

  Widget getDurationWidget(String? selectedSong) {
    if (selectedSong == "Duration") {
      return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            child: Column(children: [
              Text('<6'),
              Text('6-15'),
              Text('>15'),
            ]),
          )

          // TextFormField(
          //   keyboardType: TextInputType.name,
          //   controller: _categoryController,
          //   validator: (value) {
          //     if (value!.isEmpty) {
          //       return 'Please Enter Your Name';
          //     } else if (!RegExp(r'^[a-zA-Z0-9]+(?:[\w -]*[a-zA-Z0-9]+)*$')
          //         .hasMatch(value)) {
          //       return 'Please Enter Correct Name';
          //     }
          //     return null;
          //   },
          //   decoration: InputDecoration(
          //       border:
          //           OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
          // ),
          );
    } else {
      return SizedBox(width: 0, height: 0);
    }
  }
}
