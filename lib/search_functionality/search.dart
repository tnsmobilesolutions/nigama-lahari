import 'package:flutter/material.dart';
import 'package:flutter_application_1/search_functionality/result_song.dart';

import '../API/searchSongAPI.dart';
import '../constant.dart';
import '../models/songs_model.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  // List<String> _catagory = [
  //   'ଜାଗରଣ',
  //   'ପ୍ରତୀକ୍ଷା',
  //   'ଆବାହନ',
  //   'ଆରତୀ',
  //   'ବନ୍ଦନା',
  //   'ପ୍ରାର୍ଥନା',
  //   'ବିଦାୟ ପ୍ରାର୍ଥନା',
  // ];

  String? _categoryOption;
  String? _attributeOption;
  final _nameController = TextEditingController();
  String? _selectedOption;
  //List<String> _singer = [];
  final _singerNameController = TextEditingController();
  //String? _singerOption;
  List<String> _songs = ["Name", "Singer", "Attribute", "Category", "Duration"];
  Map<String, String> _songsInOdia = {
    'Name': 'ନାମ',
    'Singer': 'ଗାୟକ',
    'Attribute': 'ଭାବ',
    'Category': 'ବିଭାଗ',
    'Duration': "ଦୀର୍ଘତା"
  };

  String _value = '';

  Widget getSongNameWidget(String? selectedOption) {
    if (selectedOption == "Name") {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextFormField(
          keyboardType: TextInputType.name,
          controller: _nameController,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(
                color: Constant.orange,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Constant.orange),
            ),
            contentPadding: const EdgeInsets.all(15),
            labelText: 'ଗୀତ ନାମ ଲେଖନ୍ତୁ',
            labelStyle: TextStyle(fontSize: 15.0, color: Constant.white24),
          ),

          validator: (value) {
            if (value!.isEmpty) {
              return 'Please Enter Your Name';
            } else if (!RegExp(r'^[a-zA-Z0-9]+(?:[\w -]*[a-zA-Z0-9]+)*$')
                .hasMatch(value)) {
              return 'Please Enter Correct Name';
            }
            return null;
          },
          // style: TextStyle(height: 0.5),
        ),
      );
    } else {
      return SizedBox(width: 0, height: 0);
    }
  }

  // Widget getSingerNameWidget(String? selectedOption) {
  //   if (selectedOption == "Singer") {
  //     return DropdownButton(
  //       borderRadius: BorderRadius.circular(15),
  //       style: TextStyle(color: Constant.white),
  //       iconEnabledColor: Theme.of(context).iconTheme.color,
  //       hint: Text(
  //         'ଚୟନ କରନ୍ତୁ',
  //         style: TextStyle(
  //           color: Constant.white24,
  //           fontSize: 15,
  //         ),
  //       ),
  //       value: _singerOption,
  //       dropdownColor: Constant.orange,
  //       onChanged: (value) {
  //         setState(
  //           () {
  //             _singerOption = value as String?;
  //             print(_singerOption.toString());
  //           },
  //         );
  //       },
  //       items: _singer.map(
  //         (val) {
  //           return DropdownMenuItem(
  //             child: new Text(val),
  //             value: val,
  //           );
  //         },
  //       ).toList(),
  //     );
  //   } else {
  //     return SizedBox(width: 0, height: 0);
  //   }
  // }

  Widget getSingerNameWidget(String? selectedOption) {
    if (selectedOption == "Singer") {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextFormField(
          style: TextStyle(color: Constant.white),
          keyboardType: TextInputType.name,
          controller: _singerNameController,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please Enter Your Name';
            } else if (!RegExp(r'^[a-zA-Z0-9]+(?:[\w -]*[a-zA-Z0-9]+)*$')
                .hasMatch(value)) {
              return 'Please Enter Correct Name';
            }
            return null;
          },
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(
                color: Constant.orange,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Constant.orange),
            ),
            contentPadding: const EdgeInsets.all(15),
            labelText: 'ଗାୟକଙ୍କ ନାମ ଲେଖନ୍ତୁ',
            labelStyle: TextStyle(fontSize: 15.0, color: Constant.white24),
          ),
        ),
      );
    } else {
      return SizedBox(width: 0, height: 0);
    }
  }

  // Widget getAttributeSong(String? selectedOption) {
  //   bool _isSelected = false;
  //   if (selectedOption == "Attribute") {
  //     return Padding(
  //         padding: const EdgeInsets.all(20.0),
  //         child: Wrap(
  //           children: [
  //             ChoiceChip(
  //               label: Text('ନାମ'),
  //               disabledColor: Constant.lightblue,
  //               selectedColor: Constant.orange,
  //               selected: _isSelected,
  //               onSelected: (value) {
  //                 _isSelected = value;
  //               },
  //             )
  //           ],
  //         ));
  //   } else {
  //     return SizedBox(width: 0, height: 0);
  //   }
  // }

  // Widget getAttributeSong(String? selectedOption) {
  //   if (selectedOption == "Attribute") {
  //     return Padding(
  //       padding: const EdgeInsets.all(20.0),
  //       child: TextFormField(
  //         keyboardType: TextInputType.name,
  //         controller: _attributeController,
  //         validator: (value) {
  //           if (value!.isEmpty) {
  //             return 'Please Enter Your Name';
  //           } else if (!RegExp(r'^[a-zA-Z0-9]+(?:[\w -]*[a-zA-Z0-9]+)*$')
  //               .hasMatch(value)) {
  //             return 'Please Enter Correct Name';
  //           }
  //           return null;
  //         },
  //         decoration: InputDecoration(
  //           focusedBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(15.0),
  //             borderSide: BorderSide(
  //               color: Constant.orange,
  //             ),
  //           ),
  //           enabledBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(15),
  //             borderSide: BorderSide(color: Constant.orange),
  //           ),
  //           contentPadding: const EdgeInsets.all(15),
  //           labelText: 'ଗୀତର ଭାବ ଲେଖନ୍ତୁ',
  //           labelStyle: TextStyle(fontSize: 15.0, color: Constant.white24),
  //         ),
  //       ),
  //     );
  //   } else {
  //     return SizedBox(width: 0, height: 0);
  //   }
  // }

  Widget getAttributeSong(String? selectedOption) {
    if (selectedOption == "Attribute") {
      return DropdownButton(
        borderRadius: BorderRadius.circular(15),
        style: TextStyle(color: Constant.white),
        iconEnabledColor: Theme.of(context).iconTheme.color,
        hint: Text(
          'ଚୟନ କରନ୍ତୁ',
          style: TextStyle(
            color: Constant.white24,
            fontSize: 15,
          ),
        ),
        value: _attributeOption,
        dropdownColor: Constant.orange,
        onChanged: (value) {
          setState(
            () {
              _attributeOption = value as String?;
              print(_attributeOption.toString());
            },
          );
        },
        items: Constant.attribute.map(
          (val) {
            return DropdownMenuItem(
              child: new Text(val),
              value: val,
            );
          },
        ).toList(),
      );
    } else {
      return SizedBox(width: 0, height: 0);
    }
  }

  Widget getCategorySong(String? selectedOption) {
    if (selectedOption == "Category") {
      return DropdownButton(
        borderRadius: BorderRadius.circular(15),
        style: TextStyle(color: Constant.white),
        iconEnabledColor: Theme.of(context).iconTheme.color,
        hint: Text(
          'ଚୟନ କରନ୍ତୁ',
          style: TextStyle(
            color: Constant.white24,
            fontSize: 15,
          ),
        ),
        value: _categoryOption,
        dropdownColor: Constant.orange,
        onChanged: (value) {
          setState(
            () {
              _categoryOption = value as String?;
              print(_categoryOption.toString());
            },
          );
        },
        items: Constant.catagory.map(
          (val) {
            return DropdownMenuItem(
              child: new Text(val),
              value: val,
            );
          },
        ).toList(),
      );
    } else {
      return SizedBox(width: 0, height: 0);
    }
  }

  Widget getDurationWidget(String? selectedOption) {
    if (selectedOption == "Duration") {
      return Theme(
        data: ThemeData(unselectedWidgetColor: Constant.orange),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
              title: Text(
                'ଛୋଟ ଗୀତ',
                style: TextStyle(color: Constant.white),
              ),
              leading: Radio<String>(
                fillColor:
                    MaterialStateColor.resolveWith((states) => Constant.orange),
                value: 'small',
                groupValue: _value,
                onChanged: (value) {
                  setState(() {
                    _value = value!; //'< 0:05:00';
                  });
                },
              ),
            ),
            ListTile(
              title: Text(
                'ମଧ୍ୟମ ଗୀତ',
                style: TextStyle(color: Constant.white),
              ),
              leading: Radio<String>(
                fillColor:
                    MaterialStateColor.resolveWith((states) => Constant.orange),
                value: 'medium',
                groupValue: _value,
                onChanged: (value) {
                  setState(() {
                    _value = value!; //'0:05:00 - 0:08:00';
                  });
                },
              ),
            ),
            ListTile(
              title: Text(
                'ଲମ୍ବା ଗୀତ',
                style: TextStyle(color: Constant.white),
              ),
              leading: Radio<String>(
                fillColor:
                    MaterialStateColor.resolveWith((states) => Constant.orange),
                value: 'long',
                groupValue: _value,
                onChanged: (value) {
                  setState(() {
                    _value = value!; //'> 0:08:00';
                  });
                },
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox(width: 0, height: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Scaffold(
          appBar: AppBar(
            leading: BackButton(color: Theme.of(context).iconTheme.color),
            elevation: 0,
            centerTitle: true,
            title: Text('ଖୋଜନ୍ତୁ'),
          ),
          body: Align(
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: _selectedOption == 'Category' ||
                          _selectedOption == 'Attribute'
                      ? MainAxisAlignment.spaceEvenly
                      : MainAxisAlignment.center,
                  children: [
                    DropdownButton(
                      borderRadius: BorderRadius.circular(15),
                      iconEnabledColor: Theme.of(context).iconTheme.color,
                      style: TextStyle(color: Constant.white),
                      dropdownColor: Constant.orange,
                      hint: Text(
                        'ସଂଗୀତ ଖୋଜନ୍ତୁ',
                        style: TextStyle(color: Constant.white),
                      ),
                      value: _selectedOption,
                      onChanged: (newValue) {
                        setState(
                          () {
                            _selectedOption = newValue as String?;
                          },
                        );
                      },
                      items: _songs.map(
                        (song) {
                          return DropdownMenuItem(
                            child: new Text(_songsInOdia[song] ?? ''),
                            value: song,
                          );
                        },
                      ).toList(),
                    ),
                    _selectedOption == 'Category'
                        ? getCategorySong(_selectedOption)
                        : getAttributeSong(_selectedOption),
                  ],
                ),
                //SizedBox(height: 30),
                getSongNameWidget(_selectedOption),
                getSingerNameWidget(_selectedOption),

                getDurationWidget(_selectedOption),
                SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Constant.orange),
                  child: Text("ଖୋଜନ୍ତୁ"),
                  onPressed: () async {
                    print('search btn pressrd');
                    if (_selectedOption == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          elevation: 6,
                          behavior: SnackBarBehavior.floating,
                          content: const Text(
                            'କୌଣସି ଏକ ବିକଳ୍ପ ଚୟନ କରନ୍ତୁ',
                            style: TextStyle(color: Constant.white),
                          ),
                          backgroundColor: Constant.orange,
                        ),
                      );
                    } else {
                      List<Song>? allSongs;

                      final searchAPI = SearchSongAPI();

                      if (_selectedOption == "Name") {
                        if (_nameController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              elevation: 6,
                              behavior: SnackBarBehavior.floating,
                              content: const Text(
                                'ଦୟାକରି ଗୀତ ନାମ ଲେଖନ୍ତୁ',
                                style: TextStyle(color: Constant.white),
                              ),
                              backgroundColor: Constant.orange,
                            ),
                          );
                        } else {
                          allSongs = await searchAPI
                              .getSongByName(_nameController.text);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResultSong(
                                songs: allSongs,
                              ),
                            ),
                          );
                        }
                        allSongs =
                            await searchAPI.getSongByName(_nameController.text);
                      } else if (_selectedOption == "Singer") {
                        if (_singerNameController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              elevation: 6,
                              behavior: SnackBarBehavior.floating,
                              content: const Text(
                                'ଦୟାକରି ଗାୟକଙ୍କ ନାମ ଲେଖନ୍ତୁ',
                                style: TextStyle(color: Constant.white),
                              ),
                              backgroundColor: Constant.orange,
                            ),
                          );
                        } else {
                          allSongs = await searchAPI
                              .getSongBySingerName(_singerNameController.text);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResultSong(
                                songs: allSongs,
                              ),
                            ),
                          );
                        }
                      } else if (_selectedOption == "Attribute") {
                        if (_attributeOption == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              elevation: 6,
                              behavior: SnackBarBehavior.floating,
                              content: const Text(
                                'ଦୟାକରି ଗୀତର ଭାବ ବାଛନ୍ତୁ',
                                style: TextStyle(color: Constant.white),
                              ),
                              backgroundColor: Constant.orange,
                            ),
                          );
                        } else {
                          allSongs = await searchAPI
                              .getSongByAttribute(_attributeOption);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResultSong(
                                songs: allSongs,
                              ),
                            ),
                          );
                        }
                      } else if (_selectedOption == "Category") {
                        if (_categoryOption == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              elevation: 6,
                              behavior: SnackBarBehavior.floating,
                              content: const Text(
                                'ଦୟାକରି ଗୀତର ବିଭାଗ ବାଛନ୍ତୁ',
                                style: TextStyle(color: Constant.white),
                              ),
                              backgroundColor: Constant.orange,
                            ),
                          );
                        } else {
                          allSongs = await searchAPI
                              .getSongByCategory(_categoryOption!);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResultSong(
                                songs: allSongs,
                              ),
                            ),
                          );
                        }
                      } else if (_selectedOption == "Duration") {
                        if (_value.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              elevation: 6,
                              behavior: SnackBarBehavior.floating,
                              content: const Text(
                                'ଦୟାକରି ଦୀର୍ଘତା ଚୟନ କରନ୍ତୁ',
                                style: TextStyle(color: Constant.white),
                              ),
                              backgroundColor: Constant.orange,
                            ),
                          );
                        } else {
                          allSongs = await searchAPI.getSongByDuration(_value);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResultSong(
                                songs: allSongs,
                              ),
                            ),
                          );
                        }
                      } else {
                        allSongs = [];
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
