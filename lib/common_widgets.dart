import 'dart:isolate';

import 'package:flutter/material.dart';

// * Loading Widget with circular progress indicator
Widget loadingWidget({required double width}) {
  return Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        height: width * 0.2,
        width: width * 0.2,
        decoration: BoxDecoration(
            color: Colors.grey[600], borderRadius: BorderRadius.circular(8.0)),
        child: const Center(child: CircularProgressIndicator()),
      ),
      const Padding(
        padding: EdgeInsets.all(5.0),
        child: Text(
          'Loading..',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      const Padding(
        padding: EdgeInsets.all(5.0),
        child: Text(
          'Scraping Things... ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      )
    ]),
  );
}
