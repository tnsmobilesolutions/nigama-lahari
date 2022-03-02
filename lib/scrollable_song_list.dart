import 'package:flutter/material.dart';

class ScrollableSongList extends StatefulWidget {
  ScrollableSongList({Key? key, required this.listName, required this.items})
      : super(key: key);

  final String? listName;
  final List<String>? items;
  @override
  _ScrollableSongListState createState() => _ScrollableSongListState();
}

class _ScrollableSongListState extends State<ScrollableSongList> {
  @override
  Widget build(BuildContext context) {
    //final title = 'Long List';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('${widget.listName} ତାଲିକା'),
      ),
      body: ListView.builder(
        itemCount: widget.items?.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(widget.items![index]),
          );
        },
      ),
    );
  }
}
