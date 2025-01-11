import 'dart:convert';

import 'package:testtwo/utils/convert_utils.dart';

import '../../models/category.dart';
import '../../models/product.dart';
import '../api_constant.dart';
import 'package:http/http.dart' as http;

class ProductApi{
  static Future<Map<String, dynamic>> fetchProducts() async {
    Uri uri = Uri.parse('${ApiConstant.baseUri}/products?limit=${194}');
    final response = await http.get(uri, headers: ApiConstant.headers);

    if (response.statusCode == 200) {
      return ConvertUtils.parseProducts(response.body);
    }

    throw Exception('Fetch products failed:\n${response.statusCode} --- ${response.reasonPhrase}');
  }

  static Future<List<Category>> fetchAllCategories() async {
    final uri = Uri.parse('${ApiConstant.baseUri}/products/categories');
    final response = await http.get(uri, headers: ApiConstant.headers);

    if (response.statusCode == 200) {
      return ConvertUtils.parseCategories(response.body);
    }
    throw Exception(
        'Fetch categories failed:\n${response.statusCode} --- ${response
            .reasonPhrase}');
  }

  static Future<Map<String, dynamic>> searchProducts({required String keyword}) async {
    final uri = Uri.parse('${ApiConstant.baseUri}/products/search?q=$keyword&limit=${194}');
    final response = await http.get(uri, headers: ApiConstant.headers);

    if (response.statusCode == 200) {
      return ConvertUtils.parseProducts(response.body);
    }

    throw Exception('Search products failed:\n${response.statusCode} --- ${response.reasonPhrase}');
  }

  static Future<Product> fetchProductById(int id) async {
    final uri = Uri.parse('${ApiConstant.baseUri}/products/$id');
    final response = await http.get(uri, headers: ApiConstant.headers);

    if (response.statusCode == 200) {
      return ConvertUtils.parseProduct(response.body);
    }

    throw Exception('Fetch product by id failed:\n${response.statusCode} --- ${response.reasonPhrase}');
  }

  static Future<Map<String, dynamic>> fetchFilterProducts({required String category}) async {
    final uri = Uri.parse('${ApiConstant.baseUri}/products/category/$category');
    final response = await http.get(uri, headers: ApiConstant.headers);

    if (response.statusCode == 200) {
      return ConvertUtils.parseProducts(response.body);
    }

    throw Exception('Fetch filter products failed:\n${response.statusCode} --- ${response.reasonPhrase}');
  }
}