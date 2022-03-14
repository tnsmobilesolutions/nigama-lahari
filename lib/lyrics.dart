import 'package:flutter/material.dart';

class LyricsViewer extends StatefulWidget {
  const LyricsViewer({Key? key, required this.lyrics}) : super(key: key);

  final String lyrics;

  @override
  State<LyricsViewer> createState() => _LyricsViewerState();
}

class _LyricsViewerState extends State<LyricsViewer> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
      scrollDirection: Axis.vertical,
      child: Text(
        widget.lyrics,
        overflow: TextOverflow.fade,
        softWrap: false,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }
}
