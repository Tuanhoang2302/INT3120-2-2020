import 'dart:async';
import 'dart:convert';

import 'package:english_app/Services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class WordView extends StatefulWidget {
  static const routeName = '/wordview';
  String word;
  WordView({this.word});

  @override
  _WordViewState createState() => _WordViewState();
}

class _WordViewState extends State<WordView> {
  String _url = "https://api.dictionaryapi.dev/api/v2/entries/en/";
  Response response;
  var responeJson;
  StreamController _streamController;
  Stream _stream;

  _getData() async{
    response = await get(_url + widget.word);
    responeJson = json.decode(response.body);
    await _streamController.add(json.decode(response.body));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _streamController = StreamController();
    _stream = _streamController.stream;
    _getData();
  }

  Widget build(BuildContext context) {

      return StreamBuilder<Object>(
        stream: _stream,
        builder: (context, snapshot) {
          if(snapshot.data == null){
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(),
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          //print(snapshot.data);
          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              backgroundColor: Colors.white,
              title: Text("${responeJson[0]["word"]}",
                style: TextStyle(color: Colors.black),),
              actions: <Widget>[
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {},

                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(right: 25),
                        child: GestureDetector(
                          onTap: () async {
                            Navigator.pushNamed(
                              context,
                              "/reviewSavedWord",
                              arguments: "${widget.word}",
                            );
                            //await DatabaseService("default").addNewWord(responeJson[0]["word"], responeJson[0]["phonetics"][0]["text"]);
                          },
                          child: Text("Save", style: TextStyle(color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),),
                        )
                    ),
                  ],
                )
              ],
            ),
          );
        }
      );
    }

}

