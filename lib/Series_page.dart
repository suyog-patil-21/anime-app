import 'dart:convert';
import 'package:anime_app/episode_page.dart';
import 'package:anime_app/fetch_details/fetch_titles.dart';
import 'package:anime_app/fetch_details/fetch_image.dart';
import 'package:anime_app/models/dataconverter_data_model.dart';

import 'package:anime_app/models/series_data_model.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'common_widgets.dart';

class SeriesPage extends StatefulWidget {
  var titleBName;
  SeriesPage({required this.titleBName, Key? key}) : super(key: key);

  @override
  _SeriesPageState createState() => _SeriesPageState();
}

class _SeriesPageState extends State<SeriesPage> {
  bool isLoading = false;
  List<Image> imagelist = [];
  List<SeriesDetails>? seriallist = []; // ? for UI element
  @override
  void initState() {
    super.initState();
    getdata();
  }

  void fetchImages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tempprefimages = [];
    imagelist.clear();
    if (!prefs.containsKey('${widget.titleBName}+images')) {
      for (var item in seriallist!) {
        var temp = await getSeriesCoverImage(item.data!.title.toString());
        item.imageurl = temp;
        // Image.network(src)
        tempprefimages.add(temp);
        imagelist.add(Image.network(
          temp,
          fit: BoxFit.cover,
        ));
      }
      prefs.setStringList('${widget.titleBName}+images', tempprefimages);
    } else {
      tempprefimages = prefs.getStringList('${widget.titleBName}+images')!;
      for (int i = 0; i < tempprefimages.length; i++) {
        seriallist![i].imageurl = tempprefimages[i];
        imagelist.add(Image.network(
          tempprefimages[i],
          fit: BoxFit.cover,
        ));
      }
    }

    setState(() {
      debugPrint('Series Count = ${seriallist!.length}');
      isLoading = true;
    });
  }

  void getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tempprefdata = [];
    if (!prefs.containsKey('${widget.titleBName}')) {
      List<Map<String, dynamic>> fetchseriallist;
      fetchseriallist = await fetchlist(urlpath: widget.titleBName);
      for (var item in fetchseriallist) {
        tempprefdata.add(json.encode(item));
        seriallist!.add(SeriesDetails(data: DataConverter.fromMap(item)));
      }
      prefs.setStringList('${widget.titleBName}', tempprefdata);
    } else {
      tempprefdata = prefs.getStringList('${widget.titleBName}')!;
      for (var item in tempprefdata) {
        seriallist!
            .add(SeriesDetails(data: DataConverter.fromMap(json.decode(item))));
      }
    }
    // print('fetchseriallist: \n ${fetchseriallist}');
    fetchImages();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.titleBName + ' - Series Page'),
      ),
      body: isLoading == false
          ? loadingWidget(width: screenSize.width)
          : Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisExtent: 200.0,
                  ),
                  itemCount: seriallist!.length,
                  itemBuilder: (context, index) {
                    return FlatButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => EpisodesPage(
                                    imageurl:
                                        seriallist![index].imageurl.toString(),
                                    seaonUrl: seriallist![index]
                                        .data!
                                        .attributes!
                                        .href
                                        .toString(),
                                    seriestitle: seriallist![index]
                                        .data!
                                        .title
                                        .toString(),
                                  )));
                        },
                        child: Container(
                          padding: EdgeInsets.zero,
                          height: double.infinity,
                          width: double.infinity,
                          child: Column(
                            children: [
                              SizedBox(
                                  height: 120.0,
                                  width: double.infinity,
                                  child: imagelist[index] == null
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : imagelist[index]),
                              // const FlutterLogo(
                              //   size: 90.0,
                              // ),
                              const Divider(
                                thickness: 0.2,
                              ),
                              Wrap(children: [
                                Text(seriallist![index].data!.title.toString(),
                                    overflow: TextOverflow.fade, maxLines: 2)
                              ])
                            ],
                          ),
                        ));
                  })),
    );
  }
}

// Images file
