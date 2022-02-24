import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({Key? key}) : super(key: key);

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  //final double screenHeight = MediaQuery.of(context).size.height;

  AudioPlayer? audioPlayer = AudioPlayer();
  PlayerState audioPlayerState = PlayerState.PAUSED;
  AudioCache? audioCache;
  String path = 'music.mp3';

  @override
  void initState() {
    super.initState();

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

    //advancedPlayer = AudioPlayer();
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
                    height: 40,
                  ),
                  IconButton(
                    icon: Icon(
                      audioPlayerState == PlayerState.PLAYING
                          ? Icons.pause_circle_filled_rounded
                          : Icons.play_circle_fill_rounded,
                    ),
                    iconSize: 60,
                    onPressed: () {
                      audioPlayerState == PlayerState.PLAYING
                          ? pauseMusic()
                          : playMusic();
                    },
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
