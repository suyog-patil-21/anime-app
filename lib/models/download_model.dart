import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadModal extends ChangeNotifier {
  late List<Map<String, dynamic>> _downloadList = [];
  get getDownloadList => _downloadList;

  void addDownload(Map<String, dynamic> item) {
    if (!_downloadList.contains(item)) {
      print('added : item => \n $item');
      _downloadList.add(item);
    }
    notifyListeners();
  }

  void removeDownload(Map<String, dynamic> item) {
    if (_downloadList.isNotEmpty) {
      print('removed : item => \n $item');
      _downloadList.remove(item);
    }
    notifyListeners();
  }
}
// TODO : 1. To Download working
// TODO : 2 To implent video player
// TODO : 3. Add Title(cover) image for the series
