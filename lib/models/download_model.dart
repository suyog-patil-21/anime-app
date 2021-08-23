import 'dart:io';

import 'package:anime_app/fetch_details/fetch_image.dart';
import 'package:anime_app/models/download_data_model.dart';
import 'package:anime_app/models/series_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

class DownloadModal extends ChangeNotifier {
  List<MyDownloadTaskInfo> _downloadList = [];
  static bool storagePermission = false;
  List<MyDownloadTaskInfo> get getDownloadList => _downloadList;
  void addDownload(MyDownloadTaskInfo item) async {
    if (!_downloadList.contains(item)) {
      print('added : item => \n ${item.downloadContent!.title}');
      _downloadList.add(item);
      if (storagePermission) {
        final externalDir = await _findLocalPath();
        debugPrint(
            '******** custompaths +++++ ==>> ${item.downloadContent!.attributes!.href.toString()}');
        item.taskId = await FlutterDownloader.enqueue(
          // url: 'https://source.unsplash.com/collection/190727/1600x900',
          url: item.downloadContent!.attributes!.href.toString(),
          fileName: item.downloadContent!.title,
          savedDir: externalDir.toString(),
          showNotification: true,
          openFileFromNotification: true,
        );
      } else {
        debugPrint('Storage Permission Denied OR File May Exisits');
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
      debugPrint('removed : item => \n ${item.downloadContent!.title}');
      _downloadList.remove(item);
      await FlutterDownloader.remove(
          taskId: item.taskId.toString(), shouldDeleteContent: true);
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
}
// TODO : 4. To Download working
// TODO :    Progress for download only working for single download
// TODO :    change pause play
