import '../models/station_model.dart';

final List<StationModel> stations = [
  StationModel(
    id: 'ljr',
    name: 'Live Jazz Radio',
    acronym: 'LJR',
    streamUrl: 'https://stream.freepi.io/8012/live',
    slogan: 'La síncopa de nuestras latitudes',
    image:
        'https://drive.google.com/uc?export=download&id=1xpBdinpmsyep7UO4X-0YOIJRRxx3mTsW',
    socials: {
      'web': 'https://example.com/ljr',
      'twitter': 'https://twitter.com/ljr',
    },
  ),
  StationModel(
    id: 'rtx',
    name: 'Radioactiva Tx',
    acronym: 'RTX',
    streamUrl: 'https://stream.freepi.io/8010/stream',
    slogan: '¡La Radio Alternativa!',
    image:
        'https://drive.google.com/uc?export=download&id=1fVyMb8FntiyOCRNAf4C207-0dvMrK4DX',
    socials: {
      'web': 'https://example.com/rtx',
      'facebook': 'https://facebook.com/rtx',
    },
  ),
];
