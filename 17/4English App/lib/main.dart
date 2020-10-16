import 'dart:io';
import 'package:device_preview/device_preview.dart';
import 'package:english_app/Model/model.dart';
import 'package:english_app/Redux/Reducers/reducers.dart';
import 'package:english_app/Screens/Dictionary/Dictionary.dart';
import 'package:english_app/Screens/FolderView/Folder_view.dart';
import 'package:english_app/Screens/Home/Home.dart';
import 'package:english_app/Screens/WordView/Word_view.dart';
import 'package:english_app/Screens/WordView/review_saved_word.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:english_app/globles.dart' as globals;
import 'package:responsive_builder/responsive_builder.dart';

Future<File> get _localFile async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  File ourFile = new File('$path/hello.json');
  try{
    print(ourFile.readAsStringSync());

    //Map<String, dynamic> jsonContent = jsonDecode(ourFile.readAsStringSync());
    //ourFile.writeAsStringSync('{"listfolder": ["Default"]}');
  }catch(e) {
    print(e);
  }

  return ourFile;
}

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final persistor = Persistor<AppState>(
    storage: FileStorage(await _localFile),
    serializer: JsonSerializer<AppState>(AppState.fromJson),
    debug: true,
  );

  var initialState;
  try {
    initialState = await persistor.load();
    //print(initialState);
  }catch(e){
    print("Hello");
    initialState = null;
  }

  final store = Store<AppState>(
      reducer,
      initialState: initialState ?? AppState(),
      middleware: [persistor.createMiddleware()]
  );

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MyApp(store: store,),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;
  String hello;
  MyApp({Key key, this.store, this.hello}) : super(key: key);
  var screenSize;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context){
    screenSize = MediaQuery.of(context).size;
    globals.screenSize = screenSize;
    globals.ratio = screenSize.width / 375;
    double paddingValue = getValueForScreenType<double>(
      context: context,
      mobile: 16,
      tablet: 30,
    );
    globals.padding = paddingValue;
    globals.iconSize = 24 * globals.ratio;
    globals.ratioHeight = screenSize.height / 667;

    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        //locale: DevicePreview.of(context).locale,
        builder: DevicePreview.appBuilder,
        //home: Home(),
        onGenerateRoute: (setting) {
          if(setting.name == "/wordview"){
            String s = setting.arguments;
            return MaterialPageRoute(
              builder: (context) => WordView(word: s,),
            );
          }
          if(setting.name == '/reviewSavedWord') {
            print("GG");
            String s = setting.arguments;
            return MaterialPageRoute(
              builder: (context) => ReviewSavedWord(word: s,),
            );
          }
        },
        initialRoute: '/',
        routes: {
          '/': (context) => Home(),
          '/dictionary': (context) => Dictionary(),
          '/saveword': (context) => FolderView(),
          //'/reviewSavedWord': (context) => ReviewSavedWord(),
        },
      ),
    );
  }
}