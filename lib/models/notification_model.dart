class AppNotification {
  final String title;
  final String body;
  final String image;
  final String price;

  AppNotification({
    required this.title,
    required this.body,
    required this.image,
    required this.price,
  });

  factory AppNotification.fromFirebase(Map<String, dynamic> data) {
    return AppNotification(
      title: data['title'] ?? 'No Title',
      body: data['body'] ?? '',
      image: data['image'] ?? 'https://via.placeholder.com/150',
      price: data['price'] ?? '0',
    );
  }
}
