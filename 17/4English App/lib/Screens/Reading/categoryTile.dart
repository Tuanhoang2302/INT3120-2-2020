import 'package:cached_network_image/cached_network_image.dart';
import 'package:english_app/globles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  String imageUrl, categoryName;
  bool border;

  CategoryTile({this.imageUrl, this.categoryName, this.border});

  @override
  Widget build(BuildContext context) {
    double borderSize = 0;
    Color color = Colors.black;
    if(border == true) {
      borderSize = 3;
      color = Colors.red;
    }
    return  Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: CachedNetworkImage(
            imageUrl:imageUrl,
            width: 120 * ratio, fit: BoxFit.cover,),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(right: 16),
          width: 120 * ratio,
          decoration: BoxDecoration(
            border: Border.all(
              color: color,
              width: borderSize
            ),
            borderRadius: BorderRadius.circular(6),
            color: Colors.black26,
          ),
          child: Text(
            categoryName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14* ratio,
              fontWeight: FontWeight.w500
            ),
          ),
        )
      ],
    );
    //);
  }
}
