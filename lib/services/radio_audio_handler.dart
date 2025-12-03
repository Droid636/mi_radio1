import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import '../models/station_model.dart';
import '../helpers/constants.dart';

class RadioAudioHandler extends BaseAudioHandler with SeekHandler {
  final _player = AudioPlayer();
  int _currentIndex = 0;

  RadioAudioHandler() {
    // Inicializa el MediaItem y PlaybackState
    _updateMediaItem();
    _player.playerStateStream.listen((state) {
      playbackState.add(
        PlaybackState(
          controls: [
            MediaControl.skipToPrevious,
            state.playing ? MediaControl.pause : MediaControl.play,
            MediaControl.skipToNext,
            MediaControl.stop,
          ],
          androidCompactActionIndices: const [0, 1, 2],
          playing: state.playing,
          processingState: _transformProcessingState(state.processingState),
          systemActions: const {
            MediaAction.seek,
            MediaAction.seekForward,
            MediaAction.seekBackward,
            MediaAction.skipToNext,
            MediaAction.skipToPrevious,
            MediaAction.play,
            MediaAction.pause,
            MediaAction.stop,
          },
        ),
      );
    });
  }

  StationModel get _currentStation => stations[_currentIndex];

  void _updateMediaItem() {
    final station = _currentStation;
    // Usa imageUrl (remota) si existe, si no, usa asset local o url de image
    Uri? artUri;
    if (station.imageUrl != null && station.imageUrl!.isNotEmpty) {
      artUri = Uri.parse(station.imageUrl!);
    } else if (station.image.startsWith('http')) {
      artUri = Uri.parse(station.image);
    } else {
      artUri = Uri.parse('asset:///${station.image}');
    }
    mediaItem.add(
      MediaItem(
        id: station.streamUrl,
        album: station.acronym,
        title: station.name,
        artist: station.slogan,
        artUri: artUri,
      ),
    );
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() => _player.stop();

  Future<void> setUrl(String url, {int? index}) async {
    try {
      if (index != null) {
        _currentIndex = index;
        _updateMediaItem();
      }
      await _player.setUrl(url);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future customAction(String name, [Map<String, dynamic>? extras]) async {
    if (name == 'setUrl' && extras != null && extras['url'] != null) {
      int? idx = extras['index'] as int?;
      await setUrl(extras['url'] as String, index: idx);
    }
    return super.customAction(name, extras);
  }

  @override
  Future<void> skipToNext() async {
    _currentIndex = (_currentIndex + 1) % stations.length;
    final station = _currentStation;
    _updateMediaItem();
    await setUrl(station.streamUrl);
    await play();
  }

  @override
  Future<void> skipToPrevious() async {
    _currentIndex = (_currentIndex - 1 + stations.length) % stations.length;
    final station = _currentStation;
    _updateMediaItem();
    await setUrl(station.streamUrl);
    await play();
  }

  AudioProcessingState _transformProcessingState(ProcessingState state) {
    switch (state) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
        return AudioProcessingState.loading;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
    }
  }
}
