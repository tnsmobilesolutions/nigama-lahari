import 'dart:io';
import 'package:just_audio/just_audio.dart';

import 'package:file_picker/file_picker.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/API/firebaseAPI.dart';

import 'package:flutter_application_1/models/songs_model.dart';

import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:path/path.dart' as path;
import 'API/song_api.dart';
import 'constant.dart';

class EditSong extends StatefulWidget {
  EditSong({Key? key, required this.song}) : super(key: key);
  final Song song;
  @override
  State<EditSong> createState() => _Edit_SongState();
}

class _Edit_SongState extends State<EditSong> {
  //final _formKey = GlobalKey<FormState>();
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
  final _titleInEnglishController = TextEditingController();
  final _singerNameController = TextEditingController();
  final _attributeController = TextEditingController();
  final _lyricsController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _catagoryController.text = widget.song.songCategory ?? "";
    _titleController.text = widget.song.songTitle ?? "";
    _titleInEnglishController.text = widget.song.songTitleInEnglish ?? "";
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
  bool _songChangedByUser = false;
  //var songDetails = '';

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
      setState(
        () {
          _songChangedByUser = true;
        },
      );
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
    autoDuration =
        await player.setUrl(songUrl.toString()); // autodetects audio duration
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
              progressColor: Constant.blue,
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
            child: Text('Uploading...'),
          ),
          content: buildUploadStatus(task!),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final fileName = widget.song.songURL ?? 'ଚୟନ କରନ୍ତୁ';
    return Container(
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(color: Theme.of(context).iconTheme.color),
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
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Constant.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'ବିଭାଗ',
                          style: TextStyle(color: Constant.white),
                        ),
                        DropdownButton(
                          style: TextStyle(color: Constant.white),
                          iconEnabledColor: Constant.orange,
                          hint: Text(
                            _catagoryController.text,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                          value: _selectedOption,
                          dropdownColor: Constant.lightblue,
                          onChanged: (value) {
                            setState(
                              () {
                                _selectedOption = value as String?;
                                //print(_selectedOption.toString());
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
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    style: TextStyle(color: Constant.white),
                    keyboardType: TextInputType.name,
                    controller: _titleController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15),
                      labelText: 'ନାମ',
                      labelStyle:
                          TextStyle(fontSize: 15.0, color: Constant.white12),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Constant.white)),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    style: TextStyle(color: Constant.white),
                    keyboardType: TextInputType.name,
                    controller: _titleInEnglishController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Song Name in English';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15),
                      labelText: 'ଗୀତର ନାମ ଇଂରାଜୀରେ',
                      labelStyle:
                          TextStyle(fontSize: 15.0, color: Constant.white12),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Constant.white)),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    style: TextStyle(color: Constant.white),
                    keyboardType: TextInputType.name,
                    controller: _singerNameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Singer Name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15),
                      labelText: 'ଗାୟକ',
                      labelStyle:
                          TextStyle(fontSize: 15.0, color: Constant.white12),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Constant.white)),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    style: TextStyle(color: Constant.white),
                    keyboardType: TextInputType.name,
                    controller: _attributeController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter  Attribute Name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15),
                      labelText: 'ଭାବ',
                      labelStyle:
                          TextStyle(fontSize: 15.0, color: Constant.white12),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Constant.white)),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    style: TextStyle(color: Constant.white),
                    keyboardType: TextInputType.text,
                    controller: _lyricsController,
                    maxLines: height ~/ 8,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Lyrics';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15),
                      labelText: 'ଗୀତ ଲେଖା',
                      labelStyle:
                          TextStyle(fontSize: 15.0, color: Constant.white12),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Constant.white)),
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          child: Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.attach_file_rounded,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Replace Song Music'),
                              content: const Text(
                                  'This would replace the existing music for this song. Are you sure to continue ?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    selectFile();
                                    return Navigator.pop(context, 'Continue');
                                  },
                                  child: const Text('Continue'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            fileName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    width: double.infinity,
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Constant.orange),
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
                            content: const Text('ଦୟାକରି ଗୀତର ଲେଖା ଦିଅନ୍ତୁ'));
                        await ScaffoldMessenger.of(context)
                            .showSnackBar(snackBar);
                      } else if (_songChangedByUser && file1 == null) {
                        final snackBar = SnackBar(
                            content: const Text('ଅପଲୋଡ଼ ପାଇଁ ଗୀତ ଚୟନ କରନ୍ତୁ'));
                        await ScaffoldMessenger.of(context)
                            .showSnackBar(snackBar);
                      } else if (_songChangedByUser && sizeInMb! > 10) {
                        final snackBar = SnackBar(
                            content:
                                const Text('ସର୍ବାଧିକ ୧୦ MB ର ଗୀତ ଚୟନ କରନ୍ତୁ'));
                        await ScaffoldMessenger.of(context)
                            .showSnackBar(snackBar);
                      } else if (_songChangedByUser == true) {
                        await uploadFile();
                        Navigator.pop(context);
                      }

                      Song songsModel = Song(
                        isEditable: true,
                        songCategory: _selectedOption,
                        songAttribute: _attributeController.text,
                        songTitle: _titleController.text,
                        songTitleInEnglish: _titleInEnglishController.text,
                        singerName: _singerNameController.text,
                        songText: _lyricsController.text,
                        songURL:
                            _songChangedByUser ? songUrl : widget.song.songURL,
                        songId: widget.song.songId,
                        songDuration: _songChangedByUser
                            ? autoDuration.toString().split('.')[0]
                            : widget.song.songDuration,
                      );

                      await SongAPI().updateSong(songsModel);
                      final snackBar =
                          SnackBar(content: const Text('Upadate SuccessFully'));
                      await ScaffoldMessenger.of(context)
                          .showSnackBar(snackBar);

                      Navigator.pop(context);
                    },
                    child: Text(
                      'Update',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
