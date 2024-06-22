import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_player/video_player.dart';
import '../model/musiclist.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title: Text(
            'Audio & Video',
            style: TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.audiotrack),
                text: 'Audio',
              ),
              Tab(
                icon: Icon(Icons.video_collection),
                text: 'Video',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AudioPage(),
            VideoPlayerScreen(),
          ],
        ),
      ),
    );
  }
}

class AudioPage extends StatefulWidget {
  const AudioPage({super.key});

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  List<Map<String, dynamic>> foundUser = [];

  @override
  void initState() {
    foundUser = musicList;
    super.initState();
  }

  void runFilter(String enteredKey) {
    List<Map<String, dynamic>> results = [];
    if (enteredKey.isEmpty) {
      results = musicList;
    } else {
      results = musicList
          .where((element) =>
              element["title"]
                  ?.toLowerCase()
                  .contains(enteredKey.toLowerCase()) ??
              false)
          .toList();
    }
    setState(() {
      foundUser = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String name = args['name'] ?? 'Name';
    final String lastName = args['lastName'] ?? 'Last Name';
    final String? imagePath = args['imagePath'];

    return Scaffold(
      backgroundColor: const Color(0xff0A071E),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        imagePath != null ? FileImage(File(imagePath)) : null,
                    child: imagePath == null
                        ? Text(
                            name.isNotEmpty ? name[0].toUpperCase() : '?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          )
                        : null,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "$name $lastName",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Listen The",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "Latest Musics",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 19,
                  ),
                  Expanded(
                    child: Container(
                      width: 120,
                      child: TextField(
                        onChanged: (value) {
                          runFilter(value);
                        },
                        decoration: InputDecoration(
                          hintText: "🔍  Search",
                          hintStyle: TextStyle(color: Colors.white54),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                            borderSide: BorderSide(color: Colors.white60),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                            borderSide: BorderSide(color: Colors.white60),
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                        ),
                        style: TextStyle(color: Colors.white), // Text color
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            CarouselSlider(
              items: List.generate(
                foundUser.length,
                (index) {
                  final music = foundUser[index];
                  return Image.network(
                    music['img'],
                    fit: BoxFit.cover,
                  );
                },
              ),
              options: CarouselOptions(
                autoPlay: true,
                enlargeFactor: 0.3,
                enlargeCenterPage: true,
                autoPlayInterval: Duration(seconds: 2),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              // Add this line
              physics: NeverScrollableScrollPhysics(),
              // Add this line
              padding: const EdgeInsets.all(20),
              itemCount: foundUser.length,
              itemBuilder: (context, index) {
                final music = foundUser[index];
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  leading: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        music['img'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(
                    music['title']!,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    music['artist']!,
                    style: TextStyle(color: Colors.white70),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, "music_page",
                        arguments: music);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  int _currentVideoIndex = 0;

  List<Map<String, String>> videos = [
    {
      "url":
      "https://videos.pexels.com/video-files/852400/852400-sd_640_360_24fps.mp4",
      "title": "Video 1"
    },
    {
      "url":
      "https://videos.pexels.com/video-files/3890521/3890521-sd_640_360_25fps.mp4",
      "title": "Video 2"
    },
    {
      "url":
      "https://videos.pexels.com/video-files/5107014/5107014-sd_640_360_25fps.mp4",
      "title": "Video 3"
    },
    {
      "url":
      "https://videos.pexels.com/video-files/4971196/4971196-sd_640_360_25fps.mp4",
      "title": "Video 4"
    },
    {
      "url":
      "https://videos.pexels.com/video-files/4089576/4089576-sd_640_360_25fps.mp4",
      "title": "Video 5"
    },
  ];

  @override
  void initState() {
    super.initState();
    // Initialize the first video to play
    playNetworkVideo(videos[_currentVideoIndex]['url']!);
  }

  void playNetworkVideo(String url) {
    _controller?.dispose();
    _controller = VideoPlayerController.network(url)
      ..initialize().then((_) {
        setState(() {
          if (_controller != null) {
            _chewieController = ChewieController(
              videoPlayerController: _controller!,
              autoPlay: true,
              looping: false,
            );
          }
        });
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
              ? AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: Chewie(
              controller: _chewieController!,
            ),
          )
              : Container(
            height: 200,
            color: Colors.black,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          SizedBox(height: 20,),
          Expanded(
            child: ListView.builder(
              itemCount: videos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(videos[index]['title']!,style: TextStyle(color: Colors.white),),
                  onTap: () {
                    setState(() {
                      _currentVideoIndex = index;
                      playNetworkVideo(videos[_currentVideoIndex]['url']!);
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
