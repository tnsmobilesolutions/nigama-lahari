import 'package:flutter/material.dart';

class Bandana extends StatefulWidget {
  const Bandana({Key? key}) : super(key: key);

  @override
  _BandanaState createState() => _BandanaState();
}

class _BandanaState extends State<Bandana> {
  bool _folded = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('ବନ୍ଦନା ତାଲିକା'),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 20, 20, 0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      width: _folded ? 56 : 200,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        color: Colors.amberAccent[700],
                        boxShadow: kElevationToShadow[6],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(left: 16),
                              child: !_folded
                                  ? const TextField(
                                      decoration: InputDecoration(
                                        hintText: 'ଖୋଜନ୍ତୁ',
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        border: InputBorder.none,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                          AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              child: Material(
                                type: MaterialType.transparency,
                                child: InkWell(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(_folded ? 32 : 0),
                                    topRight: const Radius.circular(32),
                                    bottomLeft:
                                        Radius.circular(_folded ? 32 : 0),
                                    bottomRight: const Radius.circular(32),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Icon(
                                      _folded ? Icons.search : Icons.close,
                                      color: Colors.white,
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
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
