import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant.dart';
import 'package:flutter_application_1/edit_song.dart';
import 'package:flutter_application_1/models/songs_model.dart';
import 'package:provider/provider.dart';
import 'lyrics.dart';
import 'models/usermodel.dart';
import 'music_player.dart';

class SongDetail extends StatefulWidget {
  SongDetail(
      {Key? key,
      required this.song,
      required this.songList,
      required this.index,
      this.loggedInUser})
      : super(key: key);

  final int index;
  final AppUser? loggedInUser;
  final Song song;
  final List<Song>? songList;

  @override
  _SongDetailState createState() => _SongDetailState();
}

class _SongDetailState extends State<SongDetail> {
  //bool _hasBeenPressed = false;
  int? _currentIndex;
  Song? _currentSong;
  bool _editvisible = false;
  double _fontSize = 16;
  bool _lyricsExpanded = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    //to set favorite button color based on the user's favorite song
    // if (widget.loggedInUser != null &&
    //     widget.loggedInUser!.favoriteSongIds != null) {
    //   if (widget.loggedInUser!.favoriteSongIds!.contains(widget.song.songId)) {
    //     _isFavorite = true;
    //   }
    // }

    // Set the song passed from scrollableSongList as the currect song initially
    _currentSong = widget.song;
    _currentIndex = widget.index;
    setState(() {
      _editvisible = widget.loggedInUser?.allowEdit ?? false;
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

  Widget Favorite() {
    return IconButton(
      icon: Icon(
        Icons.favorite,
        size: 40,
        color: _isFavorite
            ? Theme.of(context).iconTheme.color!
            : Constant.lightblue,
      ),
      onPressed: () async {
        if (_isFavorite == false) {
          await Provider.of<AppUser>(context, listen: false)
              .addSongIdToFavoriteSongIds(widget.song.songId);
          setState(
            () {
              _isFavorite = true;
            },
          );
        } else {
          await Provider.of<AppUser>(context, listen: false)
              .removeSongIdFromFavoriteSongIds(widget.song.songId);
          setState(
            () {
              _isFavorite = false;
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final favSongIds =
        Provider.of<AppUser>(context, listen: true).favoriteSongIds;

    if (favSongIds != null && favSongIds.contains(widget.song.songId)) {
      setState(() {
        _isFavorite = true;
      });
    }
    print('*********$favSongIds*********');
    print(_isFavorite);
    return Container(
      child: Scaffold(
        appBar: AppBar(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
          toolbarHeight: 90,
          leading: BackButton(
            color: Theme.of(context).iconTheme.color,
            onPressed: () {
              Navigator.of(context).pop(favSongIds);
            },
          ),
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
                    fontSize: 13,
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
        body: Consumer<AppUser>(
          builder: (context, provider, child) {
            return SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Stack(
                        children: [
                          Center(
                            child: LyricsViewer(
                              lyrics: _currentSong?.songText ?? "",
                              fontSize: _fontSize,
                            ),
                          ),
                          if (!_lyricsExpanded)
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Container(
                                  alignment: Alignment.bottomRight,
                                  child: Favorite()),
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
            );
          },
        ),
      ),
    );
  }
}
