import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductService {
  static const String url =
      "https://898c53bd-f792-4b40-be41-2c1cb0bbf30f.mock.pstmn.io/products?page=1&limit=10";

  static Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List productsJson = data['products'];

      return productsJson
          .map((product) => Product.fromJson(product))
          .toList();
    } else {
      throw Exception("Failed to load products");
    }
  }
}
