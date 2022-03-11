import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter_application_1/models/songs_model.dart';

class MusicPlayer extends StatefulWidget {
  MusicPlayer(
      {Key? key,
      required this.songName,
      required this.singername,
      required this.songUrl,
      required this.songLyrics,
      required this.songList})
      : super(key: key);

  final String songName, singername, songUrl, songLyrics;
  final List<Song>? songList;
  //List<Song>? songs;

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  //final double screenHeight = MediaQuery.of(context).size.height;
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
    playMusic();

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

  //fastforward button
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
        color: Colors.green,
      ),
      onPressed: () {
        //int _counter = 0;
        setState(
          () {
            //widget.songList!;
            //MediaControl.skipToNext;
          },
        );
      },
    );
  }

  //previous song
  Widget previousSong() {
    return IconButton(
      icon: Icon(
        Icons.skip_previous_rounded,
        size: 40,
        color: Colors.green,
      ),
      onPressed: () {
        setState(
          () {
            // widget.songList!;
          },
        );
      },
    );
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
    print(widget.songUrl);
    await audioPlayer?.play(widget.songUrl);
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
                onPressed: () {},
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
                            child: SingleChildScrollView(
                              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                              scrollDirection: Axis.vertical,
                              child: Text(
                                widget.songLyrics,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
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
                      '${widget.songName}',
                      style: TextStyle(
                        fontSize: 30,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${widget.singername}',
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
                              // SizedBox(
                              //   width: 20,
                              // ),
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
