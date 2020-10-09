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
  bool founded;

  _getData() async{
    response = await get(_url + widget.word);
    if(response.statusCode == 200) {
      setState(() {
        founded = true;
      });
    } else {
      setState(() {
        founded = false;
      });
    }
    responeJson = json.decode(response.body);
    await _streamController.add(json.decode(response.body));
  }

  _saveButton() {
    return Container(
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
    );
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
          if(founded == false) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(),
              body: Center(
                child: Text("No data showed"),
              ),
            );
          }

          String word = responeJson[0]["word"];
          var phonetics = responeJson[0]["phonetics"];
          var meanings = responeJson[0]["meanings"];

          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              backgroundColor: Colors.white,
              title: Text(word,
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
                    _saveButton()
                  ],
                )
              ],
            ),

            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(word, style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500
                    ),),

                    //PartOfSpeech
                    Row(
                      children: List.generate(meanings.length, (index) {
                        if(index != meanings.length - 1) {
                          return Text(meanings[index]["partOfSpeech"] + ", ",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 16
                            ),);
                        } else {
                          return Text(meanings[index]["partOfSpeech"], style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 16
                          ),);
                        }
                      }),
                    ),

                    //Mic
                    Column(
                      children: List.generate(phonetics.length, (index) {
                        return Container(
                          margin: EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              Text("${index + 1})"),
                              Icon(Icons.volume_up),
                            ],
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 16,),

                    //definitions
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: meanings.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Column(
                            children: [
                              Row(
                                children: <Widget>[
                                  Text("${index + 1})", style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500
                                  ),),
                                  SizedBox(width: 5,),
                                  Text(meanings[index]['partOfSpeech'], style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500
                                  ),)
                                ],
                              ),
                              SizedBox(height: 10,),
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: meanings[index]["definitions"].length,
                                itemBuilder: (context, idx) {
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 25),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(bottom: 5),
                                          child: Row(
                                            children: <Widget>[
                                              Icon(Icons.star, color: Colors.orange,),
                                              SizedBox(width: 10,),
                                              Expanded(
                                                child: Text(meanings[index]["definitions"][idx]["definition"], style: TextStyle(
                                                    fontSize: 16
                                                ),),
                                              ),
                                            ],
                                          ),
                                        ),

                                        if(meanings[index]["definitions"][idx]["example"] != null)
                                          Container(
                                            child: Text('Example: ${meanings[index]["definitions"][idx]["example"]}', style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                            ),),
                                            margin: EdgeInsets.only(left:35, right: 20),
                                          ),

                                          if(meanings[index]["definitions"][idx]["synonyms"] != null)
                                          Container(
                                            margin: EdgeInsets.only(left:35, right: 20, top: 16),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("SEE ALSO "),
                                                Wrap(
                                                  children: List.generate(meanings[index]["definitions"][idx]["synonyms"].length, (indx) {
                                                    return Text(meanings[index]["definitions"][idx]["synonyms"][indx] + ", ", style: TextStyle(
                                                      color: Colors.indigo
                                                    ),);
                                                  }),
                                                ),
                                              ],
                                            ),
                                          )
                                      ],
                                    ),
                                  );
                                }
                              )
                            ],
                          ),
                        );
                      }
                    ),
                  ],
                ),
              ),
            )
          );
        }
      );
    }

}

