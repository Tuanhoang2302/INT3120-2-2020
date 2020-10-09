import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_app/Model/channel.dart';
import 'package:english_app/Model/video.dart';
import 'package:english_app/Screens/Listening/video_screens.dart';
import 'package:english_app/Screens/Reading/categoryTile.dart';
import 'package:english_app/Services/api_youtube_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Listening extends StatefulWidget {
  @override
  _ListeningState createState() => _ListeningState();
}

class _ListeningState extends State<Listening> {
  Channel _channel;
  bool _isLoading = false;
  CollectionReference category =
      FirebaseFirestore.instance.collection('category');

  String _categoryType = "technology";
  bool _loading = false;
  int _selectedCategoryindex = 0;
  bool selectedCategoryBorder = false;
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  String _channelId = 'UCsTcErHg8oDvUnTzoqsYeNw';

  void _onLoading() async {

    _refreshController.loadComplete();
  }

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 500));
    // if failed,use refreshFailed()
    setState(() {
      _channel = null;
    });
    await _initChannel(_channelId);
    _refreshController.refreshCompleted();
  }

  _initChannel(String channelId) async {
    Channel channel = await APIYouTubeService.instance
        .fetchChannel(channelId: channelId);
    setState(() {
      _channel = channel;
    });
  }

  _categoryList() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: StreamBuilder<QuerySnapshot>(
        stream: category.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var data = snapshot.data.docs;
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              //print(data[1].data()["categoryName"]);
            }
            //print(articles[0].title);
            return Container(
              height: 70,
              margin: EdgeInsets.only(top: 8),
              child: ListView.builder(
                  itemCount: data.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    if (index != _selectedCategoryindex) {
                      selectedCategoryBorder = false;
                    } else {
                      selectedCategoryBorder = true;
                    }
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _channelId = data[index].data()["youtubeChannelId"];
                          _selectedCategoryindex = index;
                        });
                        //_streamController.add(getCategoryNews(data[index].data()["categoryName"].toString().toLowerCase()));
                        _channel = null;
                        _initChannel(data[index].data()["youtubeChannelId"]);
                      },
                      child: CategoryTile(
                        categoryName: data[index].data()["categoryName"],
                        imageUrl: data[index].data()["imageUrl"],
                        border: selectedCategoryBorder,
                      ),
                    );
                  }),
            );
          }
        },
      ),
    );
  }

  _buildVideo(Video video) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoScreen(id: video.id),
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        padding: EdgeInsets.all(10.0),
        height: 140.0,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 1),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Image(
              width: 140.0,
              image: NetworkImage(video.thumbnailUrl),
            ),
            SizedBox(width: 10.0),
            Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  width: 200,
                  margin: EdgeInsets.only(top: 8),
                  child: Text(
                    video.title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  width: 200,
                  margin: EdgeInsets.only(bottom: 8),
                  child: Text(video.publishedAt),
                )
              ],
            ),

          ],
        ),
      ),
    );
  }

  _loadMoreVideos() async {
    _isLoading = true;
    List<Video> moreVideos = await APIYouTubeService.instance
        .fetchVideosFromPlaylist(playlistId: _channel.uploadPlaylistId);
    List<Video> allVideos = _channel.videos..addAll(moreVideos);
    setState(() {
      _channel.videos = allVideos;
    });
    _isLoading = false;
  }

  @override
  void initState() {
    super.initState();
    _initChannel('UC6Dy0rQ6zDnQuHQ1EeErGUA');
  }

  Widget build(BuildContext context) {
    //print(_channel.videos.length);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          _categoryList(),
          _channel != null
              ? Expanded(
                child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollDetails) {
                if (!_isLoading &&
                    _channel.videos.length != int.parse(_channel.videoCount) &&
                    scrollDetails.metrics.pixels ==
                        scrollDetails.metrics.maxScrollExtent) {
                  _loadMoreVideos();
                }
                return false;
            },
            child: SmartRefresher(
              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: ListView.builder(
                  itemCount: _channel.videos.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      //return _buildProfileInfo();
                      return Text("");
                    } else {
                      Video video = _channel.videos[index];
                      return _buildVideo(video);
                    }
                  },
              ),
            ),
          ),
              )
              : Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor, // Red
              ),
            ),
          ),
        ],
      )

    );
  }
}
