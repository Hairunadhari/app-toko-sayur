class Shoe {
  final String name;
  final String price;
  final String imagePath;
  final String description;
  final String gender;
  final List<String> availableSizes;

  Shoe({
    required this.name,
    required this.price,
    required this.imagePath,
    required this.description,
    required this.gender,
    required this.availableSizes,
  });

  // Convert Shoe to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'imagePath': imagePath,
      'description': description,
      'gender': gender,
      'availableSizes': availableSizes,
    };
  }

  // Create Shoe from JSON
  factory Shoe.fromJson(Map<String, dynamic> json) {
    return Shoe(
      name: json['name'] ?? '',
      price: json['price'] ?? '0',
      imagePath: json['imagePath'] ?? '',
      description: json['description'] ?? '',
      gender: json['gender'] ?? '',
      availableSizes: List<String>.from(json['availableSizes'] ?? []),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Shoe &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          price == other.price &&
          imagePath == other.imagePath;

  @override
  int get hashCode => name.hashCode ^ price.hashCode ^ imagePath.hashCode;
}
