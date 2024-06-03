import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home_provider/music_provider.dart';
import '../model/musiclist.dart';

class MusicPlayerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, String> music = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final musicPlayer = Provider.of<MusicPlayerProvider>(context, listen: false);

    final int musicIndex = musicList.indexOf(music);

    if (musicIndex != -1) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        musicPlayer.playSpecificSong(musicIndex);
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xff0A071E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.red),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Consumer<MusicPlayerProvider>(
            builder: (context, musicPlayer, child) {
              final currentMusic = musicList[musicPlayer.currentIndex];

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    currentMusic['img'] ?? '',
                    height: 250,
                  ),
                  SizedBox(height: 30),
                  Text(
                    currentMusic['title'] ?? '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    currentMusic['artist'] ?? '',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 30),
                  StreamBuilder<Duration>(
                    stream: musicPlayer.assetsAudioPlayer.currentPosition,
                    builder: (context, snapshot) {
                      final audio = musicPlayer.assetsAudioPlayer.current.valueOrNull?.audio;
                      final maxDuration = audio?.duration?.inSeconds?.toDouble() ?? 100.0;
                      final currentPosition = snapshot.data?.inSeconds.toDouble() ?? 0.0;

                      return Column(
                        children: [
                          Slider(
                            value: currentPosition,
                            min: 0,
                            max: maxDuration,
                            onChanged: (double value) {
                              musicPlayer.seek(value);
                            },
                            activeColor: Colors.white,
                            inactiveColor: Colors.grey,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${(currentPosition ~/ 60).toString().padLeft(2, '0')}:${(currentPosition % 60).toInt()}',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  '${(maxDuration ~/ 60).toString().padLeft(2, '0')}:${(maxDuration % 60).toInt()}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.skip_previous, color: Colors.white),
                        onPressed: musicPlayer.skipPrevious,
                      ),
                      IconButton(
                        icon: Icon(
                          musicPlayer.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                          color: Colors.white,
                          size: 40,
                        ),
                        onPressed: musicPlayer.togglePlayPause,
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_next, color: Colors.white),
                        onPressed: musicPlayer.skipNext,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
