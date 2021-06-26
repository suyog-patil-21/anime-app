import 'package:anime_app/models/dataconverter_data_model.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

// class SeriesData {
//   final String? seriesName;
//   SeriesData({this.seriesName, this.totalSeason = 1});
//   int? totalSeason = 1;
//   List<Season>? season;
// }

// class Season {
//   List<EpisodeData>? _seasonEpisodes;
//   get getSeasonEpisodelist => _seasonEpisodes;
//   void addEpisode(EpisodeData data) {
//     _seasonEpisodes!.add(data);
//   }
// }

class MyDownloadTaskInfo {
  // final String? episodeName;
  // final String? url;
  // EpisodeData({this.episodeName, this.url});
  DataConverter? episodeDetails;
  DataConverter? downloadContent;
  int? seasonNo;
  String? seriestitleName;
  MyDownloadTaskInfo(
      {this.episodeDetails, this.seasonNo, this.seriestitleName});

  // * Download TASK INFO
  String? taskId;
  int? progress = 0;
  DownloadTaskStatus? status = DownloadTaskStatus.undefined;
}
