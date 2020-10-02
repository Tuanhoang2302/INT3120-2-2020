import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:english_app/Screens/Vocabulary/pdfView.dart';
import 'package:english_app/Services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class BookView extends StatefulWidget {
  String title;
  String description;
  String imageUrl;
  String category;
  String id;

  BookView({this.title, this.description, this.category, this.imageUrl, this.id});

  @override
  _BookViewState createState() => _BookViewState();
}

class _BookViewState extends State<BookView> {
  PDFDocument doc;
  bool downloading;
  var progressString = "0.1%";
  Color colors;

  _download() async {
    final StorageReference storageReference =
    FirebaseStorage().ref().child("books/popular/${widget.title}.pdf");

    await storageReference.getDownloadURL().then((value) async {
      Dio dio = Dio();
      try{
        var dir = await getApplicationDocumentsDirectory();
        await dio.download(
            value,
            "${dir.path}/${widget.title}.pdf",
            onReceiveProgress:(received, total) {
              setState(() {
                progressString = ((received / total) * 100).toStringAsFixed(0) + "%";
              });
            }
        )
            .then((value) => print("success"));

        setState(() {
          downloading = true;
          colors = Colors.green;
        });
        print("Download completed");
        Navigator.pop(context);

        File file = File('${dir.path}/${widget.title}.pdf');
        doc = await PDFDocument.fromFile(file);

        await DatabaseService("books").updateDownloadedStatus_Book(widget.id, downloading);
      } catch (e) {
        print("helo");
        print(e);
      }
    });
  }

  _pop_up_downloading() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Downloading",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
          );
        }
    );
  }

  _overview() {
    return Container(
      height: 180,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(imageUrl: widget.imageUrl, height: 180, width: 150,),
          ),
          SizedBox(width: 16,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(widget.title, style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),),
              SizedBox(height: 15,),
              Text('Category: ${widget.category}', style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500
              ),),
              Spacer(),
              Container(
                width: 130,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: colors
                ),
                child: downloading == false ? FlatButton(
                  child: Text("Download", style: TextStyle(
                    color: Colors.white,
                    fontSize: 17
                  ),),
                  onPressed: () {
                    print("download");
                    _download();
                    _pop_up_downloading();
                  },
                ): FlatButton(
                  child: Text("Read", style: TextStyle(
                      color: Colors.white,
                      fontSize: 17
                  ),),
                  onPressed: () {
                    if(doc != null){
                      print("read");
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => PDFView(book: doc,)
                      ));
                    }
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  _description() {
    return Container(
      margin: EdgeInsets.only(top: 30, left: 8, right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Description', style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold
          ),),
          SizedBox(height: 12,),
          Text(widget.description, style: TextStyle(
            fontSize: 16,
            color: Colors.grey
          ),),
        ],
      ),
    );
  }

  checkFileExits() async {
    var dir = await getApplicationDocumentsDirectory();
    if(await File("${dir.path}/${widget.title}.pdf").exists()){
      setState(() {
        downloading = true;
        colors = Colors.green;
      });
      File file = File('${dir.path}/${widget.title}.pdf');
      doc = await PDFDocument.fromFile(file);
    } else{
      setState(() {
        downloading = false;
        colors = Colors.blue;
      });
      //print("Not exists");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkFileExits();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Details", style: TextStyle(
          color: Colors.black,
        ),),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 16, left: 10),
          child: Column(
            children: <Widget>[
              _overview(),
              _description(),
            ],
          ),
        ),
      ),
    );
  }
}
