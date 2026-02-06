class Pharmacy {
  final String id;
  final String name;
  final String image;

  Pharmacy({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Pharmacy.fromJson(Map<String, dynamic> json) {
    return Pharmacy(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      image: json['image'] ?? 'https://via.placeholder.com/150',
    );
  }
}
