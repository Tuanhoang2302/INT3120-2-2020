import 'package:english_app/Model/model.dart';
import 'package:english_app/Redux/Actions/actions.dart';
import 'package:english_app/Screens/Account/Account.dart';
import 'package:english_app/Screens/Home/Body/shortcut_list.dart';
import 'package:english_app/Screens/Listening/Listening.dart';
import 'package:english_app/Screens/Reading/Reading.dart';
import 'package:english_app/Screens/Vocabulary/Vocabulary.dart';
import 'package:english_app/main.dart';
import 'package:flutter/material.dart';
import 'package:english_app/globles.dart' as globals;

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
    Vocabulary(),
    Account()
  ];

  buildBottomNavigationItem(IconData icons, double fontSize, String text) {
    return BottomNavigationBarItem(
        icon: Icon(icons, size: globals.iconSize - 3,),
        title: Text(text, style: TextStyle(
            fontSize: fontSize
        ),)
    );
  }

  @override
  Widget build(BuildContext context) {
    //var screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "4English",
            style: TextStyle(color: Colors.blue[700], fontSize: 25 * globals.ratio),
          ),
          actions: <Widget>[
            Icon(
              Icons.file_download,
              size: 27 * globals.ratio,
              color: Colors.grey,
            ),
            SizedBox(width: 16,),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Icon(
                Icons.favorite,
                size: 27 * globals.ratio,
                color: Colors.grey,
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
            buildBottomNavigationItem(Icons.home, 15 * globals.ratio, "Home"),
            buildBottomNavigationItem(Icons.headset, 15 * globals.ratio, "Listening"),
            buildBottomNavigationItem(Icons.import_contacts, 15 * globals.ratio, "Reading"),
            buildBottomNavigationItem(Icons.book, 15 * globals.ratio, "Book"),
            buildBottomNavigationItem(Icons.account_circle, 15 * globals.ratio, "Account"),

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
