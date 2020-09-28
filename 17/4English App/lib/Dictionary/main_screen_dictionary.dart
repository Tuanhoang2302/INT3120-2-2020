import 'package:english_app/Screens/Dictionary/cards.dart';
import 'package:flutter/material.dart';

class MainScreenDictionary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "My vocabulary",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
                child: Cards(
                  icons: Icons.bookmark_border,
                  text: "Save Words",
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/saveword');
                },
            ),
            Cards(icons: Icons.replay,text: " Recent words",),
            Cards(icons: Icons.mic, text: "Pronunciation",),
          ],
        ),
      ),
    );
  }
}
