import 'package:flutter/material.dart';
import 'package:flutter_application_1/common_widgets/common_style.dart';
import 'package:flutter_application_1/fileUpload.dart';
import 'package:flutter_application_1/nigamLahari/nigam_lahari.dart';

class AddSongLyrics extends StatefulWidget {
  const AddSongLyrics({Key? key}) : super(key: key);

  @override
  _AddSongLyricsState createState() => _AddSongLyricsState();
}

class _AddSongLyricsState extends State<AddSongLyrics> {
  @override
  Widget build(BuildContext context) {
    final height = 100;
    final Title = TextFormField(
      autofocus: false,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(15),
          hintText: 'TITLE',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );

    final Lyrics = TextFormField(
      autofocus: false,
      maxLines: height ~/ 6,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.newline,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(15),
          hintText: 'Song Lyrics',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );
    final uploadSongText = Text('Upload Songs', style: CommonStyle.myStyle);
    final SongLyricsText = Text('Song Lyrics', style: CommonStyle.myStyle);
    final uploadButton = FloatingActionButton.extended(
        heroTag: "btn1",
        label: const Text('Upload'),
        icon: const Icon(Icons.file_upload_outlined),
        backgroundColor: Colors.blueGrey,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return FileUpload();
            },
          ));
        });
    final sizebox = SizedBox(height: 20);
    final saveButton = FloatingActionButton.extended(
        heroTag: "btn2",
        label: const Text('SAVE'),
        icon: const Icon(Icons.file_upload_outlined),
        backgroundColor: Colors.blueGrey,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return NigamLahari();
            },
          ));
        });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add New Song'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Title,
              sizebox,
              SongLyricsText,
              sizebox,
              Lyrics,
              sizebox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  uploadSongText,
                  uploadButton,
                ],
              ),
              sizebox,
              Center(child: saveButton)
            ],
          ),
        ),
      ),
    );
  }
}
