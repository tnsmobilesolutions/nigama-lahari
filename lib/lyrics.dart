import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant.dart';

class LyricsViewer extends StatefulWidget {
  const LyricsViewer({Key? key, required this.lyrics, required this.fontSize})
      : super(key: key);

  final String lyrics;
  final double? fontSize;

  @override
  State<LyricsViewer> createState() => _LyricsViewerState();
}

class _LyricsViewerState extends State<LyricsViewer> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
      // scrollDirection: Axis.vertical,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 1,
            child: Text(
              widget.lyrics,
              overflow: TextOverflow.fade,
              softWrap: true,
              style: TextStyle(
                color: Constant.white,
                fontSize: widget.fontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
