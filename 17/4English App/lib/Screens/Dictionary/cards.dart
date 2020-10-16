import 'package:english_app/globles.dart';
import 'package:flutter/material.dart';

class Cards extends StatelessWidget {
  IconData icons;
  String text;

  Cards({this.icons, this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(top: 16),
      shadowColor: Colors.black,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Row(
          children: [
            Icon(icons, size: 24 * ratio ,),
            Padding(
              padding: const EdgeInsets.only(left: 25 ),
              child: Text(text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20 * ratio,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
