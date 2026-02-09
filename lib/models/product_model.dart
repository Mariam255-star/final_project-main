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

     
      name: json['name'] ?? json['title'] ?? 'No Name',

     
      brand: json['brand'] ?? 'Unknown Brand',

     
      category: json['category'] ?? 'general',

     
      price: (json['price'] ?? 0).toDouble(),

      
      rating: json['rating'] is Map
          ? (json['rating']['rate'] ?? 0).toDouble()
          : (json['rating'] ?? 0).toDouble(),

   
      image: _fixImageUrl(json['image']),

   
      description: json['description'] ??
          _getDefaultDescription(
            json['category'] ?? '',
            json['name'] ?? json['title'] ?? '',
          ),
    );
  }

  
  static String _fixImageUrl(String? url) {
    if (url == null || url.isEmpty) {
      return 'https://via.placeholder.com/150';
    }

   
    if (!url.endsWith('.jpg') &&
        !url.endsWith('.png') &&
        !url.endsWith('.jpeg')) {
      // return 'https://images.unsplash.com/photo-1509042239860-f550ce710b93';
    }

    return url;
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
