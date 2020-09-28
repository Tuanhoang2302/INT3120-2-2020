import 'dart:async';
import 'dart:convert';

import 'package:english_app/Screens/Dictionary/main_screen_dictionary.dart';
import 'package:english_app/Screens/Dictionary/suggestion_search_panel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Dictionary extends StatefulWidget {
  @override
  _DictionaryState createState() => _DictionaryState();
}

class _DictionaryState extends State<Dictionary> {
  //String _url = "https://api.dictionaryapi.dev/api/v2/entries/en/kick";
  String _url = "https://api.datamuse.com/words?sp=";
  TextEditingController _controller = TextEditingController();
  StreamController _streamController;
  Stream _stream;
  Timer _debounce;
  FocusNode _focus = new FocusNode();
  bool onfocus = false;

  _search() async {
    if(_controller.text == null || _controller.text.length == 0) {
      _streamController.add(null);
    } else {
      //_streamController.add("waiting");
      Response response = await get(
        _url + _controller.text.trim() + "*&max=4",
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        await _streamController.add(json.decode(response.body));
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
    _stream = _streamController.stream;
    _focus.addListener(() { setState(() {
      onfocus = !onfocus;
      print(onfocus);
    });;});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    )
  }
}
