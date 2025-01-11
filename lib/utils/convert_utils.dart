import 'dart:convert';

import '../models/category.dart';
import '../models/product.dart';

class ConvertUtils {
  static Map<String, dynamic> parseProducts(String responseBody) {
    final Map<String, dynamic> jsonResponse = json.decode(responseBody);
    final List<dynamic> mapProducts = jsonResponse['products'];
    final int totalProducts = int.tryParse(jsonResponse['total'].toString()) ?? 0 ;
    for (var map in mapProducts) {
      if (map is Map<String, dynamic>){
        if (!map.containsKey("Qty") || map["Qty"] == null) {
          map["Qty"] = 0;
        }
      }
    }

    return {
      'products': mapProducts.map((map) => Product.fromMap(map)).toList(),
      'total': totalProducts
    };
  }

  static List<Category> parseCategories(String responseBody){
    final List<dynamic> jsonResponse = json.decode(responseBody);
    return jsonResponse
        .map((map) =>
        Category.fromMap(map))
        .toList();
  }

  static Product parseProduct(String responseBody) {
    final jsonData = json.decode(responseBody);
    return Product.fromMap(jsonData);
  }
}
