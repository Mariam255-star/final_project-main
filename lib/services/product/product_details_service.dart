import '../../models/product_model.dart';

class ProductDetailsService {
 
  static String formatPrice(double price) {
    return '${price.toStringAsFixed(2)} EGP';
  }

 
  static int getRatingStarsCount(double rating) {
    return rating.round();
  }

 
  static bool hasDiscount(Product product) {
    return product.price > 0; // ممكن نضيف discount في API بعدين
  }

  
  static double getDiscountPercentage(Product product) {
    return 0.0; // لو ضفتي discount في API نعدلها
  }

  
  static String getAvailabilityStatus(Product product) {
    return 'In Stock'; // لو ضفتي stock في API نربطه هنا
  }

 
  static String getCategoryDisplayName(String category) {
    switch (category) {
      case 'skincare':
        return 'Skin Care';
      case 'haircare':
        return 'Hair Care';
      case 'pharmacy':
        return 'Pharmacy';
      default:
        return category.toUpperCase();
    }
  }

  
  static bool isValidProduct(Product product) {
    return product.name.isNotEmpty &&
        product.image.isNotEmpty &&
        product.price > 0;
  }

 
  static List<Map<String, String>> getSpecifications(Product product) {
    return [
      {'label': 'Brand', 'value': product.brand},
      {'label': 'Price', 'value': formatPrice(product.price)},
      {'label': 'Category', 'value': getCategoryDisplayName(product.category)},
      {'label': 'SKU', 'value': product.id},
    ];
  }

 
  static String getRatingDisplayText(double rating) {
    return '$rating / 5';
  }

  
  static bool isExcellentRating(double rating) {
    return rating >= 4.5;
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
