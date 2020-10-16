import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArticleView extends StatefulWidget {
  QueryDocumentSnapshot englishArticle;
  QueryDocumentSnapshot vietnameseArticle;
  ArticleView({this.englishArticle, this.vietnameseArticle});

  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  bool showWordBank= false;
  FocusNode _focus = new FocusNode();

  _settingModalBottomSheet(context, String translate){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          var richText = translate.toString().split("*");
          return Wrap(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8),
                width: 500,
                color: Colors.blue,
                child: Center(
                  child: Text("Vietnamese", style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                  ),),),
              ),
              Container(
                  child: _richText(richText),
                  padding: EdgeInsets.all(16)
              )
            ],
          );
        }
    );
  }

  _title(BuildContext context) {
    return Column(
      children: [
        Text(widget.englishArticle.data()["title"], style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20
        ),),
        SizedBox(height: 16,),
        GestureDetector(
          child: Icon(Icons.g_translate, color: Colors.grey,),
          onTap: () {
            _settingModalBottomSheet(context, widget.vietnameseArticle.data()["title"]);
          },
        ),
        SizedBox(height: 16,),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl:widget.englishArticle.data()["imageUrl"],
            width: 380, height: 200, fit: BoxFit.cover,),
        ),
      ],
    );
  }

  _richText(var richText) {
    return SelectableText.rich(
      TextSpan(
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
          ),
          children: List.generate(richText.length, (index) {
            if(richText.length == 1) {
              return TextSpan(
                text: richText[0],
              );
            } else {
              if(index % 2 == 1) {
                return TextSpan(
                    text: richText[index],
                    style: TextStyle(
                        color: Colors.red
                    )
                );
              } else {
                return TextSpan(
                  text: richText[index],
                );
              }
            }
          })
      ),
      focusNode: _focus,
    );
  }

  _paragraphs() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.englishArticle.data()["paragraph"].length,
      itemBuilder: (context, index) {
        var richText = widget.englishArticle.data()["paragraph"][index].toString().split("*");
        return Column(
          children: [
            Container(
              /*child: Text(englishArticle.data()["paragraph"][index], style: TextStyle(
                fontSize: 17,
              ),),*/
              child: _richText(richText),
              margin: EdgeInsets.only(bottom: 16),
            ),
            GestureDetector(
              onTap: () {
                _settingModalBottomSheet(context, widget.vietnameseArticle.data()["paragraph"][index]);
              },
              child: Icon(Icons.g_translate, color: Colors.grey,)),
            SizedBox(height: 16,)
          ],
        );
      }
    );
  }

  _ClosedWordBank() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title(context),
            SizedBox(height: 20,),
            _paragraphs(),
            SizedBox(height: 20,),

            Text("WORD BANK", style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              //decoration: TextDecoration.underline
            ),),
            SizedBox(height: 8,),
            GestureDetector(
              onTap: () {
                setState(() {
                  showWordBank = true;
                });
              },
              child: Text("Hiển thị WORD BANK", style: TextStyle(
                fontSize: 14,
                color: Colors.green,
                decoration: TextDecoration.underline
              ),),
            )
          ],
        ),
      ],
    );
  }

  _ListOfWordBank() {
    return ListView(
      shrinkWrap: true,
      children: List.generate(widget.englishArticle.data()["word_bank"].length, (index) {
        var richText = widget.englishArticle.data()["word_bank"][index].toString().split("*");
        return Container(
          margin: EdgeInsets.only(top: 8),
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 18,
                color: Colors.black
              ),
              children: List.generate(richText.length, (index) {
                if(index == 0) {
                  return TextSpan(
                    text: richText[0],
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    )
                  );
                } else {
                  return TextSpan(
                    text: richText[1]
                  );
                }
              })
            ),
          ),
        );
      }),
    );
  }

  _OpenedWordBank() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title(context),
            SizedBox(height: 20,),
            _paragraphs(),
            SizedBox(height: 20,),

            Text("WORD BANK", style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              //decoration: TextDecoration.underline
            ),),
            SizedBox(height: 8,),
            GestureDetector(
              onTap: () {
                setState(() {
                  showWordBank = false;
                });
              },
              child: Text("Ẩn WORD BANK", style: TextStyle(
                  fontSize: 14,
                  color: Colors.green,
                  decoration: TextDecoration.underline
              ),),
            ),
            SizedBox(height: 8,),

            _ListOfWordBank()
          ],
        ),
      ],
    );
  }

  @override
  void initState(){
    super.initState();

  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
        ),

        body: Container(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: showWordBank == false ?_ClosedWordBank() :
                _OpenedWordBank()
          ),
        ),
      ),
    );
  }
}
