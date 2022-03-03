import 'package:flutter/material.dart';
import 'package:flutter_application_1/API/searchSongAPI.dart';
import 'package:flutter_application_1/common_widgets/common_style.dart';
import 'package:flutter_application_1/models/songs_model.dart';
import 'package:flutter_application_1/search_functionality.dart/result_song.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<String> _songs = ['Name', 'Singer', 'Attribute', 'Catagory', 'Duration'];
  String? _selectedSong;

  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Search'),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            // Text("Search By",
            //    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            DropdownButton(
              hint: Text('Search Songs'),
              value: _selectedSong,
              onChanged: (newValue) {
                setState(() {
                  _selectedSong = newValue as String?;
                });
              },
              items: _songs.map((songs) {
                return DropdownMenuItem(
                  child: new Text(songs),
                  value: songs,
                );
              }).toList(),
            ),
            SizedBox(height: 40),
            getNameWidget(_selectedSong),
            ElevatedButton(
                style: CommonStyle.elevatedSubmitButtonStyle(),
                child: Text("Search"),
                onPressed: () async {
                  print('search btn pressrd');

                  final List<SongsModel>? allSongs;

                  final searchAPI = SearchSongAPI();

                  if (_selectedSong == "Name") {
                    allSongs =
                        await searchAPI.getSongByName(_nameController.text);
                    // } else if (_selectedSong == 'Date') {
                    //   allSongs =
                    //       await searchAPI.getReceiptByReceiptDate(_dateTime);
                    // } else if (_selectedSong == "Account/Head") {
                    //   allSongs = await searchAPI
                    //       .getReceiptByAccount(_accountController.text);
                  } else {
                    allSongs = [];
                  }

                  print(allSongs);
                  // if (_selectedSong == "Receipt No") {
                  //   final singleReceipt = await searchAPI
                  //       .getReceiptByReceiptNo(_receiptNoController.text);
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) =>
                  //               ReceiptPreview(receipt: singleReceipt)));
                  // } else {
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
    );
  }

  Widget getNameWidget(String? selectedSong) {
    if (selectedSong == "Name") {
      return TextFormField(
        keyboardType: TextInputType.name,
        controller: _nameController,
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
      );
    } else {
      return SizedBox(width: 0, height: 0);
    }
  }
}
