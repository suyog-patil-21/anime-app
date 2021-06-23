import 'package:anime_app/models/download_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class DownloadPage extends StatefulWidget {
  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloads'),
        centerTitle: true,
      ),
      body: Consumer<DownloadModal>(builder: (context, data, child) {
        return ListView.builder(
            itemCount: data.getDownloadList.length,
            itemBuilder: (BuildContext context, index) {
              final item = data.getDownloadList[index];
              return Dismissible(
                key: Key(item['title']),
                onDismissed: (direction) {
                  // Remove the item from the data source.
                  data.removeDownload(item);
                  // Then show a snackbar.
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('${item["title"]} close download')));
                },
                // Show a red background as the item is swiped away.
                background: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    color: Colors.blueGrey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.delete_forever_rounded,
                        ),
                        const Icon(
                          Icons.delete_forever_rounded,
                        ),
                      ],
                    )),
                child:
                    DownIndicator(episodeDetails: data.getDownloadList[index]),
              );
            });
      }),
    );
  }
}

class DownIndicator extends StatefulWidget {
  DownIndicator({Key? key, required this.episodeDetails}) : super(key: key);
  var episodeDetails;
  @override
  _DownIndicatorState createState() => _DownIndicatorState();
}

class _DownIndicatorState extends State<DownIndicator>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool isDownloading = false;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
  }

  void _handleOnPressed() async {
    setState(() {
      isDownloading = !isDownloading;
      isDownloading
          ? _animationController.forward()
          : _animationController.reverse();
    });
    // final status = await Permission.storage.request();

    // if (status.isGranted) {
    //   final externalDir = await getExternalStorageDirectory();

    //   final id = await FlutterDownloader.enqueue(
    //     url:
    //         "https://firebasestorage.googleapis.com/v0/b/storage-3cff8.appspot.com/o/2020-05-29%2007-18-34.mp4?alt=media&token=841fffde-2b83-430c-87c3-2d2fd658fd41",
    //     savedDir: externalDir!.path + "/Download",
    //     // fileName: "Download",
    //     showNotification: true,
    //     openFileFromNotification: true,
    //   );
    // } else {
    //   print("Permission deined");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      title: Text(widget.episodeDetails['title']),
      //FIXME : Change the pause and play
      trailing: IconButton(
        onPressed: () => _handleOnPressed(),
        icon: AnimatedIcon(
          icon: AnimatedIcons.pause_play,
          progress: _animationController,
        ),
      ),
      // IconButton(
      //     onPressed: () {}, icon: const Icon(Icons.clear_rounded)),
      subtitle: Text('Show Progress\n${widget.episodeDetails["url"]}'),
    ));
  }
}
