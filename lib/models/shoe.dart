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