import 'package:flutter/material.dart';

import 'package:flutter_application_1/models/songs_model.dart';

import '../constant.dart';
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
      child: Scaffold(
        appBar: widget.songs!.isNotEmpty
            ? AppBar(
                elevation: 0,
                title: Text('ଆପଣ ଖୋଜୁଥିବା ଗୀତ'),
                centerTitle: true,
              )
            : AppBar(
                backgroundColor: Constant.darkBlue,
                elevation: 0,
                title: Text(''),
                centerTitle: true,
              ),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: widget.songs!.isNotEmpty
                    ? ListView.builder(
                        itemCount: widget.songs?.length ?? 0,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                textColor: Constant.white,
                                tileColor: Constant.lightblue,
                                title: Text(
                                  widget.songs?[index].songTitle ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                                ),
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      widget.songs?[index].songCategory ?? '',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      widget.songs?[index].singerName ?? '',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      widget.songs?[index].songDuration ?? '',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SongDetail(
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
                        child: Column(
                          children: [
                            Image(
                              image: AssetImage('assets/image/sad.png'),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              '             କ୍ଷମା କରିବେ! \n ଏହି ଶବ୍ଦରେ କୌଣସି ଗୀତ ନାହିଁ',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
