import 'product_model.dart';

class Pharmacy {
  final String id;
  final String name;
  final String image;
  final String description;
  final String deliveryTime;
  final List<Product> products; 

  Pharmacy({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.deliveryTime,
    required this.products, 
  });

  factory Pharmacy.fromJson(Map<String, dynamic> json) {
    return Pharmacy(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      image: json['image'] ?? 'https://via.placeholder.com/150',
      description: json['description'] ?? 'Your Health Partner',
      deliveryTime: json['delivery_time'] ?? '30 min',
      products: json['products'] != null
          ? (json['products'] as List)
              .map((e) => Product.fromJson(e))
              .toList()
          : [],
    );
  }
}
