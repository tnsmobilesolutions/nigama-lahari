import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_application_1/common_widgets/common_style.dart';
import 'package:flutter_application_1/login/signIn.dart';
import 'package:flutter_application_1/scrollable_song_list.dart';
import 'package:flutter_application_1/search_functionality/search.dart';

import 'API/searchSongAPI.dart';
import 'add_new_song.dart';
import 'login/common_widgets/common_style.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void initState() {
    super.initState();
  }

  //Alert Dialog for signout
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
  Widget build(BuildContext context) {
    print('home screen loading...');
    // final categories = DataStore().allCategories;
    // print(categories?.length);
    return Container(
      // decoration: const BoxDecoration(
      //   gradient: LinearGradient(
      //     begin: Alignment.topLeft,
      //     end: Alignment.bottomRight,
      //     colors: [Colors.purple, Colors.teal],
      //   ),
      // ),
      child: Scaffold(
        // backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          //backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            'ନିଗମ  ଲହରୀ',
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: GestureDetector(
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
                      size: 30,
                    ),
                  ),
                ),

                //SignOut implemented
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
        body: FutureBuilder<List<String>?>(
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
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Center(
                          child: Text(
                            snapshot.data![
                                index], // gets all available catagories dynamically
                            style: CommonStyle.myStyle,
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
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );

              default:
                return Text('Unhandle State');
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          // backgroundColor: Colors.transparent,
          elevation: 0,
          highlightElevation: 0,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddSong(),
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
