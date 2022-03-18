import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/API/firebaseAPI.dart';
//import 'package:flutter_application_1/common_widgets/common_style.dart';
import 'package:flutter_application_1/models/songs_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:path/path.dart' as path;
import 'API/song_api.dart';
import 'login/common_widgets/common_style.dart';
import 'package:uuid/uuid.dart';

class EditSong extends StatefulWidget {
  EditSong({Key? key, required this.song}) : super(key: key);
  final Song song;
  @override
  State<EditSong> createState() => _Edit_SongState();
}

class _Edit_SongState extends State<EditSong> {
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

  final _catagoryController = TextEditingController();
  final _titleController = TextEditingController();
  final _singerNameController = TextEditingController();
  final _attributeController = TextEditingController();
  final _lyricsController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _catagoryController.text = widget.song.songCategory ?? "";
    _titleController.text = widget.song.songTitle ?? "";
    _singerNameController.text = widget.song.singerName ?? "";
    _attributeController.text = widget.song.songAttribute ?? "";
    _lyricsController.text = widget.song.songText ?? "";
    _selectedOption = widget.song.songCategory ?? "";
  }

  UploadTask? task;
  File? file;
  String? _selectedOption;
  final height = 100;
  String destination = '';
  double percentage = 0;
  String? songUrl;
  String duration = '';
  Duration? autoDuration;
  double? sizeInMb;
  var file1;
  var val;

  AudioPlayer player = AudioPlayer();

  // select file from device
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.audio,
    );
    print('****  $result  ****');
    if (result != null) {
      file1 = result.files.first;
      sizeInMb = file1.size / 1048576;
    } else {
      return;
    }

    //lenghOfAudio(file1);

    file1 = result.files.first;
    // print('++++  $file1  ++++');
    // print('----  ${file1.name}  ----');

    sizeInMb = file1.size / 1048576;

    final path = result.files.single.path!;
    setState(() => file = File(path));
  }

  //upload selected file to firebase storage
  Future uploadFile() async {
    if (file == null) {
      return;
    } else {}
    final fileName = path.basename(file!.path);
    destination = '$_selectedOption/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});
    showMyDialog();

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    songUrl = await snapshot.ref.getDownloadURL();
    // autoDuration = await player.setUrl(songUrl.toString());

    //print('****  $autoDuration  ****');
    //print('Download-Link: $songURL');
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

            val = {(percentage * 100).toInt()};
            print('value : $val');
            return CircularPercentIndicator(
              animation: true,
              radius: 55,
              lineWidth: 15,
              percent: percentage,
              progressColor: Colors.green,
              backgroundColor: Colors.green.shade200,
              circularStrokeCap: CircularStrokeCap.round,
              center: Text(
                '${(percentage * 100).toInt()}%',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            );
          } else {
            return Container();
          }
        },
      );
  Future<void> delete(String songURL) async {
    await FirebaseStorage.instance.ref(songURL).delete;
    // Rebuild the UI
    // setState(() {});
  }

  Future<void> showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: val == '100%'
                ? Text('Uploaded Successfully')
                : Text('Uploading...'),
          ),
          content: buildUploadStatus(task!),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: val == '100%' ? Text('Done') : Text('Wait Please'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? path.basename(file!.path) : 'ଚୟନ କରନ୍ତୁ';
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.purple, Colors.teal],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.song.songTitle ?? ""),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DropdownButton(
                    iconEnabledColor: Colors.teal,
                    hint: Text(
                      _catagoryController.text,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    value: _selectedOption,
                    dropdownColor: Colors.teal,
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
                  SizedBox(height: 15),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: _titleController,
                    // inputFormatters: [
                    //   FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]"))
                    // ],
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Name';
                        //
                        //} else if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                        //   return 'Please Enter Correct Name';
                      }
                      return null;
                    },
                    // style: TextStyle(height: 0.5),
                    decoration: CommonStyle.textFieldStyle(
                      labelTextStr: "Song Name",
                      hintTextStr: "Enter Song name",
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: _singerNameController,
                    // inputFormatters: [
                    //   FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]"))
                    // ],
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Singer Name';
                      }
                      //  else if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                      //   return 'Please Enter Correct Singer Name';
                      // }
                      return null;
                    },
                    // style: TextStyle(height: 0.5),
                    decoration: CommonStyle.textFieldStyle(
                      labelTextStr: "Singer Name",
                      hintTextStr: "Enter Singer name",
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: _attributeController,
                    // inputFormatters: [
                    //   FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]"))
                    // ],
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter  Attribute Name';
                      }
                      // else if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                      //   return 'Please Enter Correct Attribute Name';
                      // }
                      return null;
                    },
                    // style: TextStyle(height: 0.5),
                    decoration: CommonStyle.textFieldStyle(
                      labelTextStr: "Song Attribute Name",
                      hintTextStr: "Enter Song Attribute name",
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _lyricsController,
                    maxLines: height ~/ 8,
                    // inputFormatters: [
                    //   FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]"))
                    // ],
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Lyrics';
                      }
                      //  else if (!RegExp(r'^[0-9 a-z A-Z]+$').hasMatch(value)) {
                      //   return 'Please Enter Correct Lyrics';
                      // }
                      return null;
                    },
                    // style: TextStyle(height: 0.5),
                    decoration: CommonStyle.textFieldStyle(
                      labelTextStr: "Song Lyrics",
                      hintTextStr: "Enter Song Lyrics",
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.transparent),
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
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      if (_selectedOption == null) {
                        Fluttertoast.showToast(msg: "ଦୟାକରି ବିଭାଗ ଚୟନ କରନ୍ତୁ");
                      } else if (_titleController.text.isEmpty) {
                        Fluttertoast.showToast(msg: "ଦୟାକରି ଗୀତ ନାମ ଲେଖନ୍ତୁ");
                      } else if (_lyricsController.text.isEmpty) {
                        Fluttertoast.showToast(msg: "ଦୟାକରି ଗୀତର ଲେଖା ଦିଅନ୍ତୁ");
                      } else if (file1 == null) {
                        Fluttertoast.showToast(
                            msg: "ଅପଲୋଡ଼ ପାଇଁ ଗୀତ ଚୟନ କରନ୍ତୁ");
                      } else if (sizeInMb! > 10) {
                        Fluttertoast.showToast(
                            msg: "ସର୍ବାଧିକ ୧୦ MB ର ଗୀତ ଚୟନ କରନ୍ତୁ");
                      } else {
                        // await delete(songUrl.toString());
                        await uploadFile();
                      }
                      // Navigator.pop(context);
                      // await Fluttertoast.showToast(
                      //     msg: 'Upload Successfully');
                      // Navigator.pop(context);

                      if (_formKey != null &&
                          _formKey.currentState != null &&
                          _formKey.currentState!.validate()) {
                        Song songsModel = Song(
                            isEditable: true,
                            songCategory: _selectedOption,
                            songAttribute: _attributeController.text,
                            songTitle: _titleController.text,
                            singerName: _singerNameController.text,
                            songText: _lyricsController.text,
                            songURL: songUrl,
                            songId: Uuid().v1(),
                            songDuration: autoDuration.toString()
                            //double.tryParse(autoDuration.toString()),
                            );

                        final songDetails = SongAPI().updateSong(songsModel);
                      }
                    },
                    child: Text(
                      'Update',
                    ),
                  ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     if (_formKey.currentState != null &&
                  //         _formKey.currentState!.validate()) {
                  //       Song songsModel = Song(
                  //         isEditable: true,
                  //         songCategory: _selectedOption,
                  //         songAttribute: _attributeController.text,
                  //         songTitle: _titleController.text,
                  //         singerName: _singerNameController.text,
                  //         songText: _lyricsController.text,
                  //       );

                  //       final SongDetails = SongAPI().updateSong(songsModel);
                  //       print(songsModel);
                  //       print(SongDetails);

                  //       ScaffoldMessenger.of(context).showSnackBar(
                  //         const SnackBar(content: Text('Data Updated.')),
                  //       );

                  //       Navigator.pop(context, songsModel);
                  //     }
                  //   },
                  //   child: Text('Update'),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
