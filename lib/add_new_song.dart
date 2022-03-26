import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_application_1/constant.dart';
import 'package:flutter_application_1/models/songs_model.dart';

import 'package:path/path.dart' as path;
import 'API/firebaseAPI.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:uuid/uuid.dart';
import 'API/song_api.dart';
import 'package:just_audio/just_audio.dart';

import 'models/usermodel.dart';

class AddSong extends StatefulWidget {
  const AddSong({Key? key, required this.loggedInUser}) : super(key: key);
  final AppUser? loggedInUser;
  @override
  _AddSongState createState() => _AddSongState();
}

class _AddSongState extends State<AddSong> {
  var val;

  //final FlutterFFprobe _flutterFFprobe = new FlutterFFprobe();

  final _titleController = TextEditingController();
  final _titleEnglishController = TextEditingController();
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
  String? songUrl;
  Duration? autoDuration;
  double? sizeInMb;
  var file1;

  void initState() {
    super.initState();
    print('${widget.loggedInUser?.name}');
  }

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

    file1 = result.files.first;

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

    // autodetects audio duration
    autoDuration = await player.setUrl(songUrl.toString());
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
              progressColor: Theme.of(context).primaryColor,
              backgroundColor: Constant.lightblue,
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

  Future<void> showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text('Uploading...'),
          ),
          content: buildUploadStatus(task!),
          actions: <Widget>[Center(child: Text('Please Wait...'))],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? path.basename(file!.path) : 'ଚୟନ କରନ୍ତୁ';

    return Container(
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(color: Theme.of(context).iconTheme.color),
          elevation: 0,
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
                            style: TextStyle(color: Constant.white),
                            iconEnabledColor: Theme.of(context).iconTheme.color,
                            hint: Text(
                              'ବିଭାଗ',
                              style: TextStyle(
                                color: Colors.white24,
                                fontSize: 15,
                              ),
                            ),
                            value: _selectedOption,
                            dropdownColor: Constant.lightblue,
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
                        style: TextStyle(color: Constant.white),
                        controller: _titleController,
                        autofocus: false,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15),
                          labelText: 'ନାମ',
                          labelStyle: TextStyle(
                              fontSize: 15.0, color: Constant.white12),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Constant.white)),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        style: TextStyle(color: Constant.white),
                        controller: _titleEnglishController,
                        autofocus: false,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15),
                          labelText: 'ଗୀତର ନାମ ଇଂରାଜୀରେ',
                          labelStyle: TextStyle(
                              fontSize: 15.0, color: Constant.white12),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Constant.white)),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _singerNameController,
                        style: TextStyle(color: Constant.white),
                        autofocus: false,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15),
                          labelText: 'ଗାୟକ',
                          labelStyle: TextStyle(
                              fontSize: 15.0, color: Constant.white12),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Constant.white)),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _attributeController,
                        style: TextStyle(color: Constant.white),
                        autofocus: false,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15),
                          labelText: 'ଭାବ',
                          labelStyle: TextStyle(
                              fontSize: 15.0, color: Constant.white12),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Constant.white)),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _lyricsController,
                        style: TextStyle(color: Constant.white),
                        autofocus: false,
                        maxLines: height ~/ 8,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15),
                          labelText: 'ଗୀତ ଲେଖା',
                          labelStyle: TextStyle(
                              fontSize: 15.0, color: Constant.white12),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Constant.white)),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
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
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                              onTap: selectFile,
                            ),
                            SizedBox(width: 50),
                            Flexible(
                              child: Text(
                                fileName,
                                // style: TextStyle(color: Constant.white,
                                //     fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        width: double.infinity,
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(primary: Constant.orange),
                        onPressed: () async {
                          if (_selectedOption == null) {
                            final snackBar = SnackBar(
                                content: const Text('ଦୟାକରି ବିଭାଗ ଚୟନ କରନ୍ତୁ'));
                            await ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else if (_titleController.text.isEmpty) {
                            final snackBar = SnackBar(
                                content: const Text('ଦୟାକରି ଗୀତ ନାମ ଲେଖନ୍ତୁ'));
                            await ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else if (_lyricsController.text.isEmpty) {
                            final snackBar = SnackBar(
                                content:
                                    const Text('ଦୟାକରି ଗୀତର ଲେଖା ଦିଅନ୍ତୁ'));
                            await ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else if (file1 == null) {
                            final snackBar = SnackBar(
                                content:
                                    const Text('ଅପଲୋଡ଼ ପାଇଁ ଗୀତ ଚୟନ କରନ୍ତୁ'));
                            await ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else if (sizeInMb! > 10) {
                            final snackBar = SnackBar(
                                content: const Text(
                                    'ସର୍ବାଧିକ ୧୦ MB ର ଗୀତ ଚୟନ କରନ୍ତୁ'));
                            await ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            await uploadFile();
                            print(
                                '********${widget.loggedInUser?.name}*********');
                            await ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                elevation: 6,
                                behavior: SnackBarBehavior.floating,
                                content: const Text(
                                  'Uploaded SuccessFully',
                                  style: TextStyle(color: Constant.white),
                                ),
                                backgroundColor: Constant.orange,
                              ),
                            );

                            Navigator.pop(context);
                            Navigator.pop(context);
                          }

                          if (_formKey.currentState!.validate()) {
                            Song songsModel = Song(
                              isEditable: true,
                              songCategory: _selectedOption,
                              songAttribute: _attributeController.text,
                              songTitle: _titleController.text,
                              songTitleInEnglish: _titleEnglishController.text,
                              singerName: _singerNameController.text,
                              songText: _lyricsController.text,
                              songURL: songUrl,
                              songId: Uuid().v1(),
                              songDuration:
                                  autoDuration.toString().split('.')[0],
                              uploadedBy: widget.loggedInUser?.name,
                            );

                            SongAPI().createNewSong(songsModel);
                          }
                        },
                        child: Text(
                          'ଅପଲୋଡ଼ କରନ୍ତୁ',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
