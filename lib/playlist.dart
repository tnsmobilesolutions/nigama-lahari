import 'package:flutter/material.dart';

import 'constant.dart';

class Playlist extends StatefulWidget {
  const Playlist({Key? key}) : super(key: key);

  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(color: Theme.of(context).iconTheme.color),
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Playlist',
            style: TextStyle(color: Constant.orange),
          ),
        ),
      ),
    );
  }
}
