import 'dart:async';

import 'package:english_app/Screens/WordView/Word_view.dart';
import 'package:english_app/Services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SuggestionPanel extends StatelessWidget {
  var data;
  SuggestionPanel({this.data});

  @override
  Widget build(BuildContext context) {
    //print(data);
    return Container(
      height: 180,
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
                padding: const EdgeInsets.only(top: 19, left: 25),
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
                          fontSize: 16,
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

