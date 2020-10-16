import 'dart:convert';

import 'package:http/http.dart';

class ArticleModel {
  String author;
  String title;
  String description;
  String url;
  String urlToImage;
  String content;
  String publishedAt;
  String sourceName;
  ArticleModel({this.author, this.url, this.title, this.content, this.description, this.urlToImage, this.publishedAt, this.sourceName});
}

class News {
  List<ArticleModel> news = [];
  List<ArticleModel> relevantNews = [];

  Future<void> getNews(String category, int pagesize) async {
    int start = pagesize;
    String url = "http://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=de4fdfbd325343a392a55e0cc476d702";
    var response = await get(url);
    if(response.statusCode == 200) {
      var jsonData = await jsonDecode(response.body);
      //print(jsonData["articles"].length);

      for(int i = start; i < start + 8; i++) {
        /*jsonData["articles"].forEach((element) {*/
          if(i < jsonData["articles"].length) {
            var element = jsonData["articles"][i];
            if (element["urlToImage"] != null &&
                element["description"] != null) {
              ArticleModel articleModel = ArticleModel(
                author: element["author"],
                url: element["url"],
                title: element["title"],
                content: element["content"],
                description: element["description"],
                urlToImage: element["urlToImage"],
                publishedAt: element["publishedAt"],
                sourceName: element["source"]["name"]
              );
              news.add(articleModel);
            }
          }
        /*});*/
      }

      //print(news.length);
    } else {
      throw Exception('Failed to load json data');
    }
  }

  Future<void> getRelevantNews(String keyword) async {
    String url = "https://newsapi.org/v2/everything?q=$keyword&apiKey=de4fdfbd325343a392a55e0cc476d702";
    var response = await get(url);
    if(response.statusCode == 200) {
      var jsonData = await jsonDecode(response.body);
      //print(jsonData["articles"].length);

      jsonData["articles"].forEach((element) {
        if(element["urlToImage"] != null && element["description"] != null) {
          ArticleModel articleModel = ArticleModel(
            author: element["author"],
            url: element["url"],
            title: element["title"],
            content: element["content"],
            description: element["description"],
            urlToImage: element["urlToImage"],
            publishedAt: element["publishedAt"],
            sourceName: element["source"]["name"]
          );
          relevantNews.add(articleModel);
        }
      });
      //print(news.length);
    } else {
      throw Exception('Failed to load json data');
    }
  }
}
