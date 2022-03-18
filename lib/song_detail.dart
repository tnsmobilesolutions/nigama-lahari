import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter_application_1/edit_song.dart';
import 'package:flutter_application_1/lyrics.dart';
import 'package:flutter_application_1/models/songs_model.dart';
import 'package:flutter_application_1/music_player.dart';

class SongDetail extends StatefulWidget {
  SongDetail(
      {Key? key,
      required this.song,
      required this.songList,
      required this.index})
      : super(key: key);

  final Song song;
  final List<Song>? songList;
  final int index;

  @override
  _SongDetailState createState() => _SongDetailState();
}

class _SongDetailState extends State<SongDetail> {
  Song? _currentSong;
  int? _currentIndex;
  bool _lyricsExpanded = false;

  @override
  void initState() {
    super.initState();
    // Set the song passed from scrollableSongList as the currect song initially
    _currentSong = widget.song;
    _currentIndex = widget.index;
  }

  void onPrevPressed() {
    print('prev pressed');
    if (_currentIndex != null && _currentIndex! > 0) {
      setState(() {
        _currentIndex = _currentIndex! - 1;
        _currentSong = widget.songList?[_currentIndex!];
      });
    }
  }

  void onNextPressed() {
    print('next pressed');
    if (_currentIndex != null &&
        _currentIndex! < (widget.songList?.length ?? 0) - 1) {
      setState(() {
        _currentIndex = _currentIndex! + 1;
        _currentSong = widget.songList?[_currentIndex!];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
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
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: _lyricsExpanded ? false : true,
          title: Center(
            child: Column(
              children: [
                Text(
                  '${_currentSong?.songTitle}',
                  style: TextStyle(
                    fontSize: 20,
                    //fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_currentSong?.singerName}',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          elevation: 0,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!_lyricsExpanded)
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      if (_currentSong != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditSong(
                              song: _currentSong!,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                IconButton(
                  icon: Icon(
                    _lyricsExpanded ? Icons.zoom_in_map : Icons.zoom_out_map,
                  ),
                  onPressed: () {
                    print('expand pressed');
                    setState(() {
                      _lyricsExpanded = !_lyricsExpanded;
                    });
                  },
                ),
              ],
            )
          ],
        ),
        body: Container(
          height: double.infinity,
          color: Colors.transparent,
          child: SafeArea(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Center(
                    child: Stack(
                      children: [
                        LyricsViewer(
                          lyrics: _currentSong?.songText ?? "",
                        ),
                      ],
                    ),
                  ),
                ),
                if (!_lyricsExpanded)
                  MusicPlayer(
                    song: widget.song,
                    songList: widget.songList,
                    index: widget.index,
                    onPreviousTappedCallback: onPrevPressed,
                    onNextTappedCallback: onNextPressed,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
