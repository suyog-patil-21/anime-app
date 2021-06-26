import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

class DownloadModal extends ChangeNotifier {
  List<Map<String, dynamic>> _downloadList = [];

  static bool storagePermission = false;
  get getDownloadList => _downloadList;
  void addDownload(Map<String, dynamic> item) async {
    if (!_downloadList.contains(item)) {
      print('added : item => \n $item');
      _downloadList.add(item);
      if (storagePermission) {
        final externalDir = await _findLocalPath();
        // print(
        //     'file Present or not ${io.File(externalDir.toString() + Platform.pathSeparator + item['title'])}'); // ! : /storage/emulated/0/Android/data/com.example.anime_app/files/08 The Smell of Enchanting Blood.mp4

        // print(
        //     'File check Present or not : ${await io.File('${io.File(externalDir.toString() + Platform.pathSeparator + item['title'])}').exists()}');

        var did = await FlutterDownloader.enqueue(
          // url: 'https://source.unsplash.com/collection/190727/1600x900',
          url: item['url'],
          fileName: item['title'],
          savedDir: externalDir.toString(),
          showNotification: true,
          openFileFromNotification: true,
        );
        debugPrint(
            'what is did : $did  \n runtimetype : ${did.runtimeType}'); // ! : some random numebr, Runtimetype  =string
        item['downloadTaskId'] = did.toString();
        debugPrint(' download Status id  : ${did.toString()}');
      } else {
        print('Storage Permission Denied OR File May Exisits');
        // ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('Storage Permission Denied')));
      }
    }
    notifyListeners();
  }

  void pauseDownload(Map<String, dynamic> item) async {
    await FlutterDownloader.pause(taskId: item['downloadTaskId']);
  }

  void resumeDownload(Map<String, dynamic> item) async {
    String? newTaskId =
        await FlutterDownloader.resume(taskId: item['downloadTaskId']);
    item['downloadTaskId'] = newTaskId;
  }

  void removeDownload(Map<String, dynamic> item) async {
    if (_downloadList.isNotEmpty && _downloadList.contains(item)) {
      debugPrint('removed : item => \n $item');
      _downloadList.remove(item);
      var remove = await FlutterDownloader.remove(
          taskId: item['downloadTaskId'],
          shouldDeleteContent:
              true); //! FIXME : check shouldeleteContent parameter
      debugPrint('Downloading stoped and Removed Filed from storage');
    }
    notifyListeners();
  }

  // ? returns the path fro saving the file
  Future<String?> _findLocalPath() async {
    final Directory? directory;
    if (Platform.isAndroid == true) {
      directory = await getExternalStorageDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }
    return directory?.path;
  }

  void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    print(
        'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');

    final SendPort send = IsolateNameServer.lookupPortByName('Anime_download')!;
    send.send([id, status, progress]);
  }
}

// TODO : 1. To Download working
// // TODO : * access permission first 'prmission_handler'
// // TODO : * access path first second 'path_provider'
// // TODO :  then do the downloading part third 'flutter_downloader'
// TODO : Fix the download

// TODO : using shared Preferences
// TODO : 2 To implent video player
// TODO : 3. Add Title(cover) image for the series
