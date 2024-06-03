import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import '../model/musiclist.dart';

class MusicPlayerProvider extends ChangeNotifier {
  final AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();
  int _currentSliderValue = 0;
  bool _isPlaying = false;
  int _currentIndex = 0;

  MusicPlayerProvider() {
    if (musicList.isNotEmpty) {
      _openAudio(musicList[_currentIndex]['audio'] ?? '');
    }
    _assetsAudioPlayer.currentPosition.listen((duration) {
      _currentSliderValue = duration.inSeconds.toInt();
      notifyListeners();
    });

    _assetsAudioPlayer.playlistAudioFinished.listen((_) {
      skipNext();
    });

    _assetsAudioPlayer.playerState.listen((playerState) {
      _isPlaying = playerState == PlayerState.play;
      notifyListeners();
    });
  }

  int get currentSliderValue => _currentSliderValue;  // Keep it as int
  bool get isPlaying => _isPlaying;
  int get currentIndex => _currentIndex;

  AssetsAudioPlayer get assetsAudioPlayer => _assetsAudioPlayer;

  void _openAudio(String url) {
    _assetsAudioPlayer.open(
      Audio.network(url),
      autoStart: true,
      showNotification: true,
    );
  }

  void togglePlayPause() {
    if (_isPlaying) {
      _assetsAudioPlayer.pause();
    } else {
      _assetsAudioPlayer.play();
    }
  }

  void skipNext() {
    if (_currentIndex < musicList.length - 1) {
      _currentIndex++;
      _openAudio(musicList[_currentIndex]['audio'] ?? '');
    } else {
      _currentIndex = 0;
      _openAudio(musicList[_currentIndex]['audio'] ?? '');
    }
    notifyListeners();
  }

  void skipPrevious() {
    if (_currentIndex > 0) {
      _currentIndex--;
      _openAudio(musicList[_currentIndex]['audio'] ?? '');
    } else {
      _currentIndex = musicList.length - 1;
      _openAudio(musicList[_currentIndex]['audio'] ?? '');
    }
    notifyListeners();
  }

  void seek(double value) {
    _assetsAudioPlayer.seek(Duration(seconds: value.toInt()));
  }

  void playSpecificSong(int index) {
    _currentIndex = index;
    _openAudio(musicList[_currentIndex]['audio'] ?? '');
    notifyListeners();
  }
}
