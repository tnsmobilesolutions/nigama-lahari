import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/songs_model.dart';
import 'music_player.dart';

class ScrollableSongList extends StatefulWidget {
  ScrollableSongList({
    Key? key,
    this.songCategory,
    this.songs,
  }) : super(key: key);

  final String? songCategory;
  List<Song>? songs;

  @override
  _ScrollableSongListState createState() => _ScrollableSongListState();
}

class _ScrollableSongListState extends State<ScrollableSongList> {
  List<Song>? items, results;

  @override
  void initState() {
    super.initState();

    items = widget.songs;
  }

  void _runFilter(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      results = items;
    } else {
      results = widget.songs!
          .where((text) => text.songTitle!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(
      () {
        items = results;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.purple, Colors.teal],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Container(
              height: 40,
              child: TextField(
                onChanged: (value) {
                  _runFilter(value);
                },
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black26,
                    contentPadding: EdgeInsets.all(0),
                    prefixIcon: Icon(Icons.search, color: Colors.green),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide.none),
                    hintStyle:
                        TextStyle(fontSize: 18, color: Colors.grey.shade500),
                    hintText: "ଗୀତ ଖୋଜନ୍ତୁ"),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: items!.isNotEmpty
                    ? ListView.builder(
                        itemCount: items?.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.songs![index].songTitle ?? "",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                  ),
                                  Text(
                                    widget.songs![index].singerName ?? "",
                                    style: TextStyle(
                                      color: Colors.green,
                                      //fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MusicPlayer(
                                    song: widget.songs![index],
                                    songList: widget.songs,
                                    index: index,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          '',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
