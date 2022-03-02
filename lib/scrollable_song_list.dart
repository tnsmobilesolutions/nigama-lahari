import 'package:flutter/material.dart';

import 'music_player.dart';

class ScrollableSongList extends StatefulWidget {
  ScrollableSongList(
      {Key? key,
      required this.listName,
      required this.items,
      required this.singer})
      : super(key: key);

  final String? listName;
  final List<String>? items;
  final List<String>? singer;

  @override
  _ScrollableSongListState createState() => _ScrollableSongListState();
}

class _ScrollableSongListState extends State<ScrollableSongList> {
  bool _folded = true;
  @override
  Widget build(BuildContext context) {
    //final title = 'Long List';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('${widget.listName} ତାଲିକା'),
      ),
      body: ListView.builder(
        itemCount: widget.items?.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.items![index],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  Text(
                    widget.singer![index],
                    style: TextStyle(
                      color: Colors.white,
                      //fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MusicPlayer(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ListView.builder(
//         itemCount: widget.items?.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(widget.items![index]),
//           );
//         },
//       ),


//  Align(
//                     alignment: Alignment.center,
//                     child: Icon(
//                       Icons.play_circle_sharp,
//                       size: 30,
//                       color: Colors.yellowAccent[700],
//                     ),
//                   ),

 