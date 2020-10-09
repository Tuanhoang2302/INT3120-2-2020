import 'package:cached_network_image/cached_network_image.dart';
import 'package:english_app/Screens/Vocabulary/book_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookTile extends StatefulWidget {
  var data;
  BookTile({this.data});
  @override
  _BookTileState createState() => _BookTileState();
}

class _BookTileState extends State<BookTile> {
  @override

  Widget build(BuildContext context) {
    String imageUrl = widget.data.data()['imageUrl'];
    String title = widget.data.data()['title'];
    String id = widget.data.id;
    //print(widget.data.data()['imageUrl']);
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => BookView(
            title: widget.data.data()['title'],
            description: widget.data.data()['description'],
            imageUrl: widget.data.data()['imageUrl'],
            category: widget.data.data()['category'],
            id: id,
            )
        ));
      },
      child: Container(
        margin: EdgeInsets.only(top: 12, bottom: 12),
        child: Container(
          //margin: EdgeInsets.only(left: 16),
          width: 150,
          margin: EdgeInsets.only(left: 11),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(imageUrl: imageUrl, height: 180, width: 150,),
             ),

              Container(
                margin: EdgeInsets.only( top: 12, left: 8),
                child: Text(title, style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16
                ),))
            ],
          ),
        ),
      ),
    );
  }
}
