import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/songs_model.dart';

class ResultSong extends StatefulWidget {
  ResultSong({Key? key, this.songs}) : super(key: key);

  final List<SongsModel>? songs;

  @override
  State<ResultSong> createState() => _ResultSongState();
}

class _ResultSongState extends State<ResultSong> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Result Song')),
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: widget.songs?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            child: Container(
              //color: Colors.amber[colorCodes[index]],
              // child: Center(child: Text('Entry ${entries[index]}')),
              color: Colors.black12,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(widget.songs?[index].songTitle ?? ''),
                        Text(widget.songs?[index].songText.toString() ?? ''),
                      ],
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     Text(widget.receipts?[index].paaliaName ?? ''),
                    //     Text(widget.receipts?[index].amount.toString() ?? ''),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
            // onTap: () => Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) =>
            //             ReceiptPreview(receipt: widget.receipts?[index]))),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}
