import 'dart:convert';
import 'package:final_project/models/pharmacy_model.dart';
import 'package:http/http.dart' as http;


class PharmacyService {
  static const String url =
      "https://898c53bd-f792-4b40-be41-2c1cb0bbf30f.mock.pstmn.io/admin/dashboard"; // 👈 حطي لينك Postman هنا

  static Future<List<Pharmacy>> getPharmacies() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List pharmaciesJson = data['pharmacies'];

      return pharmaciesJson.map((e) => Pharmacy.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load pharmacies");
    }
  }
}
