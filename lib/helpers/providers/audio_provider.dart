// ** Nota: Este es un esqueleto de AudioProvider. DEBES copiar solo las adiciones si ya tienes la clase. **

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../models/station_model.dart'; // Asegúrate de que esta ruta sea correcta

class AudioProvider with ChangeNotifier {
  final AudioPlayer player = AudioPlayer();
  StationModel? _currentStation;
  bool _isPlaying = false;
  bool _isLoading = false;

  // *** NUEVA PROPIEDAD: Controla si el mini-player debe mostrarse ***
  bool _isMiniPlayerHidden = false;

  StationModel? get currentStation => _currentStation;
  bool get isPlaying => _isPlaying;
  bool get isMiniPlayerHidden => _isMiniPlayerHidden; // NUEVO GETTER
  bool get isLoading => _isLoading;

  AudioProvider() {
    // Escuchar cambios de estado de reproducción
    player.playerStateStream.listen((state) {
      final playing = state.playing;
      final processingState = state.processingState;

      // Loader solo cuando está cargando o bufferizando
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        _isLoading = true;
      } else {
        _isLoading = false;
      }

      // Actualiza _isPlaying
      if (processingState == ProcessingState.ready) {
        _isPlaying = playing;
      } else if (processingState == ProcessingState.completed) {
        _isPlaying = false;
      }
      notifyListeners();
    });
  }

  Future<void> setStation(StationModel station) async {
    if (_currentStation?.id != station.id) {
      _isLoading = true;
      notifyListeners();
      _currentStation = station;
      try {
        await player.setAudioSource(
          AudioSource.uri(Uri.parse(station.streamUrl)),
        );
      } catch (e) {
        _isLoading = false;
        notifyListeners();
        rethrow;
      }
      _isMiniPlayerHidden = false; // Muestra el mini-player al seleccionar
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> play() async {
    if (_currentStation != null) {
      _isLoading = true;
      notifyListeners();
      try {
        await player.play();
        _isPlaying = true;
      } finally {
        _isLoading = false;
        _isMiniPlayerHidden = false; // Muestra el mini-player al reproducir
        notifyListeners();
      }
    }
  }

  Future<void> pause() async {
    await player.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // Detiene la reproducción y oculta el mini-player
  Future<void> stop() async {
    await player.stop();
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
