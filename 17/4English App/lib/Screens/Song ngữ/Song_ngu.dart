import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_app/Screens/Song%20ng%E1%BB%AF/article_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SongNgu extends StatefulWidget {
  @override
  _SongNguState createState() => _SongNguState();
}

class _SongNguState extends State<SongNgu> {
  List<QueryDocumentSnapshot> englishArticles = [];
  List<QueryDocumentSnapshot> vietnameseArticles = [];
  CollectionReference englishArtCollection =
  FirebaseFirestore.instance.collection('english_articles');
  CollectionReference vietnameseArtCollection =
  FirebaseFirestore.instance.collection('vietnamese_articles');

  StreamController _streamController;
  Stream _stream;

  _getArticles() async {
      await englishArtCollection.get().then((value) {
        //print(value);
        value.docs.forEach((element) async {
          englishArticles.add(element);

        });
      });

      await vietnameseArtCollection.get().then((value) {
        value.docs.forEach((element) async {
          vietnameseArticles.add(element);
        });
      });
      _streamController.add(true);

  }

  _blogTile(int index, double marginLeft) {
    return Container(
      margin: EdgeInsets.only(left: marginLeft),
      width: 150,
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => ArticleView(
              englishArticle: englishArticles[index],
              vietnameseArticle: vietnameseArticles[index],
            )
          ));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl:englishArticles[index].data()["imageUrl"],
                width: 150, height: 100, fit: BoxFit.cover,),
            ),

            Container(
              margin: EdgeInsets.only(top: 12),
              width: 150,
              child: Text(
                vietnameseArticles[index].data()["title"],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w500
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _Category(String categoryName, String categorySearch) {
    List<int> blogIndex = [];

    for(int i = 0; i < englishArticles.length; i++) {
      if(englishArticles[i].data()['categoryName'] == categorySearch){
        blogIndex.add(i);
      }
    }

    return Container(
      padding: EdgeInsets.all(16),
      height: 215,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 12),
            child: Text(categoryName, style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: blogIndex.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if(index == 0) {
                  return _blogTile(blogIndex[index], 0);
                } else {
                  return _blogTile(blogIndex[index], 30);
                }
              }
            ),
          ),
        ],
      ),
    );
  }

  @override
  initState(){
    super.initState();
    _streamController = StreamController();
    _stream = _streamController.stream;
    _getArticles();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Song ngữ", style: TextStyle(
          color: Colors.black
        ),),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
      ),

      body: StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          if(snapshot.data == null) {
            return Center(child: CircularProgressIndicator(),);
          }
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _Category("Môi trường", "environment"),
                Container(color: Colors.grey[200], height: 10,),
                _Category("Khám phá", "discovery"),
                Container(color: Colors.grey[200], height: 10,),
                _Category("Giải trí", "entertainment"),
              ],
            ),
          );
        },
      ),
    );
  }
}
