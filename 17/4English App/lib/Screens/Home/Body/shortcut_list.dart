import 'package:english_app/Screens/Home/Body/icon_shortcut.dart';
import 'package:english_app/Screens/Song%20ng%E1%BB%AF/Song_ngu.dart';
import 'package:english_app/main.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:english_app/globles.dart' as globals;

class ShortcutList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(globals.screenSize.width);
    print(globals.screenSize.height);
    double paddingValue = getValueForScreenType<double>(
      context: context,
      mobile: 16,
      tablet: 30,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Flexible(
          child: Padding(
            child: Text('Shortcuts', style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25 * globals.ratio
            )),
            padding: EdgeInsets.all(paddingValue),
          ),
        ),

        Flexible(
          child: Padding(
            padding: EdgeInsets.only(left: paddingValue, right: paddingValue, bottom: paddingValue),
            child: Container(
              height: 45 * globals.ratio,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    flex: 9,
                    child: FractionallySizedBox(
                      heightFactor: 1,
                      child: FlatButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/dictionary');
                        },
                        child: Text("Dictionary", style: TextStyle(
                          color: Colors.white,
                          fontSize: 17 * globals.ratio
                        ),),
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(color: Colors.red)
                        ),
                      ),
                    ),
                  ),
                  Expanded(flex: 1,child: SizedBox()),

                  Expanded(
                    flex: 9,
                    child: FractionallySizedBox(
                      heightFactor: 1,
                      child: FlatButton(
                        child: Text("Song ngữ", style: TextStyle(
                            color: Colors.white,
                            fontSize: 17 * globals.ratio
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
                  ),
                ],
              ),
            ),
          ),
        ),

        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
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
        )
      ],
    );
  }
}
