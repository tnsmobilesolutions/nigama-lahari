import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/login/signIn.dart';
import 'package:flutter_application_1/nigamLahari/jagarana.dart';
import 'package:flutter_application_1/common_widgets/common_style.dart';
import 'package:flutter_application_1/scrollable_song_list.dart';
import '../add_new_song.dart';
import '../search.dart';

class NigamLahari extends StatefulWidget {
  NigamLahari({Key? key}) : super(key: key);

  @override
  _NigamLahariState createState() => _NigamLahariState();
}

//ଆବାହନ  ବନ୍ଦନା  ଆରତୀ  ବିଦାୟ ପ୍ରାର୍ଥନା
final List<String> items = [
  'song 1',
  'song 2',
  'song 3',
  'song 4',
  'song 5',
  'song 6',
  'song 7',
  'song 8',
  'song 9',
  'song 10',
  'song 11',
  'song 12',
  'song 13',
  'song 14',
  'song 15',
  'song 16',
  'song 17',
  'song 18',
  'song 19',
  'song 20',
];

class _NigamLahariState extends State<NigamLahari> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                            builder: (context) =>
                                Jagarana())); // 1st parameters : jagarana, 2nd parameter : list of jagarana songs from firebase
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
                            items: items,
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
                            items: items,
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
                            items: items,
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
                            items: items,
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
                            items: items,
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
                            items: items,
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
