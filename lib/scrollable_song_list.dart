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
  final List<Song>? songs;

  @override
  _ScrollableSongListState createState() => _ScrollableSongListState();
}

class _ScrollableSongListState extends State<ScrollableSongList> {
  //bool _folded = true;
  @override
  Widget build(BuildContext context) {
    //final title = 'Long List';

    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('${widget.songCategory} ତାଲିକା'),
      ),
      body: ListView.builder(
        itemCount: widget.songs?.length,
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
                    // TODO: Music Player should only accept the song object.
                    songName: widget.songs![index].songTitle ?? "",
                    singername: widget.songs![index].singerName ?? "",
                    songUrl: widget.songs![index].songURL ?? "",
                    //songLyrics: widget.songs![index].songText ?? "",
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
