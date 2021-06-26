import 'dart:async';
import 'package:web_scraper/web_scraper.dart';

const mainPageurl = 'https://eng.cartoonsarea.xyz';
final _webScraper = WebScraper(mainPageurl);

// * this is use for fetching the list from the web url
Future<List<Map<String, dynamic>>> fetchlist({required String urlpath}) async {
  List<Map<String, dynamic>> titleNames = [];
  String path = '';
  print('recieved in fetch url : $urlpath');
  if (urlpath.isNotEmpty && urlpath != '') {
    if (urlpath.length == 1) {
      //if the urlpath has single charcter then it will search all series with that alphabate
      path = '/English-Dubbed-Series/' + urlpath + '-Dubbed-Series/';
    } else {
      path = '/' + removeurlpart(st: urlpath);
    }
    if (await _webScraper.loadWebPage(path)) {
      titleNames =
          _webScraper.getElement('div.none > div.Singamdasam > a', ['href']);

      // print(titleNames);
    }
  }
  return titleNames;
}

// ? this is used to remove the starting url part before the first '/'
String removeurlpart({required String st, int rank = 3}) {
  if (rank == 0) {
    // print('String when sented to the function \n string is : $st');
    return st;
  } else if (rank > 0) {
//   print(st);

    return removeurlpart(st: st.substring(st.indexOf('/') + 1), rank: --rank);
  } else {
    return '';
  }
}

// * this is used for fetching episode pages
Future<List<Map<String, dynamic>>> fetchepisode({
  required String urlpath,
  // required String titleName,
  // required String seasonNum
}) async {
  // print('\nFETCH EPISODE : $urlpath');
  List<Map<String, dynamic>> realepisode = []; // real title and link map
  List<Map<String, dynamic>> episodeList = await fetchlist(urlpath: urlpath);
  // print('\n\n\nInside fectch episodes $episodeList');
  // Code For getting no of pages

  var pagelist = _webScraper.getElementTitle('ul.pagination > li > a');
//  print(
  //    '\t\t\t\t ===\t ===\t ===\t === this is the Pagination list : $pagelist');
  // print('<<<<<<before Pagination : ${episodeList.length} ');
  if (pagelist.isNotEmpty) {
    pagelist.removeAt(0); // ! removing the first page because duplication
    // print(
    // '\t\t\t\t ===\t ===\t ===\t === this is the Pagination list inside : $pagelist');
    // fetching no of pages
    for (var element in pagelist) {
      // print('new pages added ');
      List<Map<String, dynamic>> temp1 =
          await fetchlist(urlpath: urlpath + '?page=$element');
      episodeList.addAll(temp1);
      // print(episodeList.length);
    }
  }
  // print('<<<<<<<after PAgination : ${episodeList.length} ');
  // * to uncomment if doesn't work
  // for (var element in episodeList) {
  //   // print('>>>>>>>>>>>>>>searching WEbsite : ${element['attributes']['href']}');
  //   realepisode.add(await _pureElement(
  //       element['attributes']['href'], titleName, seasonNum));
  // }
  // print('<<<<<<<AT very last after Pagination : ${episodeList.length} ');
  //* till here
  // print('\t\t\t   Getting the output : $realepisode');
  // * to uncomment if doesn't work
  // return realepisode;
  // * till here
  return episodeList;
}

// ? pure element is use to find the real title name and url for the video
Future<Map<String, dynamic>> pureElement(
    String path, String titleName, String seasonNum) async {
  //path : element['attributes']['href']
  List<Map<String, dynamic>> temptitle = [];
  if (await _webScraper.loadWebPage('/' + removeurlpart(st: path))) {
    temptitle = _webScraper.getElement(
        'div.Box > div.Singamdasam > table > tbody > tr > td > span > a',
        ['href']);
    return <String, dynamic>{
      'title': temptitle[0]['title'],
      'url': mainPageurl +
          '/USER-DATA/Cartoonsarea/English/${titleName[0]}/$titleName/Season $seasonNum/Episode ${temptitle[0]['title'].toString().substring(0, temptitle[0]['title'].toString().indexOf(' '))}//${temptitle[0]['title'].toString()}'
              .replaceAll(' ', '%20'),
      'downloadTaskId': 'undefined'
    };
  } else {
    return {};
  }
}

// ! FIXME : Solve this error afterwards
//https://eng.cartoonsarea.xyz/USER-DATA/Cartoonsarea/English/D/Demon%20Slayer/Season%201/Episode%208//08%20The%20Smell%20of%20Enchanting%20Blood.mp4

// Program Genreated
//https://eng.cartoonsarea.xyz/USER-DATA/Cartoonsarea/English/D/Demon%20Slayer/Season%201/Episode%2008//08%20The%20Smell%20of%20Enchanting%20Blood.mp4
