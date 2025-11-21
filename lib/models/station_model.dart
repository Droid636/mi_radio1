class StationModel {
  final String id;
  final String name;
  final String acronym;
  final String streamUrl;
  final String slogan;
  final String image; // asset path or network
  final Map<String, String> socials; // name -> url

  StationModel({
    required this.id,
    required this.name,
    required this.acronym,
    required this.streamUrl,
    required this.slogan,
    required this.image,
    this.socials = const {},
  });
}
