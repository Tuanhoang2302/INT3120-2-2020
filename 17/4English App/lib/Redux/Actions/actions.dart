class AddFolder {
  String item;
  AddFolder({this.item});
}

class RemoveFolder {
  int index;
  RemoveFolder({this.index});
}

class UpdateFolder {
  int index;
  String newname;
  UpdateFolder({this.index, this.newname});
}

