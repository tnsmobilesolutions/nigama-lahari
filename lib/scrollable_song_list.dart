import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/songs_model.dart';
import 'login/signIn.dart';
import 'song_detail.dart';

class ScrollableSongList extends StatefulWidget {
  ScrollableSongList({
    Key? key,
    this.songCategory,
    this.songs,
  }) : super(key: key);

  final String? songCategory;
  List<Song>? songs;

  @override
  _ScrollableSongListState createState() => _ScrollableSongListState();
}

class _ScrollableSongListState extends State<ScrollableSongList> {
  List<Song>? items, results;
  List<String>? songName;

  Future<void> showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: const Text('Sign Out')),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Center(child: Text('Do you want to sign out ?')),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Yes'),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignIn(),
                        ),
                        ((route) => false));
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
  void initState() {
    items = widget.songs;
    print(items!.length);
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      results = widget.songs;
    } else {
      results = widget.songs!
          .where((text) => text.songTitle!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(
      () {
        items = results;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: const BoxDecoration(
      //   gradient: LinearGradient(
      //     begin: Alignment.topLeft,
      //     end: Alignment.bottomRight,
      //     colors: [Colors.purple, Colors.teal],
      //   ),
      // ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text('${widget.songCategory}'),
          actions: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: GestureDetector(
                    onTap: showMyDialog,
                    child: Icon(Icons.logout_rounded),
                  ),
                ),
              ],
            )
          ],
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                height: 40,
                child: TextField(
                  onChanged: (value) => _runFilter(value),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black26,
                      contentPadding: EdgeInsets.all(0),
                      prefixIcon: Icon(Icons.search, color: Colors.green),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide.none),
                      hintStyle:
                          TextStyle(fontSize: 18, color: Colors.grey.shade500),
                      hintText: "ଗୀତ ଖୋଜନ୍ତୁ"),
                ),
              ),
              SizedBox(height: 30),
              Expanded(
                child: items!.isNotEmpty
                    ? ListView.builder(
                        itemCount: items?.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.songs![index].songTitle ?? "",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                  ),
                                  Text(
                                    widget.songs![index].singerName ?? "",
                                    style: TextStyle(
                                      color: Colors.green,
                                      //fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SongDetail(
                                    song: widget.songs![index],
                                    songList: widget.songs,
                                    index: index,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          '',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
