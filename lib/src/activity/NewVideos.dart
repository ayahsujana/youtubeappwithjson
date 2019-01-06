import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kids_videos_channels/src/api/api.dart';
import 'package:kids_videos_channels/src/model/models.dart';
import 'package:share_extend/share_extend.dart';

class NewVideosChannels extends StatefulWidget {
  _NewVideosChannelsState createState() => _NewVideosChannelsState();
}

class _NewVideosChannelsState extends State<NewVideosChannels> {
  final videoTerbaru = List<VideosModels>();
  bool isLoading = false;
  bool isCek = false;

  Future<Null> _fetchVideoTerbaru() async {
    videoTerbaru.clear();
    setState(() {
      isLoading = true;
    });

    final response = await http.get(Api.showAllNewVideos);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final video = new VideosModels(
            api['id'],
            api['cat_id'],
            api['video_title'],
            api['video_url'],
            api['video_id'],
            api['video_thumbnail'],
            api['video_duration'],
            api['video_description'],
            api['video_type'],
            api['category_name'],
            api['category_image']);
        videoTerbaru.add(video);
        setState(() {
          isLoading = false;
          isCek = true;
        });
      });
    } else {
      throw Exception('Failed to load videos');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchVideoTerbaru();
  }

  @override
  Widget build(BuildContext context) {
    return isCek ? _buildHasData() : _buildErrorData();
  }

  _buildErrorData() {
    if (isCek) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.error,
                size: 50.0,
              ),
            ),
            Text(
              "Sorry, no videos available, try again later\nor Please check your internet connection.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      );
    }
  }

  _buildHasData() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return ListView.builder(
        itemCount: videoTerbaru.length,
        itemBuilder: (context, i) {
          final vid = videoTerbaru[i];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailVideoYoutube(vid)));
            },
            child: Card(
              elevation: 5.0,
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(0.0),
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Hero(
                            tag: vid.id,
                            child: FadeInImage.assetNetwork(
                              placeholder: "./images/loading_icon.gif",
                              height: 110,
                              width: 200.0,
                              image: "https://img.youtube.com/vi/" +
                                  vid.videoId +
                                  "/0.jpg",
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            right: 6.0,
                            bottom: 6.0,
                            child: Container(
                                color: Colors.black,
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  vid.videoDuration,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                )),
                          )
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                vid.videoTitle,
                                softWrap: true,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: 40.0,
                              ),
                              Text(
                                vid.categoryName,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w300),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      );
    }
  }
}

class DetailVideoYoutube extends StatefulWidget {
  final VideosModels videoModels;
  DetailVideoYoutube(this.videoModels);
  _DetailVideoYoutubeState createState() => _DetailVideoYoutubeState();
}

class _DetailVideoYoutubeState extends State<DetailVideoYoutube> {
  _playYoutubeVideo() {
    FlutterYoutube.playYoutubeVideoByUrl(
        apiKey: "AIzaSyCV3q71Xi9MscwPzuOInVCG2wvhSU2x4Ww",
        videoUrl: widget.videoModels.videoUrl,
        autoPlay: true,
        fullScreen: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: Text('Video Details'),
        elevation: 3.0,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.all(8.0),
              child: Builder(
                builder: (context) {
                  return FlatButton(
                    onPressed: () {
                      ShareExtend.share(
                          "Watching Now " + widget.videoModels.videoUrl,
                          "text");
                    },
                    child: Icon(FontAwesomeIcons.solidShareSquare),
                  );
                },
              ))
        ],
      ),
      body: Container(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            GestureDetector(
              onTap: _playYoutubeVideo,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    child: Hero(
                      tag: widget.videoModels.id,
                      child: Image.network(
                        "https://img.youtube.com/vi/" +
                            widget.videoModels.videoId +
                            "/0.jpg",
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Icon(FontAwesomeIcons.playCircle,
                      color: Colors.white, size: 50.0),
                ],
              ),
            ),
            Card(
              elevation: 5.0,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      widget.videoModels.videoTitle,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.timer),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(widget.videoModels.videoDuration)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.format_list_bulleted),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(widget.videoModels.categoryName)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
