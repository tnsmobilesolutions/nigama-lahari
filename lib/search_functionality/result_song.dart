import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/songs_model.dart';

import '../music_player.dart';

class ResultSong extends StatefulWidget {
  ResultSong({Key? key, this.songs}) : super(key: key);

  final List<Song>? songs;

  @override
  State<ResultSong> createState() => _ResultSongState();
}

class _ResultSongState extends State<ResultSong> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Result Song')),
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: widget.songs?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            child: Container(
              //color: Colors.amber[colorCodes[index]],
              // child: Center(child: Text('Entry ${entries[index]}')),
              color: Colors.yellowAccent[700],
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    //Text("ଜୟଗୁରୁ"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          widget.songs?[index].singerName ?? '',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          widget.songs?[index].songTitle.toString() ?? '',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     Text(widget.receipts?[index].paaliaName ?? ''),
                    //     Text(widget.receipts?[index].amount.toString() ?? ''),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MusicPlayer(
                    songName: widget.songs![index].songTitle ?? "",
                    singername: widget.songs![index].singerName ?? "",
                    songUrl: widget.songs![index].songURL ?? "",
                    songLyrics: widget.songs![index].songText ?? "",
                  ),
                ),
              );
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}
