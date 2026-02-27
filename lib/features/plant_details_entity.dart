class PlantDetailsEntity {
  final int id;
  final String commonName;
  final List<String> scientificName;
  final String description;
  final String imageUrl;
  final String watering;
  final String careLevel;
  final String cycle;
  final String sunlight;

  PlantDetailsEntity({
    required this.id,
    required this.commonName,
    required this.scientificName,
    required this.description,
    required this.imageUrl,
    required this.watering,
    required this.careLevel,
    required this.cycle,
    required this.sunlight,
  });

  factory PlantDetailsEntity.fromJson(Map<String, dynamic> json) {
    List<String> parseStringList(dynamic value) {
      if (value is List) {
        return value.map((e) => e.toString()).toList();
      } else if (value is String) {
        return [value];
      }
      return [];
    }

    String parseString(dynamic value) {
      if (value is List && value.isNotEmpty) {
        return value.join(', ');
      }
      return value?.toString() ?? 'Unknown';
    }

    final String image = json['default_image']?['regular_url'] ?? '';

    return PlantDetailsEntity(
      id: json['id'] ?? 0,
      commonName: json['common_name'] ?? 'Unknown',
      scientificName: parseStringList(json['scientific_name']),
      description:
          json['description'] ?? 'No description available for this species.',
      imageUrl: image,
      watering: json['watering'] ?? 'Unknown',
      careLevel: json['care_level'] ?? 'Unknown',
      cycle: json['cycle'] ?? 'Unknown',
      sunlight: parseString(json['sunlight']),
    );
  }
}
