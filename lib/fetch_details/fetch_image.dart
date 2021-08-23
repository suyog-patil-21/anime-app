// * fetching from Microsoft bing images
// ? exammple : https://www.bing.com/images/search?q=boruto+cover&first=1&tsc=ImageBasicHover
// getElementAttribute
import 'package:flutter/material.dart';
import 'package:web_scraper/web_scraper.dart';

final _imageScraper = WebScraper('https://www.bing.com');
Future<String> getSeriesCoverImage(String seriestitle) async {
  String image =
      'https://images.unsplash.com/source-404?fit=crop&fm=jpg&h=800&q=60&w=1200';
  if (seriestitle.isNotEmpty && seriestitle != '') {
    if (await _imageScraper.loadWebPage(
        '/images/search?q=${seriestitle.replaceAll(' ', '%20')}+anime+cover&first=1&tsc=ImageBasicHover')) {
      List<String?> temp = _imageScraper.getElementAttribute(
          'div.imgpt > a.iusc > div.img_cont.hoff > img.mimg', 'src');
      // print('IMAGE SCRAPE:element : $temp');
      image = temp[0].toString();
    }
  }
  return image;
}
