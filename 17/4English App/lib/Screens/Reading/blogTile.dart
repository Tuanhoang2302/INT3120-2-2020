import 'package:cached_network_image/cached_network_image.dart';
import 'package:english_app/Model/article.dart';
import 'package:english_app/Screens/Reading/article_view.dart';
import 'package:flutter/material.dart';

class BlogTile extends StatelessWidget {
  final String imageUrl, title, desc, url;
  BlogTile({this.imageUrl, this.title, this.desc, this.url});

  @override
  Widget build(BuildContext context) {
    //print(publishAt.toString());
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(imageUrl: imageUrl)),
          SizedBox(height: 8,),
          Text(title, style: TextStyle(
            fontSize: 17,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),),
          SizedBox(height: 8,),
          Text(desc, style: TextStyle(
            color: Colors.black54,
          ),),
        ],
      ),
    );
  }
}
