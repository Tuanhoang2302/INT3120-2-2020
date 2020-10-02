import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_app/Constant/delete_alert_dialog.dart';
import 'package:english_app/Screens/WordView/review_saved_word.dart';
import 'package:english_app/Services/database.dart';
import 'package:flutter/material.dart';

class SavedWordList extends StatefulWidget {
  String folder;
  SavedWordList({this.folder});
  @override
  _SavedWordListState createState() => _SavedWordListState();
}

class _SavedWordListState extends State<SavedWordList> {
  @override
  createAlertDialog(BuildContext context, String id) {
    return showDialog(context: context, builder: (context) {
      return DeleteAlertDialog(id: id,);
    });
  }

  _searchBar() {
    return Container(
      height: 50,
      margin: EdgeInsets.only(bottom: 8, top:16),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 3,
            color: Colors.blue,
          )
      ),
      child: TextFormField(
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (value) {

        },
        style: TextStyle(
          fontSize: 18,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 4, left: 14),
          hintText: "Search",
          border: InputBorder.none,
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
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
                    Text(data[index].data()["word"], style: TextStyle(
                        fontSize: 17
                    ),),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        createAlertDialog(context, data[index].id.toString());
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ReviewSavedWord(word: data[index].data()["word"], id: data[index].id,)
                        ));
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          widget.folder,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: DatabaseService("save_words")
              .Collection
              .where('folder', isEqualTo: widget.folder)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(),);
            }
            var data = snapshot.data.docs;
            //print(data.length);
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _searchBar(),
                  _wordList(data)
                ],
              ),
            );
          }),
    );
  }
}
