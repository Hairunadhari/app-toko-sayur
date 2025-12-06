class Product {
  final int id;
  final DateTime createdAt;
  final String name;
  final String description;
  final int price;
  final String imageUrl;
  final int categoryId;
  final int stock;

  Product({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categoryId,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      name: json['name'],
      description: json['description'],
      price: json['price'],
      imageUrl: json['image_url'],
      categoryId: json['category_id'],
      stock: json['stock'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'category_id': categoryId,
      'stock': stock,
    };
  }
}
