import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_app/Model/category.dart';
import 'package:english_app/Model/savedWord.dart';

class DatabaseService {
  CollectionReference Collection;

  DatabaseService(String name) {
    Collection = FirebaseFirestore.instance.collection(name);
  }

  Future addNewSavedWord(SavedWord savedWord) async {
    return await Collection.add({
      'word': savedWord.word,
      'folder': savedWord.folder,
      'note': savedWord.note
    }).then((value) => print("user_add")).catchError((Error) => print(Error));
  }

  Future<void> deleteSavedWord(String id) async {
    return await Collection.doc(id)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  Future<void> updateSavedWord(String id, SavedWord savedWord) async {
    return await Collection.doc(id)
        .update({
          'word': savedWord.word,
          'folder': savedWord.folder,
          'note': savedWord.note
        })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> deleteSavedWord_WhenDeleteFolder(String folder) async {
    //print(folder);
    return await Collection.where("folder", isEqualTo: folder)
        .get()
        .then((snapshot) {
          for (DocumentSnapshot doc in snapshot.docs) {
            doc.reference.delete();
          }
        })
        .then((value) => print("All User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }
}
