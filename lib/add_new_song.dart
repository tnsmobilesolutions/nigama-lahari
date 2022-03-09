import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_application_1/models/songs_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as path;
import 'API/firebaseAPI.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:uuid/uuid.dart';
import 'API/song_api.dart';

class AddSong extends StatefulWidget {
  const AddSong({Key? key}) : super(key: key);

  @override
  _AddSongState createState() => _AddSongState();
}

class _AddSongState extends State<AddSong> {
  var val;

  final _titleController = TextEditingController();
  final _singerNameController = TextEditingController();
  final _attributeController = TextEditingController();
  final _lyricsController = TextEditingController();

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

  UploadTask? task;
  File? file;
  String? _selectedOption;
  final height = 100;
  String destination = '';
  double percentage = 0;
  // String? songUrl;
  String duration = '';
  double? sizeInMb;
  var file1;

  void initState() {
    super.initState();
  }

  // select file from device
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.audio,
    );

    file1 = result!.files.first;
    sizeInMb = file1.size / 1048576;

    final path = result.files.single.path!;
    setState(() => file = File(path));
  }

  //upload selected file to firebase storage
  Future<String?> uploadFile() async {
    if (file == null) {
      return '';
    } else {}
    final fileName = path.basename(file!.path);
    destination = '$_selectedOption/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});
    showMyDialog();

    if (task == null) return '';

    final snapshot = await task!.whenComplete(() {});
    final songUrl = await snapshot.ref.getDownloadURL();

    return songUrl;

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

            val = percentage * 100.toInt();
            print(val);
            return CircularPercentIndicator(
              animation: true,
              radius: 55,
              lineWidth: 15,
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

  Future<void> showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: val == 100.0
                ? Text('Uploaded Successfully')
                : Text('Uploading...'),
          ),
          content: buildUploadStatus(task!),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: val == 100.0 ? Text('Done') : Text(''),
                  onPressed: () {
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
    final fileName =
        file != null ? path.basename(file!.path) : 'No File Selected';

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
                          labelText: 'Title',
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
                          labelText: 'Singer',
                          hintStyle:
                              TextStyle(fontSize: 15.0, color: Colors.black),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _attributeController,
                      style: TextStyle(color: Colors.black),
                      autofocus: false,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15),
                          labelText: 'Attributes',
                          hintStyle:
                              TextStyle(fontSize: 15.0, color: Colors.black),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _lyricsController,
                      style: TextStyle(color: Colors.black),
                      autofocus: false,
                      maxLines: height ~/ 8,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(15),
                        labelText: 'Song Lyrics',
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
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        var url;
                        if (_selectedOption == null) {
                          Fluttertoast.showToast(
                              msg: "Please select a catagory");
                        } else if (file1 == null) {
                          Fluttertoast.showToast(
                              msg: "Select an audio file to upload");
                        } else if (sizeInMb! > 10) {
                          Fluttertoast.showToast(
                              msg: "Select an audio file of max size 10 MB");
                        } else {
                          url = await uploadFile();
                        }

                        if (_formKey.currentState!.validate()) {
                          SongsModel songsModel = SongsModel(
                            isEditable: true,
                            songCategory: _selectedOption,
                            songAttribute: _attributeController.text,
                            songTitle: _titleController.text,
                            singerName: _singerNameController.text,
                            songText: _lyricsController.text,
                            songURL: url,
                            songId: Uuid().v1(),
                            songDuration: double.tryParse(duration),
                          );
                          // print(songURL);
                          final songDetails =
                              SongAPI().createNewSong(songsModel);
                        }
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
