import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';

class MusicPlayer extends StatefulWidget {
  MusicPlayer({Key? key, required this.songName, required this.singerName})
      : super(key: key);

  final String songName, singerName;

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
  PlayerState audioPlayerState = PlayerState.PAUSED;
  AudioCache? audioCache;
  String path = 'music2.mp3';

  @override
  void initState() {
    super.initState();

    //max duration of mp3 file
    audioPlayer?.onDurationChanged.listen(
      (Duration d) {
        //print('Max duration: $d');
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
            audioPlayerState = s;
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
      activeColor: Colors.green,
      inactiveColor: Colors.grey,
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
        setState(() {
          MediaControl.skipToNext;
        });
        // setState(
        //   () {
        //     void next() async {
        //       if (nextDone) {
        //         nextDone = false;
        //         await MediaControl.skipToNext;
        //         nextDone = true;
        //       }
        //     }
        //   },
        // );
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
        setState(() {
          MediaControl.skipToPrevious;
        });
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
    //audioCache?.clear();
  }

  playMusic() async {
    await audioCache?.play(path);
  }

  pauseMusic() async {
    await audioPlayer?.pause();
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_downward),
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => ScrollableSongList(),
            //   ),
            // );
          },
        ),
        backgroundColor: Colors.yellowAccent[700],
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        color: Colors.yellowAccent[700],
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
                    '${widget.singerName}',
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
                                  audioPlayerState == PlayerState.PLAYING
                                      ? Icons.pause_circle_filled_rounded
                                      : Icons.play_circle_filled_rounded,
                                ),
                                iconSize: 60,
                                color: Colors.green,
                                onPressed: () {
                                  audioPlayerState == PlayerState.PLAYING
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
    );
  }
}
