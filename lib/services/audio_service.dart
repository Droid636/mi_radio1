import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();

  AudioPlayer get player => _player;

  /// Configura la sesión de audio
  Future<void> init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
  }

  /// Cargar una URL
  Future<void> setUrl(String url) async {
    try {
      await _player.setUrl(url);
    } catch (e) {
      print("❌ Error al cargar URL: $e");
    }
  }

  Future<void> play() async {
    try {
      await _player.play();
    } catch (e) {
      print("❌ Error al reproducir: $e");
    }
  }

  Future<void> pause() async {
    try {
      await _player.pause();
    } catch (e) {
      print("❌ Error al pausar: $e");
    }
  }

  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (e) {
      print("❌ Error al detener: $e");
    }
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
