import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_app/blocs/rss_feed_bloc.dart';
import 'package:workmanager/workmanager.dart';
import 'app.dart';

const myTask = "syncWithTheBackEnd";

void callbackDispatcher() {
  Workmanager().executeTask((task, inputdata) async {
    switch (task) {
      case myTask:
        await Firebase.initializeApp();
        await RSSFEEDBloc().newArticleUpload();
        break;
    }

    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Workmanager().initialize(callbackDispatcher);
  Workmanager().registerPeriodicTask(
    "2",
    myTask,
    frequency: Duration(minutes: 15),
  );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark));
  runApp(EasyLocalization(
    supportedLocales: [Locale('en'), Locale('es'), Locale('ar')],
    path: 'assets/translations',
    fallbackLocale: Locale('en'),
    startLocale: Locale('en'),
    useOnlyLangCode: true,
    child: MyApp(),
  ));
}
