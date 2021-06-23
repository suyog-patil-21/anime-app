import 'package:anime_app/Series_page.dart';
import 'package:anime_app/download_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

final List<String> alpha = [
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'Y',
  'Z'
];

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                tooltip: 'Show Downloads',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DownloadPage()));
                },
                icon: const Icon(
                  Icons.download_rounded,
                  color: Colors.white,
                ))
          ],
          title: const Text('Anime'),
          centerTitle: true,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) => GridView.builder(
              itemCount: alpha.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: constraints.maxWidth < 600 ? 4 : 8),
              itemBuilder: (BuildContext context, int index) {
                return FlatButton(
                    child: customAlfa(alpha[index]),
                    onPressed: () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return SeriesPage(
                            titleBName: alpha[index],
                          );
                        })));
              }),
        ));
  }
}

Widget customAlfa(var item) {
  return Center(
    child: CircleAvatar(
      radius: 26.0,
      child: Text(
        item,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
