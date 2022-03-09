import 'package:flutter/material.dart';
import 'music_player.dart';

class ScrollableSongList extends StatefulWidget {
  ScrollableSongList({
    Key? key,
    required this.listName,
    required this.song,
    required this.singer,
  }) : super(key: key);

  final String? listName;
  final List<String>? song, singer;

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
        title: Text('${widget.listName} ତାଲିକା'),
      ),
      body: ListView.builder(
        itemCount: widget.song?.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.song![index],
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  Text(
                    widget.singer![index],
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
                    songName: widget.song![index],
                    singerName: widget.singer![index],
                    //url: widget.url!,
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
