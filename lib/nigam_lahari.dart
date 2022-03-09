import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/login/signIn.dart';
import 'package:flutter_application_1/common_widgets/common_style.dart';
import 'package:flutter_application_1/scrollable_song_list.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'add_new_song.dart';
import 'search_functionality.dart/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NigamLahari extends StatefulWidget {
  NigamLahari({Key? key}) : super(key: key);

  @override
  _NigamLahariState createState() => _NigamLahariState();
}

final storage = FlutterSecureStorage();

final List<String> items = [
  'ଜଗାଅରେ ଗଗନ ଭୁବନ ପବନ',
  'ଉଠ ଉଠ ନିଶି ହେଲା ପରଭାତ',
  'ଅନାଅରେ ଅନାଅରେ ଅନାଅ',
  'ଘନ ଅନ୍ଧାରେ',
  'ନବ ରବି ଆସେ ଉଇଁ',
  'ବାଉଳା ! ଅଳସ ପହୁଡ଼ ତେଜ',
  'ନିଶି ହେଲା ଆସି ଅବସାନରେ',
];

final List<String> singer = [
  'ଅଭୟ କୁମାର ଜେନା',
  'ନବକିଶୋର ନାୟକ',
  'ପ୍ରେମାନନ୍ଦ ମିଶ୍ର',
  'ନଳିନୀକାନ୍ତ ନାୟକ',
  'ଗୌରୀଶଙ୍କର ପଣ୍ଡା',
  'ନିରାକାର ରାଉତ',
  'ଅତନୁ ସବ୍ୟସାଚୀ ଜେନା',
  'ରବି ମିଶ୍ର',
];

class _NigamLahariState extends State<NigamLahari> {
  // .then(
  //   (QuerySnapshot querySnapshot) {
  //     querySnapshot.docs.forEach(
  //       (doc) {
  //         print(doc["singerName"]);
  //       },
  //     );
  //   },
  // );

  @override
  void initState() {
    super.initState();
  }

  Future<void> getSongData() async {
    final songsRef = FirebaseFirestore.instance.collection('songs').get();
    print(songsRef);
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
                    await storage.delete(key: 'uid');
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
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text('ନିଗମ  ଲହରୀ'),
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
                  child: Image(
                    image: AssetImage('assets/image/search_icon.gif'),
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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 24),
                GestureDetector(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'ଜାଗରଣ',
                      style: CommonStyle.myStyle,
                    ),
                  ),
                  onTap: () {
                    //TODO  call firebase API to get the list of jagarana songs
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScrollableSongList(
                          listName: 'ପ୍ରତୀକ୍ଷା',
                          song: items,
                          singer: singer,
                        ),
                      ),
                    ); // 1st parameters : jagarana, 2nd parameter : list of jagarana songs from firebase
                  },
                ),
                SizedBox(height: 8),
                Divider(
                  thickness: 2,
                ),
                SizedBox(height: 24),
                GestureDetector(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'ପ୍ରତୀକ୍ଷା',
                        style: CommonStyle.myStyle,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScrollableSongList(
                            listName: 'ପ୍ରତୀକ୍ଷା',
                            song: items,
                            singer: singer,
                          ),
                        ),
                      );
                    }),
                SizedBox(height: 8),
                Divider(
                  thickness: 2,
                ),
                SizedBox(height: 24),
                GestureDetector(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'ଆବାହନ',
                        style: CommonStyle.myStyle,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScrollableSongList(
                            listName: 'ଆବାହନ',
                            song: items,
                            singer: singer,
                          ),
                        ),
                      );
                    }),
                SizedBox(height: 8),
                Divider(
                  thickness: 2,
                ),
                SizedBox(height: 24),
                GestureDetector(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'ଆରତୀ',
                        style: CommonStyle.myStyle,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScrollableSongList(
                            listName: 'ଆରତୀ',
                            song: items,
                            singer: singer,
                          ),
                        ),
                      );
                    }),
                SizedBox(height: 8),
                Divider(
                  thickness: 2,
                ),
                SizedBox(height: 24),
                GestureDetector(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'ବନ୍ଦନା',
                        style: CommonStyle.myStyle,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScrollableSongList(
                            listName: 'ବନ୍ଦନା',
                            song: items,
                            singer: singer,
                          ),
                        ),
                      );
                    }),
                SizedBox(height: 8),
                Divider(
                  thickness: 2,
                ),
                SizedBox(height: 24),
                GestureDetector(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'ପ୍ରାର୍ଥନା',
                        style: CommonStyle.myStyle,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScrollableSongList(
                            listName: 'ପ୍ରାର୍ଥନା',
                            song: items,
                            singer: singer,
                          ),
                        ),
                      );
                    }),
                SizedBox(height: 8),
                Divider(
                  thickness: 2,
                ),
                SizedBox(height: 24),
                GestureDetector(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'ବିଦାୟ ପ୍ରାର୍ଥନା',
                        style: CommonStyle.myStyle,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScrollableSongList(
                            listName: 'ବିଦାୟ ପ୍ରାର୍ଥନା',
                            song: items,
                            singer: singer,
                          ),
                        ),
                      );
                    }),
                SizedBox(height: 8),
                Divider(
                  thickness: 2,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
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
        child: Image(
          image: AssetImage('assets/image/add_song.gif'),
        ),
      ),
    );
  }
}
