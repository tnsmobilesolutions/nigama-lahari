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
  Duration? autoDuration;
  String destination = '';
  File? file;
  var file1;
  final height = 100;
  double percentage = 0;
  AudioPlayer player = AudioPlayer();
  double? sizeInMb;
  String? songUrl;
  UploadTask? task;
  var val;

  final _formKey = GlobalKey<FormState>();
  final _lyricsController = TextEditingController();
  String? _selectedOption;
  String? _selectedAttribute;
  final _singerNameController = TextEditingController();
  //final FlutterFFprobe _flutterFFprobe = new FlutterFFprobe();

  final _titleController = TextEditingController();

  final _titleEnglishController = TextEditingController();

  void initState() {
    super.initState();
    print('${widget.loggedInUser?.name}');
  }

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
    final fileName = file != null ? path.basename(file!.path) : '????????? ??????????????????';

    return Container(
      child: Scaffold(
        appBar: AppBar(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
          toolbarHeight: 90,
          leading: BackButton(color: Theme.of(context).iconTheme.color),
          //elevation: 0,
          centerTitle: true,
          title: Text('????????? ?????????'),
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
                            borderRadius: BorderRadius.circular(15),
                            style: TextStyle(color: Constant.white),
                            iconEnabledColor: Theme.of(context).iconTheme.color,
                            hint: Text(
                              '???????????????',
                              style: TextStyle(
                                color: Constant.white24,
                                fontSize: 15,
                              ),
                            ),
                            value: _selectedOption,
                            dropdownColor: Constant.orange,
                            onChanged: (value) {
                              setState(
                                () {
                                  _selectedOption = value as String?;
                                  print(_selectedOption.toString());
                                },
                              );
                            },
                            items: Constant.catagory.map(
                              (val) {
                                return DropdownMenuItem(
                                  child: new Text(val),
                                  value: val,
                                );
                              },
                            ).toList(),
                          ),
                          DropdownButton(
                            borderRadius: BorderRadius.circular(15),
                            style: TextStyle(color: Constant.white),
                            iconEnabledColor: Theme.of(context).iconTheme.color,
                            hint: Text(
                              '?????????',
                              style: TextStyle(
                                color: Constant.white24,
                                fontSize: 15,
                              ),
                            ),
                            value: _selectedAttribute,
                            dropdownColor: Constant.orange,
                            onChanged: (value) {
                              setState(
                                () {
                                  _selectedAttribute = value as String?;
                                  print(_selectedAttribute.toString());
                                },
                              );
                            },
                            items: Constant.attribute.map(
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
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Constant.orange,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Constant.orange),
                          ),
                          contentPadding: const EdgeInsets.all(15),
                          labelText: '?????????',
                          labelStyle: TextStyle(
                              fontSize: 15.0, color: Constant.white24),
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
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Constant.orange,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Constant.orange),
                          ),
                          contentPadding: const EdgeInsets.all(15),
                          labelText: '???????????? ????????? ????????????????????????',
                          labelStyle: TextStyle(
                              fontSize: 15.0, color: Constant.white24),
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
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Constant.orange,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Constant.orange),
                          ),
                          contentPadding: const EdgeInsets.all(15),
                          labelText: '????????????',
                          labelStyle: TextStyle(
                              fontSize: 15.0, color: Constant.white24),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // TextFormField(
                      //   controller: _attributeController,
                      //   style: TextStyle(color: Constant.white),
                      //   autofocus: false,
                      //   keyboardType: TextInputType.name,
                      //   textInputAction: TextInputAction.next,
                      //   decoration: InputDecoration(
                      //     focusedBorder: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(15.0),
                      //       borderSide: BorderSide(
                      //         color: Constant.orange,
                      //       ),
                      //     ),
                      //     enabledBorder: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(15),
                      //       borderSide: BorderSide(color: Constant.orange),
                      //     ),
                      //     contentPadding: const EdgeInsets.all(15),
                      //     labelText: '?????????',
                      //     labelStyle: TextStyle(
                      //         fontSize: 15.0, color: Constant.white24),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      TextFormField(
                        controller: _lyricsController,
                        style: TextStyle(color: Constant.white),
                        autofocus: false,
                        maxLines: height ~/ 8,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Constant.orange,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Constant.orange),
                          ),
                          contentPadding: const EdgeInsets.all(15),
                          labelText: '????????? ????????????',
                          labelStyle: TextStyle(
                              fontSize: 15.0, color: Constant.white24),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Constant.orange, width: 1),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
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
                                style: TextStyle(
                                    color: Constant.white24,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
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
                                backgroundColor: Constant.orange,
                                elevation: 6,
                                behavior: SnackBarBehavior.floating,
                                content: const Text('?????????????????? ??????????????? ????????? ??????????????????'));
                            await ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else if (_titleController.text.isEmpty) {
                            final snackBar = SnackBar(
                                backgroundColor: Constant.orange,
                                elevation: 6,
                                behavior: SnackBarBehavior.floating,
                                content: const Text('?????????????????? ????????? ????????? ?????????????????????'));
                            await ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else if (_lyricsController.text.isEmpty) {
                            final snackBar = SnackBar(
                                backgroundColor: Constant.orange,
                                elevation: 6,
                                behavior: SnackBarBehavior.floating,
                                content:
                                    const Text('?????????????????? ???????????? ???????????? ?????????????????????'));
                            await ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else if (file1 == null) {
                            final snackBar = SnackBar(
                                backgroundColor: Constant.orange,
                                elevation: 6,
                                behavior: SnackBarBehavior.floating,
                                content:
                                    const Text('?????????????????? ???????????? ????????? ????????? ??????????????????'));
                            await ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else if (sizeInMb! > 10) {
                            final snackBar = SnackBar(
                                backgroundColor: Constant.orange,
                                elevation: 6,
                                behavior: SnackBarBehavior.floating,
                                content: const Text(
                                    '???????????????????????? ?????? MB ??? ????????? ????????? ??????????????????'));
                            await ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            await uploadFile();
                            if (_formKey.currentState!.validate()) {
                              Song songsModel = Song(
                                isEditable: true,
                                songCategory: _selectedOption,
                                songAttribute: _selectedAttribute,
                                songTitle: _titleController.text,
                                songTitleInEnglish:
                                    _titleEnglishController.text,
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
                            // print(
                            //     '********${widget.loggedInUser?.name}*********');
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
                        },
                        child: Text(
                          '?????????????????? ??????????????????',
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
