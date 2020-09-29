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
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color,
            shape: BoxShape.rectangle,
          ),

          child: IconButton(
            icon: Icon(icon),
            color: Colors.white,
            onPressed: () {},
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
