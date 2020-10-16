import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_app/Constant/delete_all_dialog.dart';
import 'package:english_app/Services/database.dart';
import 'package:english_app/globles.dart';
import 'package:flutter/material.dart';

class RecentWord extends StatefulWidget {
  @override
  _RecentWordState createState() => _RecentWordState();
}

class _RecentWordState extends State<RecentWord> {
  CollectionReference recentWord = FirebaseFirestore.instance.collection('recent_words');


  _deleteDialog() {
    return showDialog(context: context, builder: (context) {
      return DeleteDialog(
        text: "Are you sure to delete all words",
        action: "delete all recent word",
      );
    });
  }

  _wordList(var data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top:5.0,bottom:5, left: 16, right: 16),
              child: Row(
                children: <Widget>[
                  Text(data[index].data()['word'], style: TextStyle(
                      fontSize: 18 * ratio
                  ),),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.grey, size: iconSize,),
                    onPressed: () {
                      DatabaseService("recent_words").deleteRecentWord(data[index].id);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Recent words", style: TextStyle(
          color: Colors.black,
          fontSize: 20 * ratio
        ),),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              _deleteDialog();
            },
            child: Container(
              margin: EdgeInsets.only(right: 30),
              child: Icon(
                Icons.delete_forever,
                color: Colors.grey,
                size: 28 * ratio,)),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot> (
        stream: recentWord.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("");
          }
          var data = snapshot.data.docs;
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: _wordList(data),
          );
        },
      ),
    );
  }
}
