import 'package:english_app/Screens/Home/Body/icon_shortcut.dart';
import 'package:english_app/Screens/Song%20ng%E1%BB%AF/Song_ngu.dart';
import 'package:flutter/material.dart';

class ShortcutList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text(
            'Shortcuts',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              width: 170,
              height: 50,
              child: FlatButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/dictionary');
                },
                child: Text("Dictionary", style: TextStyle(
                  color: Colors.white,
                  fontSize: 17
                ),),
                color: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: Colors.red)
                ),
              ),
            ),

            Container(
              width: 170,
              height: 50,
              child: FlatButton(
                child: Text("Song ngữ", style: TextStyle(
                    color: Colors.white,
                    fontSize: 17
                ),),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => SongNgu()
                  ));
                },
                color: Colors.orange[400],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: Colors.yellow)
                ),
              ),
            ),
          ],
        ),

        Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconShortcut(
                    icon: Icons.chrome_reader_mode,
                    color: Colors.green,
                    text: "News",
                  ),

                  IconShortcut(
                    icon: Icons.chrome_reader_mode,
                    color: Colors.lightBlueAccent,
                    text: "Books",
                  ),

                  IconShortcut(
                    icon: Icons.chrome_reader_mode,
                    color: Colors.red,
                    text: "Videos",
                  ),

                  IconShortcut(
                    icon: Icons.chrome_reader_mode,
                    color: Colors.lightBlueAccent,
                    text: "News",
                  ),
                ],
              ),

            ],
          ),
        ),
      ],
    );
  }
}
