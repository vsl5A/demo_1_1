import 'dart:convert';

import '../models/category.dart';
import '../models/product.dart';

class ConvertUtils {
  static List<Product> parseProducts(List<int> response) {
    final Map<String, dynamic> jsonResponse =
        json.decode(utf8.decode(response));
    final List<dynamic> mapProducts = jsonResponse["products"];
    for (var map in mapProducts) {
      if (map is Map<String, dynamic>){
        if (!map.containsKey("Qty") || map["Qty"] == null) {
          map["Qty"] = 1;
        }
      }
    }

    return mapProducts.map((map) => Product.fromMap(map)).toList();
  }

  static List<Category> parseCategories(String responseBody){
    final List<dynamic> jsonResponse = json.decode(responseBody);
    return jsonResponse
        .map((map) =>
        Category.fromMap(map))
        .toList();
  }
}
