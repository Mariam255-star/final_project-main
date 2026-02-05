import '../../models/product_model.dart';

class ProductDetailsService {
  static String formatPrice(double price) {
    return 'SAR ${price.toStringAsFixed(2)}';
  }

  static int getRatingStarsCount(double rating) {
    return rating.toInt();
  }

  static bool hasDiscount(Product product) {
    return false;
  }

  static double getDiscountPercentage(Product product) {
    return 0.0;
  }

  static String getAvailabilityStatus(Product product) {
    return 'In Stock';
  }

  static String getCategoryDisplayName(String category) {
    return category.toUpperCase();
  }

  static bool isValidProduct(Product product) {
    return product.name.isNotEmpty &&
        product.brand.isNotEmpty &&
        product.image.isNotEmpty &&
        product.price > 0;
  }

  static List<Map<String, String>> getSpecifications(Product product) {
    return [
      {'label': 'Price', 'value': formatPrice(product.price)},
      {'label': 'Availability', 'value': getAvailabilityStatus(product)},
      {'label': 'SKU', 'value': product.id},
    ];
  }

  static String getRatingDisplayText(double rating) {
    return '$rating / 5';
  }

  static bool isExcellentRating(double rating) {
    return rating >= 4.0;
  }

  static String getRatingDescription(double rating) {
    if (rating >= 4.5) {
      return 'Excellent';
    } else if (rating >= 4.0) {
      return 'Very Good';
    } else if (rating >= 3.0) {
      return 'Good';
    } else if (rating >= 2.0) {
      return 'Fair';
    } else {
      return 'Poor';
    }
  }

  static double calculateTotalPrice(double price, {int quantity = 1}) {
    return price * quantity;
  }

  static String generateProductSummary(Product product) {
    return '''
${product.name}
Brand: ${product.brand}
Price: ${formatPrice(product.price)}
Rating: ${getRatingDisplayText(product.rating)} (${getRatingDescription(product.rating)})
Category: ${getCategoryDisplayName(product.category)}
''';
  }
}
