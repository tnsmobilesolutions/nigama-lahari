import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant.dart';
import 'package:flutter_application_1/favorite_song_list.dart';
import 'package:flutter_application_1/login/signIn.dart';
import 'package:flutter_application_1/scrollable_song_list.dart';
import 'package:flutter_application_1/search_functionality/search.dart';
import 'API/searchSongAPI.dart';
import 'API/userAPI.dart';
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
  void initState() {
    super.initState();
    setState(() {
      if (widget.loggedInUser?.allowEdit == true) {
        Constant.addVisible = !Constant.addVisible;
      }
    });
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
    final textScale = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
        toolbarHeight: 90,
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
        actions: <Widget>[
          //SignOut implemented
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: GestureDetector(
                  child: Image(
                    image: AssetImage('assets/image/favoritelist 2.png'),
                    height: 20,
                    width: 20,
                  ),
                  onTap: () async {
                    List<dynamic>? songIds = await userAPI()
                        .getFavoriteSongIdsFromUid(widget.loggedInUser?.uid);

                    final allFavoriteSongs =
                        await SearchSongAPI().getAllSongsByIds(songIds);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FavoriteSongList(
                          songCategory: 'ଆପଣଙ୍କ ପସନ୍ଦର ଗୀତ',
                          songs: allFavoriteSongs,
                          loggedInUser: widget.loggedInUser,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: GestureDetector(
                  onTap: showMyDialog,
                  child: Icon(
                    Icons.logout_rounded,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
            ],
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
                    onRefresh: getDataThroughRefresh,
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).iconTheme.color,
                              borderRadius: BorderRadius.circular(40)),
                          margin: EdgeInsets.only(
                              left: 70, right: 70, top: 5, bottom: 5),
                          child: ListTile(
                            textColor: Constant.white,
                            title: Center(
                              child: Text(
                                // gets all available catagories dynamically
                                snapshot.data![index],
                                style: TextStyle(
                                    color: Constant.white,
                                    fontSize: 30 * textScale),
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
      floatingActionButton: Visibility(
        visible: Constant.addVisible,
        child: FloatingActionButton(
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
      ),
    );
  }
}
