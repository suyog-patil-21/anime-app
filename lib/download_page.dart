import 'package:anime_app/models/download_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
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
  var episodeDetails;
  DownIndicator({Key? key, required this.episodeDetails}) : super(key: key);
  @override
  _DownIndicatorState createState() => _DownIndicatorState();
}

class _DownIndicatorState extends State<DownIndicator> {
  // * used for Animation Control

  IconData buttonPP = Icons.pause_rounded;
  // @override
  // void initState() {
  //   super.initState();

  // }

  void onpressed() {
    setState(() {
      if (true) {
        Provider.of<DownloadModal>(context, listen: false)
            .pauseDownload(widget.episodeDetails);
      } else {
        Provider.of<DownloadModal>(context, listen: false)
            .resumeDownload(widget.episodeDetails);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      title: Text(widget.episodeDetails['title']),
      //FIXME : Change the pause and play
      trailing: IconButton(
          onPressed: () async {
            var id = widget.episodeDetails["downloadTaskId"].toString().trim();
            var taskdetails = await FlutterDownloader.loadTasksWithRawQuery(
                query: 'SELECT * FROM task WHERE task_id="' + id + '"');
            print(
                'taskDetails : $taskdetails Task Download : ${taskdetails![0].status}');
          },
          icon: Icon(buttonPP)),

      isThreeLine: true,

      subtitle: Column(
        children: [
          // Text('Downloading Progress : $downloadProgress / 100'),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(widget.episodeDetails["url"]))
        ],
      ),
    ));
  }
}
