import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:built_value/serializer.dart';
import 'package:intl/intl.dart';

class Video {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelTitle;
  final String publishedAt;

  Video({
    this.id,
    this.title,
    this.thumbnailUrl,
    this.channelTitle,
    this.publishedAt
  });

  factory Video.fromMap(Map<String, dynamic> snippet) {
    List<String> x = snippet['publishedAt'].toString().split("T");
    var y = DateTime.parse(x[0]);
    int m = DateTime.now().difference(y).inDays;

    int day, month, year;
    String res = '';
    year = (m ~/ 365);
    if(year == 1) {
      res += "$year y ";
    }else if(year > 1){
      res += "$year ys ";
    }
    month = (m - 365*year) ~/ 30;
    if(month == 1){
      res+= "$month mth ";
    }else if(month > 1) {
      res += "$month mths ";
    }
    day = m - 365 * year - 30* month;
    if(day == 1) {
      res += "$day day";
    }else if(day > 1){
      res += "$day days";
    }


    return Video(
      id: snippet['resourceId']['videoId'],
      title: snippet['title'],
      thumbnailUrl: snippet['thumbnails']['high']['url'],
      channelTitle: snippet['channelTitle'],
      publishedAt: res
    );
  }
}