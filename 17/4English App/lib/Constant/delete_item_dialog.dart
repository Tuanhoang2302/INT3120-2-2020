import 'package:english_app/Redux/Actions/actions.dart';
import 'package:english_app/Services/database.dart';
import 'package:english_app/globles.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class DeleteAlertDialog extends StatelessWidget {
  String id;
  String folder;
  Store store;
  int index;
  DeleteAlertDialog({this.id, this.folder, this.store, this.index});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: 130 * ratio,
        child: Column(
          children: [
            if(id != null)
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 16),
                child: Text(
                  "Are you sure to delete this word?", style: TextStyle(
                    fontSize: 16* ratio,
                    fontWeight: FontWeight.w500
                ),),
              ),
            ),

            if(folder!= null)
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.only(top: 16),
                child: Text(
                  "Are you sure to delete this folder?", style: TextStyle(
                    fontSize: 16* ratio,
                    fontWeight: FontWeight.w500
                ),),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Text("CANCEL", style: TextStyle(
                        color: Colors.black54,
                        fontSize: 17
                    ),),
                    color: Colors.grey[300],
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  if(id != null)
                  FlatButton(
                    child: Text("DELETE", style: TextStyle(
                        color: Colors.white,
                        fontSize: 17
                    ),),
                    color: Colors.blue,
                    onPressed: () {
                      DatabaseService('save_words').deleteSavedWord(id);
                      Navigator.of(context).pop();
                    },
                  ),

                  if(folder != null)
                  FlatButton(
                    child: Text("DELETE", style: TextStyle(
                        color: Colors.white,
                        fontSize: 17
                    ),),
                    color: Colors.blue,
                    onPressed: () {
                      DatabaseService("save_words").deleteSavedWord_WhenDeleteFolder("${store.state.listfolder[index]}");
                      store.dispatch(RemoveFolder(index: index));
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),

    );
  }

}