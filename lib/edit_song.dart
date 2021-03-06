import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'models/usermodel.dart';

class EditSong extends StatefulWidget {
  EditSong({Key? key, required this.song, this.loggedInUser}) : super(key: key);

  final AppUser? loggedInUser;
  final Song song;

  @override
  State<EditSong> createState() => _Edit_SongState();
}

class _Edit_SongState extends State<EditSong> {
  Duration? autoDuration;
  String destination = '';
  String duration = '';
  File? file;
  var file1;
  final height = 100;
  double percentage = 0;

  AudioPlayer player = AudioPlayer();

  double? sizeInMb;
  String? songUrl;
  UploadTask? task;
  var val;

  //final _attributeController = TextEditingController();
  //final _formKey = GlobalKey<FormState>();

  final _lyricsController = TextEditingController();
  String? _selectedCategory;
  String? _selectedAttribute;
  final _singerNameController = TextEditingController();
  bool _songChangedByUser = false;
  final _titleController = TextEditingController();
  final _titleInEnglishController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print('${widget.loggedInUser?.name}');

    setState(() {
      _titleController.text = widget.song.songTitle ?? "";
      _titleInEnglishController.text = widget.song.songTitleInEnglish ?? "";
      _singerNameController.text = widget.song.singerName ?? "";
      _selectedAttribute = widget.song.songAttribute ?? "";
      _lyricsController.text = widget.song.songText ?? "";
      _selectedCategory = widget.song.songCategory ?? "";
    });
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
    destination = '$_selectedCategory/$fileName';

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

  Future<void> DialogForDelete() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Constant.lightblue,
          title: Center(child: const Text('Delete')),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Center(child: Text('Do you want to delete this song ?')),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: const Text(
                    'No',
                    style: TextStyle(color: Constant.orange),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text(
                    'Yes',
                    style: TextStyle(color: Constant.orange),
                  ),
                  onPressed: () async {
                    if (widget.song.songURL != null) {
                      await FirebaseStorage.instance
                          .refFromURL(widget.song.songURL!)
                          .delete();

                      await FirebaseFirestore.instance
                          .collection('songs')
                          .doc(widget.song.songId)
                          .delete();
                      await ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          elevation: 6,
                          behavior: SnackBarBehavior.floating,
                          content: const Text(
                            'Deleted SuccessFully',
                            style: TextStyle(color: Constant.white),
                          ),
                          backgroundColor: Constant.orange,
                        ),
                      );
                    }
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
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
    final fileName = widget.song.songURL ?? '????????? ??????????????????';
    return Container(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
          toolbarHeight: 90,
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
                      border: Border.all(color: Constant.orange),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          '???????????????',
                          style: TextStyle(color: Constant.white24),
                        ),
                        DropdownButtonHideUnderline(
                          // this widget hides the dropdown default underline
                          child: DropdownButton(
                            borderRadius: BorderRadius.circular(15),
                            style: TextStyle(color: Constant.white),
                            iconEnabledColor: Constant.orange,
                            value: _selectedCategory,
                            dropdownColor: Constant.orange,
                            onChanged: (value) {
                              setState(
                                () {
                                  _selectedCategory = value as String?;
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
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Constant.orange),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          '?????????',
                          style: TextStyle(color: Constant.white24),
                        ),
                        DropdownButtonHideUnderline(
                          // this widget hides the dropdown default underline
                          child: DropdownButton(
                            borderRadius: BorderRadius.circular(15),
                            style: TextStyle(color: Constant.white),
                            iconEnabledColor: Constant.orange,
                            value: _selectedAttribute,
                            dropdownColor: Constant.orange,
                            onChanged: (value) {
                              setState(
                                () {
                                  _selectedAttribute = value as String?;
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
                      labelStyle:
                          TextStyle(fontSize: 15.0, color: Constant.white24),
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
                      labelStyle:
                          TextStyle(fontSize: 15.0, color: Constant.white24),
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
                      labelStyle:
                          TextStyle(fontSize: 15.0, color: Constant.white24),
                    ),
                  ),
                  SizedBox(height: 15),
                  // TextFormField(
                  //   style: TextStyle(color: Constant.white),
                  //   keyboardType: TextInputType.name,
                  //   controller: _attributeController,
                  //   validator: (value) {
                  //     if (value!.isEmpty) {
                  //       return 'Please Enter  Attribute Name';
                  //     }
                  //     return null;
                  //   },
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
                  //     labelStyle:
                  //         TextStyle(fontSize: 15.0, color: Constant.white24),
                  //   ),
                  // ),
                  // SizedBox(height: 15),
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
                      labelStyle:
                          TextStyle(fontSize: 15.0, color: Constant.white24),
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Constant.orange, width: 1),
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
                            ),
                          ),
                          onTap: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              backgroundColor: Constant.lightblue,
                              title: Center(child: const Text('????????? ????????????????????????')),
                              content: const Text(
                                  '?????????????????? ????????? ???????????? ????????? ????????? ???????????? | ????????? ???????????? ????????????????????? ?????????????????????????????? ?????? ?'),
                              actions: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text(
                                        'Cancel',
                                        style:
                                            TextStyle(color: Constant.orange),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        selectFile();
                                        return Navigator.pop(
                                            context, 'Continue');
                                      },
                                      child: const Text(
                                        'Continue',
                                        style:
                                            TextStyle(color: Constant.orange),
                                      ),
                                    ),
                                  ],
                                )
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(primary: Constant.orange),
                        onPressed: () async {
                          if (_selectedCategory == null) {
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
                          } else if (_songChangedByUser && file1 == null) {
                            final snackBar = SnackBar(
                                backgroundColor: Constant.orange,
                                elevation: 6,
                                behavior: SnackBarBehavior.floating,
                                content:
                                    const Text('?????????????????? ???????????? ????????? ????????? ??????????????????'));
                            await ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else if (_songChangedByUser && sizeInMb! > 10) {
                            final snackBar = SnackBar(
                                backgroundColor: Constant.orange,
                                elevation: 6,
                                behavior: SnackBarBehavior.floating,
                                content: const Text(
                                    '???????????????????????? ?????? MB ??? ????????? ????????? ??????????????????'));
                            await ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else if (_songChangedByUser == true) {
                            await uploadFile();
                            print(
                                '********${widget.loggedInUser?.name}*********');
                            Navigator.pop(context);
                          }

                          Song songsModel = Song(
                            isEditable: true,
                            songCategory: _selectedCategory,
                            songAttribute: _selectedAttribute,
                            songTitle: _titleController.text,
                            songTitleInEnglish: _titleInEnglishController.text,
                            singerName: _singerNameController.text,
                            songText: _lyricsController.text,
                            songURL: _songChangedByUser
                                ? await songUrl
                                : widget.song.songURL,
                            songId: widget.song.songId,
                            songDuration: _songChangedByUser
                                ? autoDuration.toString().split('.')[0]
                                : widget.song.songDuration,
                            uploadedBy: widget.loggedInUser?.name,
                          );

                          await SongAPI().updateSong(songsModel);

                          await ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              elevation: 6,
                              behavior: SnackBarBehavior.floating,
                              content: const Text(
                                'Upadated SuccessFully',
                                style: TextStyle(color: Constant.white),
                              ),
                              backgroundColor: Constant.orange,
                            ),
                          );

                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Update',
                        ),
                      ),
                      ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(primary: Constant.orange),
                        onPressed: DialogForDelete,
                        child: Text(
                          'Delete',
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
