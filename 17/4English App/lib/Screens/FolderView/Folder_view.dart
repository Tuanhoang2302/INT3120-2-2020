import 'dart:async';

import 'package:english_app/Constant/delete_alert_dialog.dart';
import 'package:english_app/Model/model.dart';
import 'package:english_app/Screens/Dictionary/cards.dart';
import 'package:english_app/Screens/FolderView/saved_word_list.dart';
import 'package:english_app/Services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:english_app/Redux/Actions/actions.dart';
import 'package:redux/redux.dart';
class FolderView extends StatefulWidget {
  @override
  _FolderViewState createState() => _FolderViewState();
}

class _FolderViewState extends State<FolderView> {
  var listForder = ['Default'];
  StreamController _streamController;
  Stream _stream;
  TextEditingController controllerDialog = TextEditingController();
  TextEditingController controllerModifyDialog = TextEditingController();

  createAlertModifyName(BuildContext context, int index) {
    return showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: Text("Rename"),
          content: TextField(
            controller: controllerModifyDialog,
          ),
          actions: <Widget>[
            StoreConnector<AppState, Store>(
                converter: (store) => store,
                builder: (context, store) {
                  return MaterialButton(
                    elevation: 5.0,
                    child: Text(
                      "Save",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16
                      ),
                    ),
                    onPressed: () async {
                      store.dispatch(UpdateFolder(index: index, newname: controllerModifyDialog.text));
                      Navigator.of(context).pop(controllerModifyDialog.text.toString());
                      controllerModifyDialog.text = "";
                    },
                  );
                }
            )
          ],
        );
    });
  }

  createAlertDialog(BuildContext context) {
    return showDialog(context: context, builder: (context) {
      return AlertDialog(

        title: Text("New Folder"),
        content: TextField(
          controller: controllerDialog,
        ),
        actions: <Widget>[
          StoreConnector<AppState, Store>(
            converter: (store) => store,
            builder: (context, store) {
              return MaterialButton(
                elevation: 5.0,
                child: Text(
                  "Save",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16
                  ),
                ),
                onPressed: () async {
                  store.dispatch(AddFolder(item: "${controllerDialog.text}"));
                  Navigator.of(context).pop(controllerDialog.text.toString());
                  controllerDialog.text = "";
                },
              );
            }
          )
        ],
      );
    });
  }

  deleteAlertDialog(BuildContext context, String folder, Store store, int index) {
    return showDialog(context: context, builder: (context) {
      return DeleteAlertDialog(folder: folder, store: store, index: index,);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _streamController = StreamController();
    _stream = _streamController.stream;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "Vocabulary folder",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.all(8),
            child: FlatButton(
              onPressed: () {
                createAlertDialog(context);
              },
              child: Column(
                children: <Widget>[
                  Icon(Icons.create_new_folder),
                  Text(
                    "New Folder",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),

      body: StreamBuilder(
        stream: _stream,
        builder: (BuildContext cxt, AsyncSnapshot snapshot) {
          return StoreConnector<AppState, Store>(
            converter: (store) => store,
            builder: (context, store) {
              return ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: store.state.listfolder.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => SavedWordList(folder: "${store.state.listfolder[index]}")
                        ));
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.folder, color: Colors.orangeAccent,),
                              Container(
                                margin: EdgeInsets.only(left: 16),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    "${store.state.listfolder[index]}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                              if(index != 0)
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.create),
                                    color: Colors.brown,
                                    onPressed: () {
                                      createAlertModifyName(context, index);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: () {
                                      deleteAlertDialog(context, store.state.listfolder[index], store, index);
                                      //DatabaseService("save_words").deleteSavedWord_WhenDeleteFolder("${store.state.listfolder[index]}");
                                      //store.dispatch(RemoveFolder(index: index));
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
              );
            }
          );
        }
      ),
    );
  }
}
