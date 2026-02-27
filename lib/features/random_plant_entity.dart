class RandomPlantEntity {
  final int id;
  final String name;
  final bool isIndoor;
  final String imageUrl;

  RandomPlantEntity({
    required this.id,
    required this.name,
    required this.isIndoor,
    required this.imageUrl,
  });

  factory RandomPlantEntity.fromJson(Map<String, dynamic> json) {
    final bool indoor = json['indoor'] == '1' || json['indoor'] == true;
    final String image = json['default_image']?['regular_url'] ?? '';

    return RandomPlantEntity(
      id: json['id'] ?? 0,
      name: json['common_name'] ?? 'Unknown',
      isIndoor: indoor,
      imageUrl: image,
    );
  }
}
