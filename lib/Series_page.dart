import 'package:anime_app/episode_page.dart';
import 'package:anime_app/fetch_details/fetch_titles.dart';
import 'package:flutter/material.dart';

import 'common_widgets.dart';

class SeriesPage extends StatefulWidget {
  var key;

  var titleBName;

  SeriesPage({required this.titleBName, this.key}) : super(key: key);

  @override
  _SeriesPageState createState() => _SeriesPageState();
}

class _SeriesPageState extends State<SeriesPage> {
  bool isLoading = false;
  List<Map<String, dynamic>> seriallist = [];
  @override
  void initState() {
    super.initState();
    getdata();
  }

  void getdata() async {
    seriallist =
        await fetchlist(urlpath: widget.titleBName); // sn = total no of series
    setState(() {
      print('Series Count = ${seriallist.length}');
      isLoading = true;
    });
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisExtent: 222.0,
                  ),
                  itemCount: seriallist.length,
                  itemBuilder: (context, index) {
                    return FlatButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => EpisodesPage(
                                    seaonUrl: seriallist[index]['attributes']
                                        ['href'],
                                    seriestitle: seriallist[index]['title'],
                                  )));
                        },
                        child:
                            titleBanner(titleName: seriallist[index]['title']));
                  })),
    );
  }

  Widget titleBanner({required String titleName}) {
    return Container(
      child: Column(
        children: [
          // Image.network(
          //   'https://picsum.photos/250?image=9',
          //   fit: BoxFit.fill,
          //   width: 90.0,
          //   height: 110.0,
          // ),
          const FlutterLogo(
            size: 90.0,
          ),
          const Divider(
            thickness: 0.2,
          ),
          Wrap(children: [Text(titleName)])
        ],
      ),
    );
  }
}
