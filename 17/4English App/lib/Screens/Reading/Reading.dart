import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_app/Model/article.dart';
import 'package:english_app/Screens/Reading/article_view.dart';
import 'package:english_app/Screens/Reading/blogTile.dart';
import 'package:english_app/Screens/Reading/categoryTile.dart';
import 'package:english_app/Screens/Reading/key_word_article_view.dart';
import 'package:english_app/globles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class Reading extends StatefulWidget {
  @override
  _ReadingState createState() => _ReadingState();
}

class _ReadingState extends State<Reading> {
  CollectionReference category =
      FirebaseFirestore.instance.collection('category');
  List<ArticleModel> articles = new List<ArticleModel>();
  String _categoryType = "technology";
  bool _loading;
  TextEditingController _controller = TextEditingController();

  int _selectedCategoryindex = 0;
  bool selectedCategoryBorder = false;
  int newIndex = 0;
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  getNews(String categoryType) async {
    News newInstance = News();
    await newInstance.getNews(categoryType, 0);
    articles = newInstance.news;
    setState(() {
      _loading = false;
    });
    //print(articles[0].title);
  }

  void _onLoading() async {

    _refreshController.loadComplete();
  }

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 500));
    // if failed,use refreshFailed()
    setState(() {
      articles = null;
    });
    await getNews(_categoryType);
    _refreshController.refreshCompleted();
  }

  getCategory(AsyncSnapshot<QuerySnapshot> snapshot) async {
    return snapshot.data.docs;
  }

  @override
  void initState() {
    super.initState();
    getNews(_categoryType);
  }

  _searchBar() {
    return Container(
      height: 50* ratio,
      padding: EdgeInsets.symmetric(horizontal: 16),
      margin: EdgeInsets.only(bottom: 8, top: 8),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 3,
            color: Colors.blue,
          )),
      child: Center(
        child: TextFormField(
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (value) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => KeyWordArticleView(
                          keyWord: value,
                        )));
            _controller.text = "";
          },
          controller: _controller,
          style: TextStyle(
            fontSize: 18 * ratio,
          ),
          decoration: InputDecoration.collapsed(
            hintText: "Search a topic",
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  _categoryList(var data) {
    return Container(
      height: 70 * ratio,
      margin: EdgeInsets.only(top: 8, bottom: 8),
      child: ListView.builder(
          itemCount: data.length,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            if (index != _selectedCategoryindex) {
              selectedCategoryBorder = false;
            } else {
              selectedCategoryBorder = true;
            }
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategoryindex = index;
                  newIndex = 0;
                  _categoryType = data[index]
                      .data()["categoryName"]
                      .toString()
                      .toLowerCase();
                });
                //_streamController.add(getCategoryNews(data[index].data()["categoryName"].toString().toLowerCase()));
                articles = null;
                getNews(data[index]
                    .data()["categoryName"]
                    .toString()
                    .toLowerCase());
                setState(() {
                  _loading = true;
                });
              },
              child: CategoryTile(
                categoryName: data[index].data()["categoryName"],
                imageUrl: data[index].data()["imageUrl"],
                border: selectedCategoryBorder,
              ),
            );
          }),
    );
  }

  _loadMoreArticle(var data) async {
    _loading = true;
    News newInstance = News();
    await newInstance.getNews(data[_selectedCategoryindex]
        .data()["categoryName"]
        .toString()
        .toLowerCase(), 8*(newIndex));
    List<ArticleModel> allArticles = articles..addAll(newInstance.news);
    setState(() {
      articles = allArticles;
    });
    _loading = false;
  }

  _blogList(var data) {
    if (articles != null) {
      return  Container(
        padding: EdgeInsets.only(top: 16),
        child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ArticleView(
                                blogUrl: articles[index].url,
                              )));
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
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Widget build(BuildContext context) {
    if (category.get() == null) {
      print("fsa");
    }
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: category.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var data = snapshot.data.docs;
            String category = data[_selectedCategoryindex]
                .data()["categoryName"]
                .toString()
                .toLowerCase();
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              print(data[1].data()["categoryName"]);
            }
            //print(articles[0].title);
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _searchBar(),
                  _categoryList(data),
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollDetails) {
                        if (!_loading &&
                            scrollDetails.metrics.pixels ==
                                scrollDetails.metrics.maxScrollExtent) {
                          print("helo");
                          newIndex+= 1;
                          _loadMoreArticle(data);
                        }
                        return false;
                      },
                      child: SmartRefresher(
                        controller: _refreshController,
                        onRefresh: _onRefresh,
                        onLoading: _onLoading,

                        child: SingleChildScrollView(
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                _blogList(data)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
