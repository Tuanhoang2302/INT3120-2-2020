import 'dart:async';

import 'package:english_app/Screens/WordView/Word_view.dart';
import 'package:english_app/Services/database.dart';
import 'package:english_app/globles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SuggestionPanel extends StatelessWidget {
  var data;
  SuggestionPanel({this.data});

  @override
  Widget build(BuildContext context) {
    //print(data);
    return Container(
      height: 180 * ratio,
      margin: EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20,
            ),
          ]
      ),
      //padding: EdgeInsets.all(16),
      child: Card(
        child: ListView.builder(
            itemCount: data.length,//data.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.only(top: 19* ratio, left: 25 * ratio),
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        DatabaseService("recent_words").addNewRecentWord('${data[index]["word"]}');
                        Navigator.pushNamed(
                          context,
                          '/wordview',
                          arguments: '${data[index]["word"]}'
                        );
                      },
                      child: Text(
                        data[index]["word"],
                        style: TextStyle(
                          fontSize: 16 * ratio,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
        ),
      ),
    );
  }
}

