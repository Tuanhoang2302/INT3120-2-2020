import 'package:english_app/globles.dart';
import 'package:flutter/material.dart';

class IconShortcut extends StatelessWidget {
  Color color;
  IconData icon;
  String text;

  IconShortcut({this.icon, this.color, this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {

          },
          child: Container(
            width: 45 * ratio,
            height: 45 * ratio,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10 * ratio),
              color: color,
              shape: BoxShape.rectangle,
            ),

            child: Icon(
              icon,
              color: Colors.white,
              size: 25 * ratio,
            )
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16 * ratio
            ),
          ),
        )
      ],
    );
  }
}
