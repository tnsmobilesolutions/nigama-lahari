import 'package:flutter/material.dart';
// import 'package:flutter_application_1/common_widgets/common_style.dart';
import 'package:flutter_application_1/models/songs_model.dart';

import '../login/common_widgets/common_style.dart';
import '../song_detail.dart';

class ResultSong extends StatefulWidget {
  ResultSong({Key? key, this.songs}) : super(key: key);

  final List<Song>? songs;

  @override
  State<ResultSong> createState() => _ResultSongState();
}

class _ResultSongState extends State<ResultSong> {
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
        appBar: AppBar(
          title: Text('ଆପଣ ଖୋଜୁଥିବା ଗୀତ'),
          centerTitle: true,
        ),
        body: ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: widget.songs?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              child: Container(
                color: Colors.purple,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(widget.songs?[index].songTitle ?? '',
                              style: CommonStyle.myStyle),
                          Text(widget.songs?[index].singerName ?? ''),
                        ],
                      ),
                    ],
                  ),
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
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        ),
      ),
    );
  }
}
