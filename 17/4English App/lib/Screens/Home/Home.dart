import 'package:english_app/Model/model.dart';
import 'package:english_app/Redux/Actions/actions.dart';
import 'package:english_app/Screens/Home/Body/shortcut_list.dart';
import 'package:english_app/Screens/Listening/Listening.dart';
import 'package:english_app/Screens/Reading/Reading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _childen = [
    ShortcutList(),
    Listening(),
    Reading(),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "4English",
            style: TextStyle(color: Colors.blue[700], fontSize: 25),
          ),
          actions: <Widget>[
            Container(
              child: IconButton(
                icon: Icon(Icons.file_download),
                color: Colors.black,
                onPressed: () {
                  //print("hello");
                },
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: IconButton(
                icon: Icon(Icons.favorite),
                color: Colors.black,
                onPressed: () {
                  //print("hello");
                },
              ),
            ),

          ],
        ),

        body: IndexedStack(
          index: _currentIndex,
          children: _childen,
        ),

        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          selectedItemColor: Colors.blue,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Home")
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.headset),
              title: Text("Listening")
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.import_contacts),
              title: Text("Reading")
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.book),
                title: Text("Vocabulary")
            ),

          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
