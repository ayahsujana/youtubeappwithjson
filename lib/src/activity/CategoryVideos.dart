import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kids_videos_channels/src/activity/NewVideos.dart';
import 'package:kids_videos_channels/src/api/api.dart';
import 'package:kids_videos_channels/src/model/models.dart';

class CategoryVideosChannels extends StatefulWidget {
  _CategoryVideosChannelsState createState() => _CategoryVideosChannelsState();
}

class _CategoryVideosChannelsState extends State<CategoryVideosChannels> {
  final categoryVideo = List<CategoryModels>();
  bool isLoading = false;
  bool isCek = false;

  Future<Null> _fetchCategoryVideo() async {
    categoryVideo.clear();
    setState(() {
      isLoading = true;
    });

    final response = await http.get(Api.showCategory);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final cat = new CategoryModels(
            api['cid'], api['category_name'], api['category_image']);
        categoryVideo.add(cat);
        setState(() {
          isLoading = false;
          isCek = true;
        });
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchCategoryVideo();
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
              "Sorry, no channels available, try again later\nor Please check your internet connection.",
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
        itemCount: categoryVideo.length,
        itemBuilder: (context, i) {
          final category = categoryVideo[i];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VideoByCategory(category)));
            },
            child: Card(
              elevation: 5.0,
              child: Row(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FadeInImage.assetNetwork(
                        placeholder: "./images/loading_icon.gif",
                        height: 75.0,
                        width: 75.0,
                        image: Api.imgCategory + category.categoryImage,
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      category.categoryName,
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}

class VideoByCategory extends StatefulWidget {
  final CategoryModels categoryModels;
  VideoByCategory(this.categoryModels);
  _VideoByCategoryState createState() => _VideoByCategoryState();
}

class _VideoByCategoryState extends State<VideoByCategory> {
  final videoChannels = List<VideosModels>();
  bool isLoading = false;
  bool isCek = false;

  Future<Null> _fetchVideoChannels() async {
    videoChannels.clear();
    setState(() {
      isLoading = true;
    });

    final response =
        await http.get(Api.showVideosBycategory + widget.categoryModels.cid);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('$data');
      data.forEach((api) {
        final vChannels = new VideosModels(
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
        videoChannels.add(vChannels);
        setState(() {
          isLoading = false;
          isCek = true;
        });
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchVideoChannels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(widget.categoryModels.categoryName),
        centerTitle: true,
        elevation: 3.0,
      ),
      body: isCek ? _buildHasData() : _buildErrorData(),
    );
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
        itemCount: videoChannels.length,
        itemBuilder: (context, i) {
          final vid = videoChannels[i];
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
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: <Widget>[
                      Hero(
                        tag: vid.id,
                        child: FadeInImage.assetNetwork(
                          placeholder: "./images/loading_icon.gif",
                          height:
                              Theme.of(context).platform == TargetPlatform.iOS
                                  ? 225
                                  : 195,
                          width: MediaQuery.of(context).size.width,
                          image: "https://img.youtube.com/vi/" +
                              vid.videoId +
                              "/0.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        right: 5.0,
                        bottom: 5.0,
                        child: Container(
                            color: Colors.black,
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              vid.videoDuration,
                              style: TextStyle(color: Colors.white),
                            )),
                      )
                    ],
                  ),
                  ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        vid.videoTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    subtitle: Text(vid.categoryName),
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(Api.imgCategory + vid.categoryImage),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
