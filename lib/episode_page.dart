import 'package:anime_app/common_widgets.dart';
import 'package:anime_app/fetch_details/fetch_titles.dart';
import 'package:flutter/material.dart';

class EpisodesPage extends StatefulWidget {
  String seaonUrl; // url to search number of season
  String seriestitle;

  var key;

  EpisodesPage({required this.seaonUrl, required this.seriestitle, this.key})
      : super(key: key);
  @override
  _EpisodesPageState createState() => _EpisodesPageState();
}

class _EpisodesPageState extends State<EpisodesPage> {
  bool isLoading = false;
  var seasonlisturl = [];
  var seasonInit = 1; //for drop down button inital value set to 1
  List<int> seasonCountlist = []; // if not working use late keyword
  List<Map<String, dynamic>> episodeNoList = [];
  @override
  initState() {
    super.initState();
    fetchList();
    setState(() {
      seasonInit = 1;
    });
  }

  void fetchList() async {
    seasonlisturl = await fetchlist(urlpath: widget.seaonUrl);
    setState(() {
      seasonInit = 1;
      seasonCountlist = List<int>.generate(seasonlisturl.length, (i) => i + 1);
      getEpisode();
    });
  }

  void getEpisode() async {
    episodeNoList = await fetchepisode(
        urlpath: seasonlisturl[seasonInit - 1]['attributes']['href'],
        seasonNum: seasonInit.toString(),
        titleName: widget.seriestitle);
    setState(() {
      isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            tooltip: 'Download Complete Season',
            backgroundColor: Colors.amber,
            onPressed: () {},
            child: const Icon(Icons.cloud_download_rounded)),
        body: CustomScrollView(slivers: [
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: screenSize.height * 0.3,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.seriestitle),
              background: const FlutterLogo(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Episodes List', style: TextStyle(fontSize: 23)),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(4.0)),
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: DropdownButton<int>(
                      dropdownColor: Colors.amber,
                      underline: Container(),
                      items: seasonCountlist
                          .map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text('Sesason $value'),
                        );
                      }).toList(),
                      value: seasonInit,
                      onChanged: (int? newValue) {
                        setState(() {
                          seasonInit = newValue!;
                          isLoading = false;
                        });
                        debugPrint(
                            '\t\t\t>>>>   season number :$seasonInit season url :$seasonlisturl');
                        getEpisode();
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          isLoading == false
              ? SliverToBoxAdapter(
                  child: loadingWidget(width: screenSize.width))
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                  return ListTile(
                      trailing: IconButton(
                        tooltip: 'Download Single Episode',
                        icon: const Icon(Icons.sim_card_download),
                        onPressed: () {
                          // var status = await Permission.storage.request();
                          // if (status.isGranted) {
                          //TODO impliment the Download of single file
                          // final externalDir =
                          //     await getExternalStorageDirectory();

                          // debugPrint('Entering into Download');
                          // final id = await FlutterDownloader.enqueue(
                          //   url:
                          //       "https://firebasestorage.googleapis.com/v0/b/storage-3cff8.appspot.com/o/2020-05-29%2007-18-34.mp4?alt=media&token=841fffde-2b83-430c-87c3-2d2fd658fd41",
                          //   savedDir: externalDir!.path,
                          //   fileName: "download",
                          //   showNotification: true,
                          //   openFileFromNotification: true,
                          // );
                          // } else {
                          //   ScaffoldMessenger.of(context).clearSnackBars();
                          //   ScaffoldMessenger.of(context)
                          //       .showSnackBar(const SnackBar(
                          //           backgroundColor: Colors.redAccent,
                          //           content: Text(
                          //             'Premision Not Granted',
                          //             style: TextStyle(color: Colors.white),
                          //           )));
                          // }
                        },
                      ),
                      tileColor: Colors.grey[900],
                      leading: IconButton(
                        tooltip: 'Play',
                        onPressed: () {
                          debugPrint('hello $index');
                        },
                        icon: const Icon(Icons.play_arrow),
                      ),
                      title: Wrap(children: [
                        Text(
                          '${episodeNoList[index]['title']}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ]));
                }, childCount: episodeNoList.length))
        ]));
  }
}
