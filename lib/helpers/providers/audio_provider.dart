// ** Nota: Este es un esqueleto de AudioProvider. DEBES copiar solo las adiciones si ya tienes la clase. **

import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import '../../models/station_model.dart';
import '../../helpers/constants.dart';

class AudioProvider with ChangeNotifier {
  late final AudioHandler _audioHandler;
  StationModel? _currentStation;
  bool _isMiniPlayerHidden = false;
  bool _isLoading = false;
  bool _isPlaying = false;

  StationModel? get currentStation => _currentStation;
  bool get isPlaying => _isPlaying;
  bool get isMiniPlayerHidden => _isMiniPlayerHidden;
  bool get isLoading => _isLoading;

  void setHandler(AudioHandler handler) {
    _audioHandler = handler;
    _audioHandler.playbackState.listen((state) {
      _isPlaying = state.playing;
      _isLoading =
          state.processingState == AudioProcessingState.loading ||
          state.processingState == AudioProcessingState.buffering;
      notifyListeners();
    });
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
        await _audioHandler.play();
        _isPlaying = true;
      } finally {
        _isLoading = false;
        _isMiniPlayerHidden = false;
        notifyListeners();
      }
    }
  }

  Future<void> pause() async {
    await _audioHandler.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // Detiene la reproducción y oculta el mini-player
  Future<void> stop() async {
    await _audioHandler.stop();
    _currentStation = null;
    _isPlaying = false;
    _isMiniPlayerHidden = true;
    notifyListeners();
  }

  // *** NUEVAS FUNCIONES PARA CONTROLAR LA VISIBILIDAD ***
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
