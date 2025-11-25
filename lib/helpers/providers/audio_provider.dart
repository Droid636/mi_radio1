// lib/helpers/providers/audio_provider.dart

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import '../../../models/station_model.dart';

class AudioProvider with ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  StationModel? _currentStation;

  AudioPlayer get player => _player;
  StationModel? get currentStation => _currentStation;
  
  // 🚀 NUEVA PROPIEDAD: Necesaria para el botón dinámico Play/Pause
  bool get isPlaying => _player.playing;

  AudioProvider() {
    _init();
  }

  void _init() async {
    // Si quieres configurar audio_session, puedes agregarlo aquí.
    // Mantendremos esto simple de momento.
  }

  /// Cambiar estación y cargar su stream
  Future<void> setStation(StationModel station) async {
    _currentStation = station;
    try {
      await _player.setAudioSource(
        AudioSource.uri(Uri.parse(station.streamUrl)),
      );
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error al cargar el stream: $e");
    }
  }

  /// Reproducir
  Future<void> play() async {
    await _player.play();
    notifyListeners();
  }

  /// Pausar
  Future<void> pause() async {
    await _player.pause();
    notifyListeners();
  }

  /// Detener
  Future<void> stop() async {
    await _player.stop();
    notifyListeners();
  }

  /// Stream que combina posición, buffer y duración
  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration?, Duration?, PositionData>(
        _player.positionStream,
        _player.bufferedPositionStream,
        _player.durationStream,
        (position, buffered, duration) => PositionData(
          position,
          buffered ?? Duration.zero,
          duration ?? Duration.zero,
        ),
      );

  /// Liberar el reproductor (opcional)
  void disposePlayer() {
    _player.dispose();
  }
}

/// Modelo para manejar datos de posición del reproductor
class PositionData {
  final Duration position;
  final Duration buffered;
  final Duration duration;

  PositionData(this.position, this.buffered, this.duration);
}