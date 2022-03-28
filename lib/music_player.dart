import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant.dart';
import 'package:flutter_application_1/models/songs_model.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({
    Key? key,
    required this.song,
    required this.songList,
    required this.index,
    this.onPreviousTappedCallback,
    this.onNextTappedCallback,
  }) : super(key: key);

  final Song song;
  final List<Song>? songList;
  final int index;
  final VoidCallback? onPreviousTappedCallback;
  final VoidCallback? onNextTappedCallback;

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  Song? _currentSong;
  int? _currentIndex;
  Duration _duration = new Duration();
  Duration _position = new Duration();

  bool nextDone = true;
  bool prevDone = true;
  bool isRepeat = false;
  bool haveDuration = false;
  Color color = Constant.orange;

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

    audioPlayer!.onPlayerStateChanged.listen(
      (PlayerState s) {
        setState(
          () {
            playerState = s;
          },
        );
      },
    );

    MaxDuration().then((value) => nextSong());

    // //max duration of mp3 file
    // audioPlayer?.onDurationChanged.listen(
    //   (Duration d) {
    //     print('Max duration: $d');
    //     setState(() => _duration = d);
    //   },
    // );

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

  //max duration of mp3 file
  Future<StreamSubscription<Duration>?> MaxDuration() async {
    StreamSubscription<Duration>? maxDuration =
        await audioPlayer?.onDurationChanged.listen(
      (Duration d) {
        print('Max duration: $d');
        setState(() => _duration = d);
      },
    );
    setState(() {
      haveDuration = true;
    });
    // nextSongPressed();
    return maxDuration;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              slider(),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _position.toString().split('.')[0],
                      style: TextStyle(
                        color: Constant.white,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      _duration.toString().split('.')[0],
                      style: TextStyle(
                        color: Constant.white,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //Expanded(child: buttonLoop()),
                  Expanded(child: previousSong()),
                  Expanded(
                    child: IconButton(
                      icon: Icon(
                        playerState == PlayerState.PLAYING
                            ? Icons.pause_circle_filled_rounded
                            : Icons.play_circle_filled_rounded,
                      ),
                      iconSize: 60,
                      color: Constant.orange,
                      onPressed: () {
                        playerState == PlayerState.PLAYING
                            ? pauseMusic()
                            : playMusic();
                      },
                    ),
                  ),
                  Expanded(child: nextSong()),
                  // Expanded(child: buttonShuffle()),
                ],
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),

          //AudioFile(advancedPlayer: advancedPlayer),
        ],
      ),
    );
  }

  //slider implimentation
  Widget slider() {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 2,
      ),
      child: Slider(
        activeColor: Constant.orange,
        inactiveColor: Constant.lightblue,
        value: _position.inSeconds.toDouble(),
        min: 0.0,
        max: _duration.inSeconds.toDouble(),
        onChanged: (double value) {
          setState(() {
            changeToSecond(value.toInt());
            value = value;
          });
        },
      ),
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
        color: isLastIndex ? Constant.lightblue : Constant.orange,
      ),
      onPressed: haveDuration ? nextSongPressed : () {},
    );
  }

  void nextSongPressed() {
    if (!isLastIndex) {
      setState(
        () {
          _currentIndex = _currentIndex! + 1;
          _currentSong = widget.songList![_currentIndex!];
          playerState == PlayerState.PLAYING ? playMusic() : pauseMusic();
        },
      );

      // Call the Next callback
      if (widget.onNextTappedCallback != null) {
        widget.onNextTappedCallback!();
      }
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
        color: isFirstIndex ? Constant.lightblue : Constant.orange,
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
          playerState == PlayerState.PLAYING ? playMusic() : pauseMusic();
        },
      );

      // Call the Previous callback
      if (widget.onPreviousTappedCallback != null) {
        widget.onPreviousTappedCallback!();
      }
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
        color: Theme.of(context).iconTheme.color,
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
              color = Constant.lightblue;
              isRepeat = true;
            },
          );
        } else if (isRepeat == true) {
          audioPlayer?.setReleaseMode(ReleaseMode.RELEASE);
          setState(
            () {
              Theme.of(context).iconTheme.color;
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
}
