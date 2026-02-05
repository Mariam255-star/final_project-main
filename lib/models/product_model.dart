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
      name: json['title'] ?? json['name'] ?? '',
      brand: json['brand'] ?? json['category'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      rating: (json['rating'] is Map)
          ? (json['rating']['rate'] ?? 0).toDouble()
          : (json['rating'] ?? 0).toDouble(),
      image: json['image'] ?? 'https://via.placeholder.com/150',
      description:
          json['description'] ??
          _getDefaultDescription(json['category'] ?? '', json['name'] ?? ''),
    );
  }

  static String _getDefaultDescription(String category, String name) {
    final descriptions = {
      'skincare':
          'Premium $name skincare product designed to nourish and revitalize your skin. This product is formulated with natural ingredients to provide optimal results.',
      'haircare':
          'Professional $name haircare product that strengthens and conditions your hair. Specially formulated to restore shine and smoothness to damaged or dull hair.',
      'pharmacy':
          'Trusted $name medication for effective relief. Consult your pharmacist or doctor for proper usage and dosage.',
    };

    return descriptions[category] ??
        'High-quality $name product designed to meet your daily needs. Experience the difference with our premium formulation.';
  }
}
