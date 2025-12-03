class StationModel {
  final String id;
  final String name;
  final String acronym;
  final String streamUrl;
  final String slogan;
  final String image; // asset path local
  final String? imageUrl; // url remota para audio handler
  final Map<String, String> socials; // name -> url

  StationModel({
    required this.id,
    required this.name,
    required this.acronym,
    required this.streamUrl,
    required this.slogan,
    required this.image,
    this.imageUrl,
    this.socials = const {},
  });
}
