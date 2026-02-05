class Product {
  final String id;
  final String name;
  final String brand;
  final String category;
  final double price;
  final double rating;
  final String image; 

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.price,
    required this.rating,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['title'] ?? json['name'] ?? '',
      brand: json['brand'] ?? json['category'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      rating: (json['rating'] is Map)
          ? (json['rating']['rate'] ?? 0).toDouble()
          : (json['rating'] ?? 0).toDouble(),
      image: json['image'] ??
          'https://via.placeholder.com/150', // صورة افتراضية لو مش موجودة
    );
  }
}
