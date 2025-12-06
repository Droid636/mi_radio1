class ProgramModel {
  final String id;
  final String title;
  final String description;
  final Map<String, String> schedule;
  final String image;

  const ProgramModel({
    required this.id,
    required this.title,
    required this.description,
    required this.schedule,
    required this.image,
  });
}
