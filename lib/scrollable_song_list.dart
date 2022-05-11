import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant.dart';
import 'package:flutter_application_1/models/songs_model.dart';
import 'package:provider/provider.dart';
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

  bool _folded = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
          automaticallyImplyLeading: false,
          toolbarHeight: 90,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  // SizedBox(
                  //   width: 135,
                  // ),
                  Text(
                    '${widget.songCategory}',
                    style: TextStyle(fontSize: 20),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: _folded ? 56 : 200,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: Constant
                          .lightblue_2, //Theme.of(context).iconTheme.color,
                      boxShadow: kElevationToShadow[4],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 16),
                            child: !_folded
                                ? TextField(
                                    onChanged: (value) => _runFilter(value),
                                    decoration: InputDecoration(
                                      hintText: 'Search',
                                      hintStyle: TextStyle(color: Colors.white),
                                      border: InputBorder.none,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                        Material(
                          type: MaterialType.transparency,
                          child: InkWell(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(_folded ? 32 : 0),
                              topRight: const Radius.circular(32),
                              bottomLeft: Radius.circular(_folded ? 32 : 0),
                              bottomRight: const Radius.circular(32),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Icon(
                                _folded ? Icons.search : Icons.close,
                                color: Theme.of(context).iconTheme.color,
                              ),
                            ),
                            onTap: () {
                              setState(
                                () {
                                  _folded = !_folded;
                                },
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          //leading: BackButton(color: Theme.of(context).iconTheme.color),
          elevation: 0,
        ),
        body: Consumer<AppUser>(
          builder: (context, provider, child) {
            return SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                                          Constant.items![index].singerName ??
                                              "",
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          Constant.items![index].songDuration ??
                                              "",
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
            );
          },
        ));
  }
}
