class PestDiseaseEntity {
  final int id;
  final String commonName;
  final String scientificName;
  final List<String>? otherName;
  final String? family;
  final List<PestDiseaseDescription> description;
  final List<PestDiseaseSolution> solution;
  final List<String> host;

  PestDiseaseEntity({
    required this.id,
    required this.commonName,
    required this.scientificName,
    this.otherName,
    this.family,
    required this.description,
    required this.solution,
    required this.host,
  });

  factory PestDiseaseEntity.fromJson(Map<String, dynamic> json) {
    var descriptionsList = json['description'] as List<dynamic>? ?? [];
    List<PestDiseaseDescription> parsedDescriptions = descriptionsList
        .map((entry) => PestDiseaseDescription.fromJson(entry as Map<String, dynamic>))
        .toList();

    var solutionsList = json['solution'] as List<dynamic>? ?? [];
    List<PestDiseaseSolution> parsedSolutions = solutionsList
        .map((entry) => PestDiseaseSolution.fromJson(entry as Map<String, dynamic>))
        .toList();

    var hostList = json['host'] as List<dynamic>? ?? [];
    List<String> parsedHosts = hostList.map((e) => e.toString()).toList();
    
    List<String>? parsedOtherName;
    if (json['other_name'] is List) {
      parsedOtherName = (json['other_name'] as List).map((e) => e.toString()).toList();
    } else if (json['other_name'] is String) {
      parsedOtherName = [json['other_name'] as String];
    }

    String parsedScientificName = '';
    if (json['scientific_name'] is List) {
      parsedScientificName = (json['scientific_name'] as List).map((e) => e.toString()).join(', ');
    } else if (json['scientific_name'] is String) {
      parsedScientificName = json['scientific_name'] as String;
    }

    String? parsedFamily;
    if (json['family'] is List) {
      parsedFamily = (json['family'] as List).map((e) => e.toString()).join(', ');
    } else if (json['family'] is String) {
      parsedFamily = json['family'] as String;
    }

    return PestDiseaseEntity(
      id: json['id'] as int? ?? 0,
      commonName: json['common_name'] as String? ?? '',
      scientificName: parsedScientificName,
      otherName: parsedOtherName,
      family: parsedFamily,
      description: parsedDescriptions,
      solution: parsedSolutions,
      host: parsedHosts,
    );
  }
}

class PestDiseaseDescription {
  final String subtitle;
  final String description;

  PestDiseaseDescription({required this.subtitle, required this.description});

  factory PestDiseaseDescription.fromJson(Map<String, dynamic> json) {
    return PestDiseaseDescription(
      subtitle: json['subtitle'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}

class PestDiseaseSolution {
  final String subtitle;
  final String description;

  PestDiseaseSolution({required this.subtitle, required this.description});

  factory PestDiseaseSolution.fromJson(Map<String, dynamic> json) {
    return PestDiseaseSolution(
      subtitle: json['subtitle'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}
