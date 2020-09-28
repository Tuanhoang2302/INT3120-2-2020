import 'dart:async';
import 'package:flutter/material.dart';

class AppState {
  List<dynamic> listfolder = ["Default"];
  int counter;

  AppState({this.listfolder});

  static AppState fromJson( dynamic json) {
    print(json["listfolder"]);
    return AppState(listfolder: json["listfolder"]);
  }
  dynamic toJson() => {'listfolder': listfolder};

}
