import 'package:flutter/material.dart';
import 'package:english_app/Services/database.dart';

class DeleteDialog extends StatelessWidget {
  String text;
  String action;
  DeleteDialog({this.text, this.action});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: 130,
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 16),
                child: Text(
                  text, style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500
                ),),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Text("CANCEL", style: TextStyle(
                      color: Colors.black54,
                      fontSize: 17
                  ),),
                  color: Colors.grey[300],
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text("DELETE", style: TextStyle(
                      color: Colors.white,
                      fontSize: 17
                  ),),
                  color: Colors.blue,
                  onPressed: () {
                    if(action == "delete all recent word") {
                      DatabaseService("recent_words").deleteAllRecentWord();
                      Navigator.of(context).pop();
                    }
                  },
                ),

              ],
            )
          ],
        ),
      ),

    );
  }
}

