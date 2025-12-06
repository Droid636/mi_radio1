import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import '../../models/station_model.dart';
import '../../helpers/constants.dart';

import 'package:just_audio/just_audio.dart';

class AudioProvider with ChangeNotifier {
  late final AudioHandler _audioHandler;
  StationModel? _currentStation;
  bool _isMiniPlayerHidden = false;
  bool _isLoading = false;
  bool _isPlaying = false;
  String? _currentMetadataTitle;

  StationModel? get currentStation => _currentStation;
  bool get isPlaying => _isPlaying;
  bool get isMiniPlayerHidden => _isMiniPlayerHidden;
  bool get isLoading => _isLoading;
  String? get currentMetadataTitle => _currentMetadataTitle;

  void setHandler(AudioHandler handler) {
    _audioHandler = handler;
    _audioHandler.playbackState.listen((state) {
      _isPlaying = state.playing;
      _isLoading =
          state.processingState == AudioProcessingState.loading ||
          state.processingState == AudioProcessingState.buffering;
      notifyListeners();
    });

    _audioHandler.mediaItem.listen((item) {
      if (item == null) return;
      final idx = stations.indexWhere((s) => s.streamUrl == item.id);
      if (idx != -1 &&
          (_currentStation == null ||
              _currentStation!.id != stations[idx].id)) {
        _currentStation = stations[idx];
        notifyListeners();
      }
    });

    // Escuchar metadatos ICY si el handler expone el player (just_audio)
    try {
      // Solo si el handler tiene un campo 'player' (de tipo AudioPlayer)
      final player = (handler as dynamic).player as AudioPlayer?;
      player?.icyMetadataStream.listen((IcyMetadata? icy) {
        final title = icy?.info?.title;
        print('[ICY Metadata] Título recibido: $title');
        if (title != null && title.isNotEmpty) {
          _currentMetadataTitle = title;
        } else {
          _currentMetadataTitle = null;
        }
        notifyListeners();
      });
    } catch (_) {
      // Si no hay player, ignorar
    }
  }

  Future<void> setStation(StationModel station) async {
    if (_currentStation?.id != station.id) {
      _isLoading = true;
      notifyListeners();
      _currentStation = station;
      try {
        int idx = stations.indexWhere((s) => s.id == station.id);
        await _audioHandler.customAction('setUrl', {
          'url': station.streamUrl,
          'index': idx,
        });
      } catch (e) {
        _isLoading = false;
        notifyListeners();
        rethrow;
      }
      _isMiniPlayerHidden = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> playNextStation() async {
    if (_currentStation == null) return;
    int idx = stations.indexWhere((s) => s.id == _currentStation!.id);
    int nextIdx = (idx + 1) % stations.length;
    await setStation(stations[nextIdx]);
    await play();
  }

  Future<void> playPreviousStation() async {
    if (_currentStation == null) return;
    int idx = stations.indexWhere((s) => s.id == _currentStation!.id);
    int prevIdx = (idx - 1 + stations.length) % stations.length;
    await setStation(stations[prevIdx]);
    await play();
  }

  Future<void> play() async {
    if (_currentStation != null) {
      _isLoading = true;
      notifyListeners();
      try {
        int idx = stations.indexWhere((s) => s.id == _currentStation!.id);
        await _audioHandler.customAction('setUrl', {
          'url': _currentStation!.streamUrl,
          'index': idx,
        });
        await _audioHandler.play();
      } finally {
        _isLoading = false;
        _isMiniPlayerHidden = false;
        notifyListeners();
      }
    }
  }

  Future<void> pause() async {
    await _audioHandler.pause();
  }

  Future<void> stop() async {
    await _audioHandler.stop();
    _currentStation = null;
    _isPlaying = false;
    _isMiniPlayerHidden = true;
    _currentMetadataTitle = null;
    notifyListeners();
  }

  void showMiniPlayer() {
    if (_isMiniPlayerHidden) {
      _isMiniPlayerHidden = false;
      notifyListeners();
    }
  }

  void hideMiniPlayer() {
    if (!_isMiniPlayerHidden) {
      _isMiniPlayerHidden = true;
      notifyListeners();
    }
  }
}
