import 'package:flutter/material.dart';
//import 'package:flutter_application_1/common_widgets/common_style.dart';
import 'package:flutter_application_1/music_player.dart';

class CatagorySongList extends StatefulWidget {
  CatagorySongList({Key? key, required this.songCatagory, this.songList})
      : super(key: key);

  final String songCatagory;
  final List<dynamic>? songList;

  @override
  _CatagorySongListState createState() => _CatagorySongListState();
}

class _CatagorySongListState extends State<CatagorySongList> {
  bool _folded = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('${widget.songCatagory} ତାଲିକା'),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
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
                  children: [
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.yellowAccent[700]),
                      padding: EdgeInsets.fromLTRB(18, 10, 18, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'ଜଗାଅରେ ଗଗନ ଭୁବନ ପବନ',
                            style: TextStyle(fontSize: 22),
                          ),
                          GestureDetector(
                            child: Align(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.play_circle_sharp,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MusicPlayer(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      width: double.infinity,
                    ),
                    SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.yellowAccent[700]),
                      padding: EdgeInsets.fromLTRB(18, 10, 18, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'ଉଠ ଉଠ ନିଶି ହେଲା ପରଭାତ',
                            style: TextStyle(fontSize: 22),
                          ),
                          GestureDetector(
                            child: Align(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.play_circle_sharp,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MusicPlayer(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      width: double.infinity,
                    ),
                    SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.yellowAccent[700]),
                      padding: EdgeInsets.fromLTRB(18, 10, 18, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'ଅନାଅରେ ଅନାଅରେ ଅନାଅ',
                            style: TextStyle(fontSize: 22),
                          ),
                          GestureDetector(
                            child: Align(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.play_circle_sharp,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MusicPlayer(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      width: double.infinity,
                    ),
                    SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.yellowAccent[700]),
                      padding: EdgeInsets.fromLTRB(18, 10, 18, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'ଘନ ଅନ୍ଧାରେ',
                            style: TextStyle(fontSize: 22),
                          ),
                          GestureDetector(
                            child: Align(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.play_circle_sharp,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MusicPlayer(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      width: double.infinity,
                    ),
                    SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.yellowAccent[700]),
                      padding: EdgeInsets.fromLTRB(18, 10, 18, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'ନବ ରବି ଆସେ ଉଇଁ',
                            style: TextStyle(fontSize: 22),
                          ),
                          GestureDetector(
                            child: Align(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.play_circle_sharp,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MusicPlayer(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      width: double.infinity,
                    ),
                    // SizedBox(height: 12),
                    // Container(
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(12.0),
                    //       color: Colors.yellowAccent[700]),
                    //   padding: EdgeInsets.fromLTRB(18, 10, 18, 10),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         'ବାଉଳା ! ଅଳସ ପହୁଡ଼ ତେଜ',
                    //         style: TextStyle(fontSize: 22),
                    //       ),
                    //       GestureDetector(
                    //         child: Align(
                    //           alignment: Alignment.center,
                    //           child: Icon(
                    //             Icons.play_circle_sharp,
                    //             size: 30,
                    //             color: Colors.white,
                    //           ),
                    //         ),
                    //         onTap: () {
                    //           Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //               builder: (context) => const MusicPlayer(),
                    //             ),
                    //           );
                    //         },
                    //       ),
                    //     ],
                    //   ),
                    //   width: double.infinity,
                    // ),
                    // SizedBox(height: 12),
                    // Container(
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(12.0),
                    //       color: Colors.yellowAccent[700]),
                    //   padding: EdgeInsets.fromLTRB(18, 10, 18, 10),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         'ନିଶି ହେଲା ଆସି ଅବସାନରେ',
                    //         style: TextStyle(fontSize: 22),
                    //       ),
                    //       GestureDetector(
                    //         child: Align(
                    //           alignment: Alignment.center,
                    //           child: Icon(
                    //             Icons.play_circle_sharp,
                    //             size: 30,
                    //             color: Colors.white,
                    //           ),
                    //         ),
                    //         onTap: () {
                    //           Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //               builder: (context) => const MusicPlayer(),
                    //             ),
                    //           );
                    //         },
                    //       ),
                    //     ],
                    //   ),
                    //   width: double.infinity,
                    // ),
                    // SizedBox(height: 12),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
