class Product {
  final String id;
  final String name;
  final String brand;
  final String category;
  final double price;
  final double rating;
  final String image;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.price,
    required this.rating,
    required this.image,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),

      // ✅ اسم المنتج (API مختلف أحيانًا)
      name: json['name'] ?? json['title'] ?? '',

      // ✅ البراند
      brand: json['brand'] ?? '',

      // ✅ الكاتيجوري
      category: json['category'] ?? '',

      // ✅ السعر
      price: (json['price'] ?? 0).toDouble(),

      // ✅ الريتينج (لو رقم أو object)
      rating: json['rating'] is Map
          ? (json['rating']['rate'] ?? 0).toDouble()
          : (json['rating'] ?? 0).toDouble(),

      // ✅ الصورة
      image: json['image'] ??
          'https://via.placeholder.com/150', // fallback لو مفيش صورة

      // ✅ الوصف
      description: json['description'] ??
          _getDefaultDescription(
            json['category'] ?? '',
            json['name'] ?? json['title'] ?? '',
          ),
    );
  }

  static String _getDefaultDescription(String category, String name) {
    final descriptions = {
      'skincare':
          'Premium $name skincare product designed to nourish and revitalize your skin.',
      'haircare':
          'Professional $name haircare product that strengthens and conditions your hair.',
      'pharmacy':
          'Trusted $name medication for effective relief. Consult your pharmacist.',
    };

    return descriptions[category] ??
        'High-quality $name product designed to meet your daily needs.';
  }
}
