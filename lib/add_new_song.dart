import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_application_1/models/songs_model.dart';
import 'package:flutter_application_1/nigam_lahari.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'API/firebaseAPI.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'API/song_api.dart';

class AddSong extends StatefulWidget {
  const AddSong({Key? key}) : super(key: key);

  @override
  _AddSongState createState() => _AddSongState();
}

class _AddSongState extends State<AddSong> {
  final _titleController = TextEditingController();
  final _singerNameController = TextEditingController();
  final _songLyrics = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  List<String> _catagory = [
    'ଜାଗରଣ',
    'ପ୍ରତୀକ୍ଷା',
    'ଆବାହନ',
    'ଆରତୀ',
    'ବନ୍ଦନା',
    'ପ୍ରାର୍ଥନା',
    'ବିଦାୟ ପ୍ରାର୍ଥନା',
  ];
  List<String> _attribute = [];
  UploadTask? task;
  File? file;
  String? _selectedOption;
  final height = 100;
  String destination = '';
  double percentage = 0;

  void initState() {
    super.initState();
  }

  // select file from device
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.audio,
    );
    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
  }

  //upload selected file to firebase storage
  Future uploadFile() async {
    if (file == null) {
      return;
    } else {}
    final fileName = basename(file!.path);
    destination = '$_selectedOption/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});
    buildUploadStatus(task!);

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final songUrl = await snapshot.ref.getDownloadURL();

    print('Download-Link: $songUrl');
  }

  //upload status
  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            percentage =
                double.parse((progress * 100).toStringAsFixed(0)) / 100;

            return CircularPercentIndicator(
              radius: 50,
              lineWidth: 20,
              percent: percentage,
              progressColor: Colors.green,
              backgroundColor: Colors.green.shade200,
              circularStrokeCap: CircularStrokeCap.round,
              center: Text(
                '${percentage * 100.toInt()}%',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            );
          } else {
            return Container();
          }
        },
      );
  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Song'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SafeArea(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DropdownButton(
                          hint: Text(
                            'Catagory',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                          value: _selectedOption,
                          dropdownColor: Colors.yellowAccent[700],
                          onChanged: (value) {
                            setState(
                              () {
                                _selectedOption = value as String?;
                                print(_selectedOption.toString());
                              },
                            );
                          },
                          items: _catagory.map(
                            (val) {
                              return DropdownMenuItem(
                                child: new Text(val),
                                value: val,
                              );
                            },
                          ).toList(),
                        ),
                        DropdownButton(
                          hint: Text(
                            'Atribute',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                          value: _selectedOption,
                          dropdownColor: Colors.yellowAccent[700],
                          onChanged: (value) {
                            setState(() {
                              _selectedOption = value as String?;
                              print(_selectedOption.toString());
                            });
                          },
                          items: _attribute.map(
                            (val) {
                              return DropdownMenuItem(
                                child: new Text(val),
                                value: val,
                              );
                            },
                          ).toList(),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.black),
                      controller: _titleController,
                      autofocus: false,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15),
                          hintText: 'Title',
                          hintStyle:
                              TextStyle(fontSize: 15.0, color: Colors.black),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _singerNameController,
                      style: TextStyle(color: Colors.black),
                      autofocus: false,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15),
                          hintText: 'Singer',
                          hintStyle:
                              TextStyle(fontSize: 15.0, color: Colors.black),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _songLyrics,
                      style: TextStyle(color: Colors.black),
                      autofocus: false,
                      maxLines: height ~/ 6,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(15),
                        hintText: 'Song Lyrics',
                        hintStyle:
                            TextStyle(fontSize: 15.0, color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.white),
                      padding: EdgeInsets.fromLTRB(18, 10, 18, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            child: Align(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.attach_file_rounded,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                            onTap: selectFile,
                          ),
                          SizedBox(width: 50),
                          Flexible(
                            child: Text(
                              fileName,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      width: double.infinity,
                    ),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.white),
                      padding: EdgeInsets.fromLTRB(18, 10, 18, 10),
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Flexible(
                        child: task != null
                            ? buildUploadStatus(task!)
                            : Container(),
                      ),
                      width: double.infinity,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // if (_selectedOption == null) {
                        //   Fluttertoast.showToast(
                        //       msg: "Please select a catagory");
                        // } else {
                        //   await uploadFile();
                        //   Navigator.pop(context); //progressIndicator();
                        //   //buildUploadStatus(task!);

                        // }

                        // if (_formKey.currentState!.validate()) {
                        //   SongsModel songsModel = SongsModel(
                        //     songCategory: 'ଜାଗରଣ',
                        //     songAttribute: '',
                        //     songTitle: _titleController.text,
                        //     singerName: _singerNameController.text,
                        //     songId: '12345',
                        //     songText: _songLyrics.text,
                        //   );

                        //   final songDetails =
                        //       SongAPI().createNewSong(songsModel);
                        // }
                      },
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      //   floatingActionButton: FloatingActionButton(
      //     child: Text('Next'),
      // onPressed: (){
      //     Navigator.push(context, MaterialPageRoute(builder: (context) => AddSongLyrics()),);
      // },),
    );
  }
}
