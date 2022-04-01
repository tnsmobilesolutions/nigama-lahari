import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/constant.dart';

import 'package:flutter_application_1/login/signIn.dart';
import 'package:flutter_application_1/scrollable_song_list.dart';
import 'package:flutter_application_1/search_functionality/search.dart';

import 'API/searchSongAPI.dart';
import 'add_new_song.dart';
import 'models/songs_model.dart';
import 'models/usermodel.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, required this.loggedInUser}) : super(key: key);

  final AppUser? loggedInUser;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDarkMode = false;

  void initState() {
    super.initState();
    print('${widget.loggedInUser?.name}');

    var brightness = SchedulerBinding.instance!.window.platformBrightness;
    isDarkMode = brightness == Brightness.dark;
  }

//pull to refresh
  Future<void> getDataThroughRefresh() async {
    CollectionReference songs = FirebaseFirestore.instance.collection('songs');
    songs.get().then(
      (querySnapshot) {
        List<String>? lstCategories = [];
        querySnapshot.docs.forEach(
          (element) {
            final songMap = element.data() as Map<String, dynamic>;
            //print(songMap);
            final song = Song.fromMap(songMap);
            //print(song);
            if (song.songCategory != null &&
                !lstCategories.contains(song.songCategory)) {
              lstCategories.add(song.songCategory ?? "No Category");
              //print(lstCategories);
            }
          },
        );
        setState(() {
          lstCategories;
        });
      },
    );

    return Future.delayed(Duration(seconds: 3));
  }

  //Alert Dialog for signout
  Future<void> showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Constant.lightblue,
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
  Widget build(BuildContext context) {
    print('home screen loading...');

    final textScale = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Search(),
              ),
            );
          },
          child: Icon(
            Icons.search_rounded,
            color: Theme.of(context).iconTheme.color,
            size: 30,
          ),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'ନିଗମ ଲହରୀ',
        ),
        actions: [
          //SignOut implemented
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: showMyDialog,
              child: Icon(
                Icons.logout_rounded,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: FutureBuilder<List<String>?>(
          future: SearchSongAPI().getAllCategories(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else
                  return RefreshIndicator(
                    color: Theme.of(context).iconTheme.color,
                    backgroundColor: Constant.lightblue,
                    onRefresh: () => getDataThroughRefresh(),
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.only(
                              left: 40, top: 5, right: 40, bottom: 5),
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? ListTileTheme.of(context).tileColor
                                : ListTileTheme.of(context).tileColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: Center(
                              child: Text(
                                snapshot.data![
                                    index], // gets all available catagories dynamically
                                style: TextStyle(fontSize: 30 * textScale),
                              ),
                            ),
                            onTap: () async {
                              final allSongsByCategory = await SearchSongAPI()
                                  .getAllSongsInCategory(snapshot.data![index]);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ScrollableSongList(
                                    songCategory: snapshot.data![index],
                                    songs: allSongsByCategory,
                                    loggedInUser: widget.loggedInUser,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );

              default:
                return Text('Unhandle State');
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Constant.orange,
        elevation: 0,
        highlightElevation: 0,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddSong(
                loggedInUser: widget.loggedInUser,
              ),
            ),
          );
        },
        child: Icon(
          Icons.add,
          size: 30,
        ),
      ),
    );
  }
}
