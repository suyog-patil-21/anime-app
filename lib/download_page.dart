import 'dart:isolate';

import 'package:anime_app/common_widgets.dart';
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
                key: Key(item.downloadContent!.title.toString()),
                onDismissed: (direction) {
                  // Remove the item from the data source.
                  data.removeDownload(item);
                  // Then show a snackbar.
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          '${item.downloadContent!.title} close downloading')));
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
                child: DownIndicator(details: item),
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
  IconData buttonPP = Icons.pause_rounded;
  bool pp = true;
  @override
  void initState() {
    super.initState();
    print('inistate working at start');
// ! FIXME : recieverPort : to Update the file
    /*  if (mounted) {
      receivePort.listen((dynamic data) {
        String id = data[0];
        DownloadTaskStatus status = data[1];
        int progress = data[2];
        print('init Progress : $progress initState Status : $status ');
        if (widget.details.taskId == id) {
          setState(() {
            widget.details.status = status;
            widget.details.progress = progress;
          });
        }
      });
    } */
    print('inistate working at end');
  }

  void onpressed() {
    print(
        'Widget details updated or Not check : ${widget.details.status}, ${widget.details.taskId}, ${widget.details.progress}');
    setState(() {
      if (pp) {
        buttonPP = Icons.play_arrow_rounded;
        Provider.of<DownloadModal>(context, listen: false)
            .pauseDownload(widget.details);
      } else {
        buttonPP = Icons.pause_rounded;
        Provider.of<DownloadModal>(context, listen: false)
            .resumeDownload(widget.details);
      }
    });
    pp = !pp;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      leading: const Icon(
        Icons.file_copy_rounded,
        size: 40.0,
      ),
      onTap: () async {
        if (!(await FlutterDownloader.open(
            taskId: widget.details.taskId.toString()))) {
          Scaffold.of(context).showSnackBar(const SnackBar(
              content: Text("File can't be Open While Downloading")));
        } else {
          buttonPP = Icons.open_in_browser_rounded;
        }
      },
      title: Text(widget.details.downloadContent!.title.toString()),
      //FIXME : Change the pause and play
      trailing: IconButton(onPressed: onpressed, icon: Icon(buttonPP)),

      isThreeLine: true,

      subtitle: Column(
        children: [
          // Text('Downloading: ${widget.details.progress}% ',
          // style: const TextStyle(color: Colors.lightGreen)),
          Wrap(
            spacing: 8.0,
            children: [
              Text('Series :${widget.details.seriestitleName} '),
              Text('Season No :${widget.details.seasonNo} '),
            ],
          ),
          Text(widget.details.downloadContent!.attributes!.href.toString(),
              overflow: TextOverflow.ellipsis, maxLines: 1)
        ],
      ),
    ));
  }
}
