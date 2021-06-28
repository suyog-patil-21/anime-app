import 'dart:isolate';
import 'dart:ui';

import 'package:anime_app/Series_page.dart';
import 'package:anime_app/common_widgets.dart';
import 'package:anime_app/download_page.dart';
import 'package:anime_app/models/download_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';

final List<String> alpha = [
  'B',
  'C',
  'D',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'Y',
  'Z'
];

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    //register a send port for the other isolates
    IsolateNameServer.registerPortWithName(
        receivePort.sendPort, "Anime_download");
    //Listening for the data is comming other isolataes

    // for downlaod callBack
    FlutterDownloader.registerCallback(downloadCallback);
  }

  static downloadCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort? sendPort = IsolateNameServer.lookupPortByName("Anime_download");

    ///ssending the data
    sendPort!.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    _getStoragePermission();
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                tooltip: 'Show Downloads',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DownloadPage()));
                },
                icon: const Icon(
                  Icons.download_rounded,
                  color: Colors.white,
                ))
          ],
          title: const Text('Anime'),
          centerTitle: true,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) => GridView.builder(
              itemCount: alpha.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: constraints.maxWidth < 600 ? 4 : 8),
              itemBuilder: (BuildContext context, int index) {
                return FlatButton(
                    child: customAlfa(alpha[index]),
                    onPressed: () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return SeriesPage(
                            titleBName: alpha[index],
                          );
                        })));
              }),
        ));
  }

  // * for getting storage permission details
  Future _getStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      DownloadModal.storagePermission = true;
      print('Storage Permission : ${DownloadModal.storagePermission}');
    }
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    receivePort.close();
    super.dispose();
  }

  void _unbindBackgroundIsolate() async {
    await FlutterDownloader.cancelAll();
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }
}

Widget customAlfa(var item) {
  return Center(
    child: CircleAvatar(
      radius: 26.0,
      child: Text(
        item,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
