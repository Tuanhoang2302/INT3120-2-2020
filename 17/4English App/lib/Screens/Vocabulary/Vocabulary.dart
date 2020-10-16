import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:english_app/Screens/Vocabulary/book_tile.dart';
import 'package:english_app/Screens/Vocabulary/pdfView.dart';
import 'package:english_app/globles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class Vocabulary extends StatefulWidget {
  @override
  _VocabularyState createState() => _VocabularyState();
}

class _VocabularyState extends State<Vocabulary> {
  PDFDocument doc;
  bool _isLoading = false;
  CollectionReference books =
  FirebaseFirestore.instance.collection('books');


  _booksCategory(List<QueryDocumentSnapshot> data, String category, int downloadedIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 290 * ratio,
          margin: EdgeInsets.only(top: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.only(left: 16),
                  child: Text(category, style: TextStyle(
                    fontSize: 24 * ratio,
                    fontWeight: FontWeight.w500
                  ),),
                ),
              ),

              Expanded(
                flex: 9,
                child: ListView.builder(
                  itemCount: data.length + downloadedIndex,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    if(downloadedIndex == 0) {
                      return BookTile(data: data[index],);
                    } else {
                      if(index == 0) {
                        return Container(
                          margin: EdgeInsets.only(top: 12, left: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    Image.asset('assets/images/Untitled.png', fit: BoxFit.cover,),
                                    Icon(Icons.add,size: 40,color: Colors.blue,)
                                  ],/*Image.asset('assets/images/Untitled.png')*/
                                ),
                              ),

                              SizedBox(height: 12,),
                              Expanded(
                                flex: 1,
                                child: Text("Read your books", style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16 * ratio
                                ),),
                              )
                            ],
                          ),
                        );
                      } else {
                        return BookTile(data: data[index - downloadedIndex],);
                      }
                    }
                  }
                ),
              ),
            ],
          ),
        ),
        Container(color: Colors.grey[200], height: 3,),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: books.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<QueryDocumentSnapshot> dataPopular = snapshot.data.docs;
            List<QueryDocumentSnapshot> dataDownloaded = snapshot.data.docs.map((doc) {
              if(doc.data()['isDownloaded'] == true) {
                return doc;
              }
            }).toList();
            dataDownloaded.removeWhere((element) => element == null);
            //print(dataDownloaded);
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _booksCategory(dataDownloaded, "Downloaded", 1),
                  _booksCategory(dataPopular, "Popular", 0),
                ],
              ),
            );
          }
        }
      ),
    );
  }
}
