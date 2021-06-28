import 'dart:convert';

import 'package:anime_app/common_widgets.dart';
import 'package:anime_app/models/dataconverter_data_model.dart';
import 'package:anime_app/models/download_data_model.dart';
import 'package:anime_app/models/download_model.dart';
import 'package:anime_app/fetch_details/fetch_titles.dart';
import 'package:anime_app/video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EpisodesPage extends StatefulWidget {
  String seaonUrl; // url to search number of season
  String seriestitle;

  EpisodesPage({required this.seaonUrl, required this.seriestitle, Key? key})
      : super(key: key);
  @override
  _EpisodesPageState createState() => _EpisodesPageState();
}

class _EpisodesPageState extends State<EpisodesPage> {
  bool isLoading = false;
  var seasonlisturl = [];
  var seasonInit = 1; //? for drop down button inital value set to 1
  List<int> seasonCountlist = []; //! if not working use late keyword
  List<MyDownloadTaskInfo> episodeNoList = [];
  @override
  initState() {
    super.initState();
    fetchList();
    setState(() {
      seasonInit = 1;
    });
  }

  void fetchList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tempPrefSeasonList = [];
    if (!prefs.containsKey('${widget.seriestitle}+seasonlisturl')) {
      seasonlisturl = await fetchlist(urlpath: widget.seaonUrl);
      for (var item in seasonlisturl) {
        tempPrefSeasonList.add(json.encode(item));
      }
      prefs.setStringList(
          '${widget.seriestitle}+seasonlisturl', tempPrefSeasonList);
    } else {
      tempPrefSeasonList =
          prefs.getStringList('${widget.seriestitle}+seasonlisturl')!;
      for (var item in tempPrefSeasonList) {
        seasonlisturl.add(json.decode(item));
      }
    }
    setState(() {
      seasonInit = 1;
      seasonCountlist = List<int>.generate(seasonlisturl.length, (i) => i + 1);
      getEpisode();
    });
  }

  void getEpisode() async {
    episodeNoList.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tempPrefSeasonEpisodeList = [];
    if (!prefs.containsKey('${widget.seriestitle}+${seasonInit - 1}')) {
      var fetchepisodeNoList = await fetchepisode(
          urlpath: seasonlisturl[seasonInit - 1]['attributes']['href']);
      // * storing value to the episodenoList
      fetchepisodeNoList.forEach((item) {
        tempPrefSeasonEpisodeList.add(json.encode(item));
        episodeNoList.add(MyDownloadTaskInfo(
            episodeDetails: DataConverter.fromMap(item),
            seasonNo: seasonInit,
            seriestitleName: widget.seriestitle));
      });
      prefs.setStringList(
          '${widget.seriestitle}+${seasonInit - 1}', tempPrefSeasonEpisodeList);
    } else {
      tempPrefSeasonEpisodeList =
          prefs.getStringList('${widget.seriestitle}+${seasonInit - 1}')!;
      for (var item in tempPrefSeasonEpisodeList) {
        episodeNoList.add(MyDownloadTaskInfo(
            episodeDetails: DataConverter.fromMap(json.decode(item)),
            seasonNo: seasonInit,
            seriestitleName: widget.seriestitle));
      }
    }

    // print('\n\n getEpisode from: ${episodeNoList[0].episodeDetails!.title} ');
    setState(() {
      isLoading = true;
    });
  }

  void setTruePlayFile(int index) async {}

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
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
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
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
                  items:
                      seasonCountlist.map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('Season $value'),
                    );
                  }).toList(),
                  value: seasonInit,
                  onChanged: (int? newValue) {
                    setState(() {
                      seasonInit = newValue!;
                      isLoading = false;
                    });
                    // debugPrint(
                    // '\t\t\t>>>>   season number :$seasonInit season url :$seasonlisturl');
                    getEpisode();
                  },
                ),
              )
            ],
          ),
        ),
      ),
      isLoading == false
          ? SliverToBoxAdapter(child: loadingWidget(width: screenSize.width))
          : SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
              return ListTile(
                  trailing: IconButton(
                    tooltip: 'Download Single Episode',
                    icon: const Icon(Icons.sim_card_download),
                    onPressed: () async {
                      debugPrint(
                          'single download pressed ${episodeNoList[index].episodeDetails!.title}');
                      var temp = await pureElement(
                          episodeNoList[index]
                              .episodeDetails!
                              .attributes!
                              .href
                              .toString(),
                          widget.seriestitle,
                          seasonInit.toString());

                      episodeNoList[index].downloadContent =
                          DataConverter.fromPureMap(temp);
                      var addsingle =
                          Provider.of<DownloadModal>(context, listen: false);
                      addsingle.addDownload(episodeNoList[index]);
                    },
                  ),
                  tileColor: Colors.grey[900],
                  leading: IconButton(
                    tooltip: 'Play',
                    icon: const Icon(Icons.play_arrow),
                    onPressed: () async {
                      var temp = await pureElement(
                          episodeNoList[index]
                              .episodeDetails!
                              .attributes!
                              .href
                              .toString(),
                          widget.seriestitle,
                          seasonInit.toString());

                      episodeNoList[index].downloadContent =
                          DataConverter.fromPureMap(temp);
                      // debugPrint(
                      //     'playing the Video ${episodeNoList[index].downloadContent!.attributes!.href}');
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PlayMyVideo(
                              videoUrl: episodeNoList[index]
                                  .downloadContent!
                                  .attributes!
                                  .href
                                  .toString())));
                    },
                  ),
                  title: Wrap(children: [
                    Text(
                      episodeNoList[index].episodeDetails!.title.toString(),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ]));
            }, childCount: episodeNoList.length))
    ]));
  }
}
