import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kids_videos_channels/src/activity/AboutApp.dart';
import 'package:kids_videos_channels/src/activity/CategoryVideos.dart';
import 'package:kids_videos_channels/src/activity/NewVideos.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  _onTapIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  List _menuScreen = [
    NewVideosChannels(),
    CategoryVideosChannels(),
    AboutMyApp()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 3.0,
        centerTitle: true,
        title: Text(
          'Youtube App Channels',
        ),
      ),
      body: _menuScreen[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.red,
        currentIndex: _currentIndex,
        onTap: _onTapIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.youtube), title: Text("New Videos")),
          BottomNavigationBarItem(
              icon: Icon(Icons.video_library), title: Text("Channels")),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), title: Text("About")),
        ],
      ),
    );
  }
}
