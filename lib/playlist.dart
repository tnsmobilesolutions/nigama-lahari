import 'package:flutter/material.dart';

import 'constant.dart';

class Playlist extends StatefulWidget {
  const Playlist({Key? key}) : super(key: key);

  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  // void _runFilter(String enteredKeyword) {
  //   var results;
  //   if (enteredKeyword.isEmpty) {
  //     results = widget.songs;
  //   } else {
  //     results = widget.songs!
  //         .where((text) =>
  //             (text.songTitle ?? "")
  //                 .toLowerCase()
  //                 .contains(enteredKeyword.toLowerCase()) ||
  //             (text.songTitleInEnglish ?? "")
  //                 .toLowerCase()
  //                 .contains(enteredKeyword.toLowerCase()))
  //         .toList();
  //   }
  //   setState(
  //     () {
  //       items = results;
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(color: Theme.of(context).iconTheme.color),
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Playlist',
            style: TextStyle(color: Constant.orange),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 30),
              Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                height: 40,
                child: TextField(
                  //onChanged: (value) => _runFilter(value),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Constant.lightblue,
                      // Constant.isDarkMode
                      //     ? Constant.lightblue
                      //     : Constant.purpleRed,
                      contentPadding: EdgeInsets.all(0),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide.none),
                      hintStyle:
                          TextStyle(fontSize: 18, color: Constant.white24),
                      hintText: "ଗୀତ ଖୋଜନ୍ତୁ"),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
