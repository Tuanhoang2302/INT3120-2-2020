
import 'package:english_app/Model/model.dart';
import 'package:english_app/Redux/Actions/actions.dart';

AppState reducer(AppState state, dynamic action) {
  return AppState(
    listfolder: folderReducer(state.listfolder, action),
  );
}

List<dynamic> folderReducer(List<dynamic> state, dynamic action) {
  if(action is AddFolder) {
    return []
        ..addAll(state)
        ..add(action.item);
  }

  if(action is RemoveFolder){
    if(action.index == 0) {
      return state;
    }
    return []
        ..addAll(state)
        ..removeAt(action.index);
  }

  if(action is UpdateFolder) {
    state[action.index] = action.newname;
    return []..addAll(state);
  }

  return state;
}