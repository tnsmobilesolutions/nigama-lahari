import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({Key? key}) : super(key: key);

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  //final double screenHeight = MediaQuery.of(context).size.height;
  Duration _duration = new Duration();
  Duration _position = new Duration();

  bool isRepeat = false;
  Color color = Colors.green;

  AudioPlayer? audioPlayer = AudioPlayer();
  PlayerState audioPlayerState = PlayerState.PAUSED;
  AudioCache? audioCache;
  String path = 'music.mp3';

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

  Widget buttonLoop() {
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

  Widget buttonRepeat() {
    return IconButton(
      icon: Icon(
        Icons.loop,
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
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 700,
            child: Container(
              color: Colors.green,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {},
                )
              ],
            ),
          ),
          Positioned(
            top: 600,
            left: 0,
            right: 0,
            height: 350,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(48),
                color: Colors.yellowAccent[700],
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'ଜଗାଅରେ ଗଗନ ଭୁବନ ପବନ',
                    style: TextStyle(
                      fontSize: 30,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'ପ୍ରେମାନନ୍ଦ ମିଶ୍ର',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  slider(),
                  // SizedBox(
                  //   height: 15,
                  // ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buttonRepeat(),
                      buttonSlow(),
                      IconButton(
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
                      buttonFast(),
                      buttonLoop(),
                    ],
                  ),
                  //AudioFile(advancedPlayer: advancedPlayer),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
