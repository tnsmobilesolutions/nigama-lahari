import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/login/signIn.dart';
import 'package:flutter_application_1/common_widgets/common_style.dart';
import 'package:flutter_application_1/scrollable_song_list.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'add_new_song.dart';
import 'search.dart';

class NigamLahari extends StatefulWidget {
  NigamLahari({Key? key}) : super(key: key);

  @override
  _NigamLahariState createState() => _NigamLahariState();
}

final storage = FlutterSecureStorage();
//ଆବାହନ  ବନ୍ଦନା  ଆରତୀ  ବିଦାୟ ପ୍ରାର୍ଥନା
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text('ନିଗମ  ଲହରୀ'),
        actions: [
          Row(
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
                  child: Icon(Icons.search),
                ),
              ),

              //SignOut implemented
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: GestureDetector(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    await storage.delete(key: 'uid');
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignIn(),
                        ),
                        ((route) => false));
                  },
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddSong(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => SignIn()));
  }
}
