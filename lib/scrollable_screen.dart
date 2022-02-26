import 'package:flutter/material.dart';

class ScrollableScreen extends StatefulWidget {
  const ScrollableScreen({Key? key}) : super(key: key);

  @override
  _ScrollableScreenState createState() => _ScrollableScreenState();
}

class _ScrollableScreenState extends State<ScrollableScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverFixedExtentList(
                itemExtent: 100,
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Container(
                      alignment: Alignment.center,
                      color: Colors.lightBlue[100],
                      child: Text('List Item'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
