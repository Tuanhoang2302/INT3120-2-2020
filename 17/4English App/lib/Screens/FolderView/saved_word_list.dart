import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_app/Constant/delete_item_dialog.dart';
import 'package:english_app/Screens/WordView/review_saved_word.dart';
import 'package:english_app/Services/database.dart';
import 'package:english_app/globles.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SavedWordList extends StatefulWidget {
  String folder;

  SavedWordList({this.folder});

  @override
  _SavedWordListState createState() => _SavedWordListState();
}

class _SavedWordListState extends State<SavedWordList> {
  List<String> savedWordList = [];
  CollectionReference saveWordCollection =
      FirebaseFirestore.instance.collection('save_words');
  TextEditingController _controller = TextEditingController();
  StreamController _streamController;
  bool _isSearching = false;
  Stream _stream;
  Timer _debounce;

  createAlertDialog(BuildContext context, String id) {
    return showDialog(
        context: context,
        builder: (context) {
          return DeleteAlertDialog(
            id: id,
          );
        });
  }

  _searchBar() {
    return Container(
      alignment: Alignment.center,
      height: 50 * ratio,
      margin: EdgeInsets.only(bottom: 8, top: 16),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 3,
            color: Colors.blue,
          )),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: TextFormField(
          onChanged: (text) async {
            _streamController.add(text);
          },
          controller: _controller,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (value) {},
          style: TextStyle(
            fontSize: 18 * ratio,
          ),
          decoration: InputDecoration.collapsed(
            //contentPadding: EdgeInsets.only(left: padding),
            hintText: "Search",
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  _wordList(var data) {
    return Expanded(
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 16, top: 8 * ratioHeight, bottom: 8* ratioHeight, right: 8),
                child: Row(
                  children: <Widget>[
                    Text(
                      data[index].data()["word"],
                      style: TextStyle(fontSize: 17 * ratio),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.delete, size: iconSize,),
                      onPressed: () {
                        createAlertDialog(context, data[index].id.toString());
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, size: iconSize,),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReviewSavedWord(
                                      word: data[index].data()["word"],
                                      id: data[index].id,
                                    )));
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  @override
  initState() {
    super.initState();
    _streamController = StreamController();
    _stream = _streamController.stream;
    _streamController.add(_controller.text);
  }

  Widget build(BuildContext context) {
    //print(savedWordList.length);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          widget.folder,
          style: TextStyle(
              color: Colors.black,
              fontSize: 20 * ratio),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: _searchBar(),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                //print(snapshot.data);
                var text = snapshot.data;
                return StreamBuilder<QuerySnapshot>(
                    stream: DatabaseService("save_words")
                        .Collection
                        .where('folder', isEqualTo: widget.folder)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Text(""),
                        );
                      }

                      var data = snapshot.data.docs;
                      var filterData = snapshot.data.docs.map((item) {
                        if (item.data()["word"].contains(text)) {
                          return item;
                        }
                      }).toList();
                      filterData.removeWhere((element) => element == null);
                      print(filterData);
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [ _wordList(filterData)],
                        ),
                      );
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}
