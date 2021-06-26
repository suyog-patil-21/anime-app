import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:anime_app/models/download_data_model.dart';
import 'package:anime_app/models/episode_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

class DownloadModal extends ChangeNotifier {
  List<MyDownloadTaskInfo> _downloadList = [];

  static bool storagePermission = false;
  get getDownloadList => _downloadList;
  void addDownload(MyDownloadTaskInfo item) async {
    if (!_downloadList.contains(item)) {
      print('added : item => \n $item');
      _downloadList
          .add(MyDownloadTaskInfo(episodeDetails: item.episodeDetails));
      if (storagePermission) {
        final externalDir = await _findLocalPath();
        // print(
        //     'file Present or not ${io.File(externalDir.toString() + Platform.pathSeparator + item['title'])}'); // ! : /storage/emulated/0/Android/data/com.example.anime_app/files/08 The Smell of Enchanting Blood.mp4

        // print(
        //     'File check Present or not : ${await io.File('${io.File(externalDir.toString() + Platform.pathSeparator + item['title'])}').exists()}');

        _downloadList.last.taskId = await FlutterDownloader.enqueue(
          // url: 'https://source.unsplash.com/collection/190727/1600x900',
          url: item.episodeDetails!.attributes!.href.toString(),
          fileName: item.episodeDetails!.title,
          savedDir: externalDir.toString(),
          showNotification: true,
          openFileFromNotification: true,
        );
        // debugPrint(
        //     'what is did : $taskid  \n runtimetype : ${taskid.runtimeType}'); // ! : some random numebr, Runtimetype  =string
        // item.taskId = taskid.toString();
        // debugPrint(' download Status id  : ${taskid.toString()}');
      } else {
        print('Storage Permission Denied OR File May Exisits');
        // ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('Storage Permission Denied')));
      }
    }
    notifyListeners();
  }

  void pauseDownload(MyDownloadTaskInfo item) async {
    await FlutterDownloader.pause(taskId: item.taskId.toString());
  }

  void resumeDownload(MyDownloadTaskInfo item) async {
    String? newTaskId =
        await FlutterDownloader.resume(taskId: item.taskId.toString());
    item.taskId = newTaskId;
  }

  void removeDownload(MyDownloadTaskInfo item) async {
    if (_downloadList.isNotEmpty && _downloadList.contains(item)) {
      debugPrint('removed : item => \n ${item.episodeDetails!.title}');
      _downloadList.remove(item);
      await FlutterDownloader.remove(
          taskId: item.taskId.toString(),
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
