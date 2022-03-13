import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter_application_1/edit_song.dart';
import 'package:flutter_application_1/lyrics.dart';
import 'package:flutter_application_1/models/songs_model.dart';

class MusicPlayer extends StatefulWidget {
  MusicPlayer(
      {Key? key,
      required this.song,
      required this.songList,
      required this.index})
      : super(key: key);

  final Song song;
  final List<Song>? songList;
  final int index;

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  //final double screenHeight = MediaQuery.of(context).size.height;
  Song? _currentSong;
  int? _currentIndex;
  Duration _duration = new Duration();
  Duration _position = new Duration();

  bool nextDone = true;
  bool prevDone = true;
  bool isRepeat = false;
  Color color = Colors.green;

  AudioService? audioService = AudioService();
  AudioPlayer? audioPlayer = AudioPlayer();
  PlayerState playerState = PlayerState.PAUSED;
  AudioCache? audioCache;

  @override
  void initState() {
    super.initState();
    // Set the song passed from scrollableSongList as the currect song initially
    _currentSong = widget.song;
    _currentIndex = widget.index;

    // It's not recomended to play while init since user may just need to read the lyrics
    // so playing instantly may disturb the user.
    //playMusic();

    audioPlayer!.onPlayerStateChanged.listen((PlayerState s) {
      setState(() {
        playerState = s;
      });
    });

    //max duration of mp3 file
    audioPlayer?.onDurationChanged.listen(
      (Duration d) {
        print('Max duration: $d');
        setState(() => _duration = d);
      },
    );

    //current playtime of mp3 file
    audioPlayer?.onAudioPositionChanged.listen(
      (Duration p) {
        //print('Current position: ${p.inSeconds}');
        setState(() => _position = p);
      },
    );

    audioCache = AudioCache(fixedPlayer: audioPlayer);
    audioPlayer?.onPlayerStateChanged.listen(
      (PlayerState s) {
        setState(
          () {
            playerState = s;
          },
        );
      },
    );

    //after complete the song the slider will be back to start
    audioPlayer?.onPlayerCompletion.listen(
      (event) {
        setState(() {
          _position = Duration(seconds: 0);
          //buttonRepeat();
        });
      },
    );
  }

  //slider implimentation
  Widget slider() {
    return Slider(
      activeColor: Colors.green[900],
      inactiveColor: Colors.green[400],
      value: _position.inSeconds.toDouble(),
      min: 0.0,
      max: _duration.inSeconds.toDouble(),
      onChanged: (double value) {
        setState(() {
          changeToSecond(value.toInt());
          value = value;
        });
      },
    );
  }

  //slider in seconds
  void changeToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    audioPlayer?.seek(newDuration);
  }

  //fastforward button
  Widget buttonFast() {
    return IconButton(
      icon: Icon(
        Icons.fast_forward_rounded,
        size: 40,
        color: Colors.green,
      ),
      onPressed: () {
        audioPlayer?.setPlaybackRate(1.5);
      },
    );
  }

  //slow button
  Widget buttonSlow() {
    return IconButton(
      icon: Icon(
        Icons.fast_rewind_rounded,
        size: 40,
        color: Colors.green,
      ),
      onPressed: () {
        //audioPlayer?.setPlaybackRate(1);
        audioPlayer?.setPlaybackRate(0.5);
      },
    );
  }

  //next song
  Widget nextSong() {
    return IconButton(
      icon: Icon(
        Icons.skip_next_rounded,
        size: 40,
        color: isLastIndex ? Colors.blueGrey : Colors.green,
      ),
      onPressed: nextSongPressed,
    );
  }

  void nextSongPressed() {
    if (!isLastIndex) {
      setState(
        () {
          _currentIndex = _currentIndex! + 1;
          _currentSong = widget.songList![_currentIndex!];
        },
      );
    }
  }

  bool get isLastIndex {
    // Check if the current index is less than the last index
    if (widget.songList != null && _currentIndex != null) {
      return _currentIndex! == widget.songList!.length - 1;
    } else {
      return true;
    }
  }

  //previous song
  Widget previousSong() {
    return IconButton(
      icon: Icon(
        Icons.skip_previous_rounded,
        size: 40,
        color: isFirstIndex ? Colors.blueGrey : Colors.green,
      ),
      onPressed: prevSongPressed,
    );
  }

  void prevSongPressed() {
    if (!isFirstIndex &&
        widget.songList != null &&
        widget.songList!.length > 0) {
      setState(
        () {
          _currentIndex = _currentIndex! - 1;
          _currentSong = widget.songList![_currentIndex!];
        },
      );
    }
  }

  bool get isFirstIndex {
    // Check if the current index is 0th index
    return (_currentIndex ?? 0) == 0;
  }

  Widget buttonShuffle() {
    return IconButton(
      icon: Icon(
        Icons.shuffle,
        size: 40,
        color: Colors.green,
      ),
      onPressed: () {
        if (isRepeat == false) {}
      },
    );
  }

  //to loop a song
  Widget buttonLoop() {
    return IconButton(
      icon: Icon(
        Icons.loop_rounded,
        size: 40,
        color: color,
      ),
      onPressed: () {
        if (isRepeat == false) {
          audioPlayer?.setReleaseMode(ReleaseMode.LOOP);
          setState(
            () {
              color = Colors.black;
              isRepeat = true;
            },
          );
        } else if (isRepeat == true) {
          audioPlayer?.setReleaseMode(ReleaseMode.RELEASE);
          setState(
            () {
              color = Colors.green;
              isRepeat = false;
            },
          );
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer?.release();
    audioPlayer?.dispose();
  }

  playMusic() async {
    print(_currentSong?.songURL);
    if (_currentSong?.songURL != null) {
      await audioPlayer?.play(_currentSong!.songURL!);
    }
  }

  pauseMusic() async {
    await audioPlayer?.pause();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.yellowAccent[700],
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_downward),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditSong(
                        song: _currentSong!,
                      ),
                    ),
                  );
                },
              ),
            ],
          )
        ],
      ),
      body: Container(
        color: Colors.yellowAccent[700],
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  children: [
                    Container(
                        height: screenHeight / 1.8,
                        width: screenWidth / 1.2,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.green, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Align(
                          alignment: Alignment.center,
                          child: Expanded(
                            child: LyricsViewer(
                              lyrics: _currentSong?.songText ?? "",
                            ),
                          ),
                        )),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${_currentSong?.songTitle}',
                      style: TextStyle(
                        fontSize: 30,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${_currentSong?.singerName}',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),

                //
                Column(
                  //mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        slider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              _position.toString().split('.')[0],
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              _duration.toString().split('.')[0],
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32.0),
                              color: Colors.yellowAccent[700]),
                          padding: EdgeInsets.fromLTRB(18, 10, 18, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(child: buttonLoop()),
                              //Expanded(child: buttonSlow()),
                              Expanded(child: previousSong()),
                              Expanded(
                                child: IconButton(
                                  icon: Icon(
                                    playerState == PlayerState.PLAYING
                                        ? Icons.pause_circle_filled_rounded
                                        : Icons.play_circle_filled_rounded,
                                  ),
                                  iconSize: 60,
                                  color: Colors.green,
                                  onPressed: () {
                                    playerState == PlayerState.PLAYING
                                        ? pauseMusic()
                                        : playMusic();
                                  },
                                ),
                              ),

                              Expanded(child: nextSong()),
                              //Expanded(child: buttonFast()),
                              Expanded(child: buttonShuffle()),
                            ],
                          ),
                        ),
                      ],
                    ),

                    //AudioFile(advancedPlayer: advancedPlayer),
                  ],
                ),
                SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
