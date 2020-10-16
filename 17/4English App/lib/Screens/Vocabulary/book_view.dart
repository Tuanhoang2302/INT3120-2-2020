import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:english_app/Screens/Vocabulary/pdfView.dart';
import 'package:english_app/Services/database.dart';
import 'package:english_app/globles.dart';
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
  var dir;

  _setStateAfterDownload() async {
    setState(() {
      colors = Colors.green;
      downloading = true;
    });
  }

  _setStateUnDownload() async {
    setState(() {
      colors = Colors.blue;
      downloading = false;
    });
  }

  _download() async {
    final StorageReference storageReference =
    FirebaseStorage().ref().child("books/popular/${widget.title}.pdf");

    await storageReference.getDownloadURL().then((value) async {
      Dio dio = Dio();
      try{
        //var dir = await getApplicationDocumentsDirectory();
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

        _setStateAfterDownload();
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

  _buttonDownload() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: colors
      ),
      child: FlatButton(
        child: Text("Download", style: TextStyle(
            color: Colors.white,
            fontSize: 17 * ratio
        ),),
        onPressed: () {
          print("download");
          _download();
          _pop_up_downloading();
        },
      ),
    );
  }

  _buttonReadAndDelete() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: colors
            ),
            child: FlatButton(
              child: Text("Read", style: TextStyle(
                  color: Colors.white,
                  fontSize: 17 * ratio
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
          ),
        ),
        SizedBox(width: 20 * ratio,),
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.deepOrange
            ),
            child: FlatButton(
              child: Icon(Icons.delete, color: Colors.white, size: iconSize,),
              onPressed: ()async {
                try {
                  File file = File('${dir.path}/${widget.title}.pdf');
                  if (await file.exists()) {
                    await file.delete();
                    _setStateUnDownload();
                    DatabaseService("books").updateDownloadedStatus_Book(widget.id, false);
                  }
                } catch (e) {
                  print(e);
                }
              },
            ),
          ),
        )
      ],
    );
  }

  _overview() {
    return Container(
      height: 180 * ratio,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: 5,),
          Expanded(
            flex: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(imageUrl: widget.imageUrl, fit: BoxFit.fill,),
            ),
          ),
          SizedBox(width: 16 * ratio,),
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(widget.title, style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20 * ratio
                ),),
                SizedBox(height: 15 * ratio,),
                Text('Category: ${widget.category}', style: TextStyle(
                  fontSize: 16 * ratio,
                  fontWeight: FontWeight.w500
                ),),
                Spacer(),
                downloading == false ?
                  _buttonDownload() : _buttonReadAndDelete()
              ],
            ),
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
            fontSize: 24* ratio,
            fontWeight: FontWeight.bold
          ),),
          SizedBox(height: 12,),
          Text(widget.description, style: TextStyle(
            fontSize: 16 * ratio,
            color: Colors.grey
          ),),
        ],
      ),
    );
  }

  checkFileExits() async {
    dir = await getApplicationDocumentsDirectory();
    if(await File("${dir.path}/${widget.title}.pdf").exists()){
      _setStateAfterDownload();
      File file = File('${dir.path}/${widget.title}.pdf');
      doc = await PDFDocument.fromFile(file);
    } else{
      _setStateUnDownload();
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
          margin: EdgeInsets.only(top: 16, left: 10, right: 10),
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
