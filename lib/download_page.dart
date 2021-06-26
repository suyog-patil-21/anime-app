import 'package:anime_app/models/download_data_model.dart';
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
        List<MyDownloadTaskInfo> dlist = data.getDownloadList;
        return ListView.builder(
            itemCount: dlist.length,
            itemBuilder: (BuildContext context, index) {
              final item = dlist[index];
              return Dismissible(
                key: Key(item.taskId.toString()),
                onDismissed: (direction) {
                  // Remove the item from the data source.
                  data.removeDownload(item);
                  // Then show a snackbar.
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          '${item.episodeDetails!.title} close downloading')));
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
                child: DownIndicator(details: data.getDownloadList[index]),
              );
            });
      }),
    );
  }
}

class DownIndicator extends StatefulWidget {
  MyDownloadTaskInfo details;
  DownIndicator({Key? key, required this.details}) : super(key: key);
  @override
  _DownIndicatorState createState() => _DownIndicatorState();
}

class _DownIndicatorState extends State<DownIndicator> {
  // * used for Animation Control
  IconData buttonPP = Icons.pause_rounded;
  @override
  void initState() {
    super.initState();
  }

  void onpressed() {
    setState(() {
      if (true) {
        Provider.of<DownloadModal>(context, listen: false)
            .pauseDownload(widget.details);
      } else {
        Provider.of<DownloadModal>(context, listen: false)
            .resumeDownload(widget.details);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      onTap: () {
        FlutterDownloader.open(taskId: widget.details.taskId.toString());
      },
      title: Text(widget.details.episodeDetails!.title.toString()),
      //FIXME : Change the pause and play
      trailing: IconButton(
          onPressed: () async {
            var id = widget.details.taskId.toString().trim();
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
          Wrap(
            spacing: 6.0,
            children: [
              Text('Series :${widget.details.seriestitleName} '),
              Text('Season No :${widget.details.seasonNo} '),
            ],
          ),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                  widget.details.episodeDetails!.attributes!.href.toString()))
        ],
      ),
    ));
  }
}
