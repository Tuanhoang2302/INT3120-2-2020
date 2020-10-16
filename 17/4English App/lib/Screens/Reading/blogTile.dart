import 'package:cached_network_image/cached_network_image.dart';
import 'package:english_app/Model/article.dart';
import 'package:english_app/Screens/Reading/article_view.dart';
import 'package:english_app/globles.dart';
import 'package:flutter/material.dart';

class BlogTile extends StatelessWidget {
  final String imageUrl, title, desc, url, sourceName;
  BlogTile({this.imageUrl, this.title, this.desc, this.url, this.sourceName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          height: 100,
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15* ratio,
                        fontWeight: FontWeight.w500
                      ),
                    ),

                    Text(sourceName, style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13 * ratio
                    ),)
                  ],
                ),
              ),
              SizedBox(width: 12,),
              Expanded(
                flex: 2,
                child: AspectRatio(
                  aspectRatio: 1/1,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover,)),
                ),
              )
            ],
          ),
        ),
        Container(color: Colors.grey[200], height: 3,),
      ],
    );
  }
}
