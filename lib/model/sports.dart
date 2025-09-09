class Sport {
  final int id;
  final String name;
  final String image;
  final String description;
  final int popularity;

  Sport({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.popularity,
  });

  factory Sport.fromJson(Map<String, dynamic> json) => Sport(
        id: json['id'] as int,
        name: json['name'] as String,
        image: json['image'] as String,
        description: json['description'] as String,
        popularity: json['popularity'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
        'description': description,
        'popularity': popularity,
      };
}