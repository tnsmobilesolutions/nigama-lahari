import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant.dart';
import 'package:flutter_application_1/models/songs_model.dart';
import 'login/signIn.dart';
import 'models/usermodel.dart';
import 'song_detail.dart';

class ScrollableSongList extends StatefulWidget {
  ScrollableSongList(
      {Key? key, this.songCategory, this.songs, this.loggedInUser})
      : super(key: key);

  final AppUser? loggedInUser;
  final String? songCategory;
  final List<Song>? songs;

  @override
  _ScrollableSongListState createState() => _ScrollableSongListState();
}

class _ScrollableSongListState extends State<ScrollableSongList> {
  @override
  void initState() {
    Constant.items = widget.songs;
    super.initState();
    print('${widget.loggedInUser?.name}');
    Constant.isDarkMode = Constant.brightness == Brightness.dark;
  }

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

  void _runFilter(String enteredKeyword) {
    var results;
    if (enteredKeyword.isEmpty) {
      results = widget.songs;
    } else {
      results = widget.songs!
          .where((text) =>
              (text.songTitle ?? "")
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              (text.songTitleInEnglish ?? "")
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(
      () {
        Constant.items = results;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(color: Theme.of(context).iconTheme.color),
          elevation: 0,
          centerTitle: true,
          title: Text('${widget.songCategory}'),
          // actions: [
          //   Row(
          //     children: [
          //       Padding(
          //         padding: EdgeInsets.only(right: 20),
          //         child: GestureDetector(
          //           onTap: showMyDialog,
          //           child: Icon(
          //             Icons.logout_rounded,
          //             color: Theme.of(context).iconTheme.color,
          //           ),
          //         ),
          //       ),
          //     ],
          //   )
          // ],
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
                      fillColor: Constant.lightblue,
                      // Constant.isDarkMode
                      //     ? Constant.lightblue
                      //     : Constant.purpleRed,
                      contentPadding: EdgeInsets.all(0),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide.none),
                      hintStyle:
                          TextStyle(fontSize: 18, color: Constant.white24),
                      hintText: "ଗୀତ ଖୋଜନ୍ତୁ"),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Constant.items!.isNotEmpty
                    ? ListView.builder(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        itemCount: Constant.items?.length ?? 0,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                textColor: Constant.white,
                                // Constant.isDarkMode
                                //     ? Constant.white
                                //     : Constant.black,
                                tileColor: Constant.isDarkMode
                                    ? ListTileTheme.of(context).tileColor
                                    : ListTileTheme.of(context).tileColor,
                                title: Text(
                                  Constant.items![index].songTitle ?? "",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                                ),
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      Constant.items![index].singerName ?? "",
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      Constant.items![index].songDuration ?? "",
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SongDetail(
                                    song: Constant.items![index],
                                    songList: widget.songs,
                                    index: index,
                                    loggedInUser: widget.loggedInUser,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          'କ୍ଷମା କରିବେ !  ଏହି ବିଭାଗରେ କୌଣସି ଗୀତ ନାହିଁ',
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
