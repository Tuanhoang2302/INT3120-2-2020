import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class SearchBox extends StatefulWidget {
  StreamController streamController;
  Stream stream;

  SearchBox({this.stream, this.streamController});
  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  //String _url = "https://api.dictionaryapi.dev/api/v2/entries/en/kick";
  String _url = "https://api.datamuse.com/words?sp=";
  TextEditingController _controller = TextEditingController();
  StreamController _streamController;
  //Stream stream;
  Timer _debounce;

  _search() async {
    if(_controller.text == null || _controller.text.length == 0) {
      widget.streamController.add(null);
    } else {
      //_streamController.add("waiting");
      Response response = await get(
        _url + _controller.text.trim() + "*&max=4",
      );
      //print(response.statusCode);
      if (response.statusCode == 200) {
        await widget.streamController.add(json.decode(response.body));
        //print(json.decode(response.body));
      } else {
        // If that response was not OK, throw an error.
        throw Exception('Failed to load json data');
      }

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _streamController = StreamController();
    //widget.stream = _streamController.stream;
    print(widget.stream);
  }
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 50,
        margin: EdgeInsets.only(left: 12, bottom: 10, right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.search),
              color: Colors.blue,
              onPressed: _search,
            ),

            Expanded(
              child: TextFormField(
                style: TextStyle(
                  fontSize: 18,
                ),
                controller: _controller,
                onChanged: (String text) {
                  if(_debounce ?.isActive ?? false) {
                    _debounce.cancel();
                  }
                  _debounce = Timer(const Duration(milliseconds: 500), () {
                    _search();
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search for a word",
                  border: InputBorder.none,
                ),

              ),
            ),
          ],
        ),
      ),
    );
  }
}
