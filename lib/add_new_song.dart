import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'API/firebaseAPI.dart';

class AddSong extends StatefulWidget {
  const AddSong({Key? key}) : super(key: key);

  @override
  _AddSongState createState() => _AddSongState();
}

class _AddSongState extends State<AddSong> {
  final _titleController = TextEditingController();
  final _singerController = TextEditingController();
  final _lyricsController = TextEditingController();

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
  String? value;
  final height = 100;
  Duration duration = new Duration();
  var time;
  AudioPlayer? audioPlayer = AudioPlayer();
  String destination = '';
  var newPath;

  //audioPlayer.setUrl(audioFilePath, isLocal:true);
  //var selectedSongDuration;

  void initState() {
    super.initState();
    // audioPlayer?.onDurationChanged.listen(
    //   (Duration d) {
    //     //print('Max duration: $d');
    //     setState(() => duration = d);
    //   },
    // );
  }

  // select file from device
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path!;
    time = audioPlayer?.onDurationChanged.listen(
      (Duration path) {
        //print('Max duration: $d');
        setState(() => duration = path);
      },
    );
    print(time);
    setState(() => file = File(path));
  }

  //upload selected file to firebase storage
  Future uploadFile() async {
    if (file == null) {
      return;
    }
    final fileName = basename(file!.path);
    destination = '$_selectedOption/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final songUrl = await snapshot.ref.getDownloadURL();

    //print('Download-Link: $songUrl');
  }

  //upload status
  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);
            print(percentage);
            return Text(
              percentage == 100 ? 'Uploaded Successfully' : '$percentage %',
              //'$percentage %',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : '';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Song'),
      ),
      body: SingleChildScrollView(
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
                        // validator: (value) =>
                        //     value == null ? 'Please select a catagory' : null,
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
                  TextField(
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
                    style: TextStyle(color: Colors.black),
                    controller: _singerController,
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
                    style: TextStyle(color: Colors.black),
                    controller: _lyricsController,
                    autofocus: false,
                    maxLines: height ~/ 6,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15),
                      hintText: 'Song Lyrics',
                      hintStyle: TextStyle(fontSize: 15.0, color: Colors.black),
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
                      mainAxisAlignment: MainAxisAlignment.start,
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
                        SizedBox(
                          width: 40,
                        ),
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
                  SizedBox(height: 20),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.white),
                    padding: EdgeInsets.fromLTRB(18, 10, 18, 10),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.timelapse,
                          size: 30,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        // Flexible(
                        //   child: Text(
                        //     file != null ? time.toString().split('.')[0] : '',
                        //     style: TextStyle(
                        //       fontSize: 16,
                        //       fontWeight: FontWeight.w500,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.cloud_upload_outlined,
                                  size: 30,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                // Text(
                                //   'Upload',
                                //   style: TextStyle(
                                //     fontSize: 18,
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          //onTap: uploadFile
                          onTap: () {
                            _selectedOption == null
                                ? Fluttertoast.showToast(
                                    msg: "Please select a catagory")
                                : uploadFile();
                          },
                        ),

                        task != null ? buildUploadStatus(task!) : Container(),
                        //widget.percentage == 100 ? print('Uploaded Successfully') : null;
                        // Fluttertoast.showToast(msg: "Login Successful")
                      ],
                    ),
                    width: double.infinity,
                  ),
                ],
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
