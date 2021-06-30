import 'package:anime_app/home_page.dart';
import 'package:flutter/material.dart';
import 'package:anime_app/models/download_model.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );
  runApp(ChangeNotifierProvider(
      create: (BuildContext context) => DownloadModal(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Anime Download & View',
      darkTheme: ThemeData.dark(),
      theme:
          ThemeData(brightness: Brightness.dark, primarySwatch: Colors.orange),
      home: SafeArea(child: MyHomePage()),
    );
  }
}
