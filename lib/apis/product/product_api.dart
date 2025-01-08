import 'package:testtwo/utils/convert_utils.dart';

import '../../models/category.dart';
import '../../models/product.dart';
import '../api_constant.dart';
import 'package:http/http.dart' as http;

class ProductApi{
  static Future<List<Product>> fetchProducts(int skip, int limit) async {
    final uri = Uri.parse('${ApiConstant.baseUri}/products?limit=$limit&skip=$skip');
    final response = await http.get(uri, headers: ApiConstant.headers);

    if (response.statusCode == 200) {
      return ConvertUtils.parseProducts(response.bodyBytes);
    }

    throw Exception('Fetch product failed:\n${response.statusCode} --- ${response.reasonPhrase}');
  }

  static Future<List<Product>> getProductsByKeyword(String keyword) async {
    final uri = Uri.parse('${ApiConstant.baseUri}/products/search?q=$keyword');
    final response = await http.get(uri, headers: ApiConstant.headers);

    if (response.statusCode == 200) {
      return ConvertUtils.parseProducts(response.bodyBytes);
    }

    throw Exception('Get products by keyword failed:\n${response.statusCode} --- ${response.reasonPhrase}');
  }

  static Future<List<Category>> fetchCategories() async {
    final uri = Uri.parse('${ApiConstant.baseUri}/products/categories');
    final response = await http.get(uri, headers: ApiConstant.headers);

    if (response.statusCode == 200) {
      return ConvertUtils.parseCategories(response.body);
    }
    throw Exception(
        'Fetch categories failed:\n${response.statusCode} --- ${response
            .reasonPhrase}');
  }
}