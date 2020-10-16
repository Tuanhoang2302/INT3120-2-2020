import 'dart:async';

import 'package:english_app/Model/article.dart';
import 'package:english_app/Screens/Reading/article_view.dart';
import 'package:english_app/Screens/Reading/blogTile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class KeyWordArticleView extends StatefulWidget {
  String keyWord;
  KeyWordArticleView({this.keyWord});

  @override
  _KeyWordArticleViewState createState() => _KeyWordArticleViewState();
}

class _KeyWordArticleViewState extends State<KeyWordArticleView> {
  List<ArticleModel> articles = new List<ArticleModel>();
  StreamController _streamController;
  Stream _stream;
  bool _loading = true;

  getNews() async {
    News newInstance = News();
    await newInstance.getRelevantNews(widget.keyWord);
    articles = newInstance.relevantNews;
    _loading = false;
    _streamController.add(_loading);
    //print(articles[0].title);
  }

  @override
  initState() {
    super.initState();
    _streamController = StreamController();
    _stream = _streamController.stream;
    getNews();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Relevant Articles",
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
        ),

        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(16),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Articles about: "${widget.keyWord}"',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Colors.blue),
                ),
                StreamBuilder(
                  stream: _stream,
                  builder: (context, snapshot) {
                    if(snapshot.data == false) {
                      return Container(
                        padding: EdgeInsets.only(top: 16),
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: articles.length,
                            itemBuilder: (context, index) {
                              print(articles.length);
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) =>
                                          ArticleView(
                                            blogUrl: articles[index].url,
                                          )
                                  )
                                  );
                                },
                                child: BlogTile(
                                  imageUrl: articles[index].urlToImage,
                                  title: articles[index].title,
                                  desc: articles[index].description,
                                  url: articles[index].url,
                                  sourceName: articles[index].sourceName,
                                ),
                              );
                              //return Text("Hello");
                            }),
                      );
                    } else {
                      return Container(
                          margin: EdgeInsets.only(top: 30),
                          child: Center(child: CircularProgressIndicator(),)
                      );
                    }
                  }
                )
              ],
            ),
          ),
        ));
  }
}
