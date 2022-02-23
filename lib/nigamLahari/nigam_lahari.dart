import 'package:flutter/material.dart';
import 'package:flutter_application_1/add_new_song.dart';
import 'package:flutter_application_1/nigamLahari/jagarana.dart';
import 'package:flutter_application_1/common_widgets/common_style.dart';
import 'package:flutter_application_1/nigamLahari/pratikhya.dart';
import 'package:flutter_application_1/nigamLahari/abahana.dart';
import 'package:flutter_application_1/nigamLahari/aarti.dart';
import 'package:flutter_application_1/nigamLahari/bandana.dart';
import 'package:flutter_application_1/nigamLahari/prarthana.dart';
import 'package:flutter_application_1/nigamLahari/bidaya_prarthana.dart';

import '../search.dart';

class NigamLahari extends StatefulWidget {
  const NigamLahari({Key? key}) : super(key: key);

  @override
  _NigamLahariState createState() => _NigamLahariState();
}

//ଆବାହନ  ବନ୍ଦନା  ଆରତୀ  ବିଦାୟ ପ୍ରାର୍ଥନା

class _NigamLahariState extends State<NigamLahari> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('ନିଗମ  ଲହରୀ'),
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
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              GestureDetector(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'ଜାଗରଣ',
                    style: CommonStyle.myStyle,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Jagarana()));
                },
              ),
              const SizedBox(height: 8),
              const Divider(
                thickness: 2,
              ),
              const SizedBox(height: 24),
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
                        builder: (context) => const Pratikhya(),
                      ),
                    );
                  }),
              const SizedBox(height: 8),
              const Divider(
                thickness: 2,
              ),
              const SizedBox(height: 24),
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
                        builder: (context) => const Abahana(),
                      ),
                    );
                  }),
              const SizedBox(height: 8),
              const Divider(
                thickness: 2,
              ),
              const SizedBox(height: 24),
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
                        builder: (context) => const Aarti(),
                      ),
                    );
                  }),
              const SizedBox(height: 8),
              const Divider(
                thickness: 2,
              ),
              const SizedBox(height: 24),
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
                        builder: (context) => const Bandana(),
                      ),
                    );
                  }),
              const SizedBox(height: 8),
              const Divider(
                thickness: 2,
              ),
              const SizedBox(height: 24),
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
                        builder: (context) => const Prarthana(),
                      ),
                    );
                  }),
              const SizedBox(height: 8),
              const Divider(
                thickness: 2,
              ),
              const SizedBox(height: 24),
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
                        builder: (context) => const BidayaPrarthana(),
                      ),
                    );
                  }),
              const SizedBox(height: 8),
              const Divider(
                thickness: 2,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNewSong(),
            ),
          );
        },
        child: Text('Add'),
      ),
    );
  }
}
