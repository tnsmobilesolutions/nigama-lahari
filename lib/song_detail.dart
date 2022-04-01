import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/edit_song.dart';
import 'package:flutter_application_1/models/songs_model.dart';
import 'package:flutter_application_1/music_player.dart';

import 'lyrics.dart';
import 'models/usermodel.dart';

class SongDetail extends StatefulWidget {
  SongDetail(
      {Key? key,
      required this.song,
      required this.songList,
      required this.index,
      this.loggedInUser})
      : super(key: key);

  final Song song;
  final List<Song>? songList;
  final int index;
  final AppUser? loggedInUser;

  @override
  _SongDetailState createState() => _SongDetailState();
}

class _SongDetailState extends State<SongDetail> {
  Song? _currentSong;
  int? _currentIndex;
  bool _lyricsExpanded = false;
  double _fontSize = 16;
  bool Edit = false;
  bool _editvisible = false;

  @override
  void initState() {
    super.initState();
    // Set the song passed from scrollableSongList as the currect song initially
    _currentSong = widget.song;
    _currentIndex = widget.index;
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      final remoteConfig = await FirebaseRemoteConfig.instance;
      final defaultValue = <String, dynamic>{
        'add': false,
      };

      try {
        await remoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: const Duration(hours: 24), //cache refresh time
          minimumFetchInterval: Duration.zero,
        ));
        await remoteConfig.setDefaults(defaultValue);
        await remoteConfig.fetchAndActivate();
      } on PlatformException catch (exception) {
// Fetch exception.
        print(exception);
      } catch (exception) {
        print('Unable to fetch remote config. Cached or default values will be '
            'used');
        print("exception===>$exception");
      }

      setState(() {
        Edit = remoteConfig.getBool('Edit');
        if (Edit == true) {
          _editvisible = !_editvisible;
        }
      });
    });
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
    // double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(color: Theme.of(context).iconTheme.color),
          automaticallyImplyLeading: _lyricsExpanded ? false : true,
          title: Center(
            child: Column(
              children: [
                Text(
                  '${_currentSong?.songTitle}',
                  style: TextStyle(
                    fontSize: 20,
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
                  Visibility(
                    visible: _editvisible,
                    child: IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      onPressed: () {
                        if (_currentSong != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditSong(
                                song: _currentSong!,
                                loggedInUser: widget.loggedInUser,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                if (_lyricsExpanded)
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onPressed: () {
                      setState(() {
                        _fontSize = _fontSize + 1;
                      });
                    },
                  ),
                if (_lyricsExpanded)
                  IconButton(
                    icon: Icon(
                      Icons.remove,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onPressed: () {
                      if (_fontSize > 16) {
                        setState(() {
                          _fontSize = _fontSize - 1;
                        });
                      }
                    },
                  ),
                IconButton(
                  icon: Icon(
                    _lyricsExpanded ? Icons.zoom_in_map : Icons.zoom_out_map,
                    color: Theme.of(context).iconTheme.color,
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
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: LyricsViewer(
                      lyrics: _currentSong?.songText ?? "",
                      fontSize: _fontSize,
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
