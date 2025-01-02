import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:http/http.dart' as http;



import '../Constants/constants.dart';
import '../cubit/cubit_couter.dart';
import '../models/Category.dart';
import '../models/Product.dart';
import 'Detail_product.dart';







class ProductList extends StatefulWidget {
  const ProductList({super.key
  });

  @override
  State<ProductList> createState() => _HomePageState();
}


class _HomePageState extends State<ProductList> {
  late Future<List<Product>> futureProducts;
  late Future<List<Categorytt>> futureCategories;
  List<Product> products = [];
  List<Categorytt> Categories = [];
  final TextEditingController _searchController = TextEditingController();
  int currentPage = 0;
  final int pageSize = 5;

  bool isLoading = false;
  String? dropdownValue;


  @override
  void initState() {
    super.initState();
    _fetchInitialProducts();

    _searchController.addListener(() async {
      final query = _searchController.text;

      if (query.isNotEmpty) {
        final baseUrl = Uri.parse(
            'https://dummyjson.com/products/search?q=$query');
        final response = await http.get(baseUrl, headers: {
          'Content-Type': 'application/json; charset=UTF-16',
        });

        if (response.statusCode == 200) {
          final result = _parseProducts(response.bodyBytes);

          setState(() {
            products = result; // Cập nhật danh sách sản phẩm hiển thị
          });
        } else {
          print("Error fetching search results: ${response.statusCode}");
        }
      } else {
        // Nếu ô tìm kiếm rỗng, hiển thị lại danh sách ban đầu
        _fetchInitialProducts();
      }
    });
    _fetchInitialCategories();

  }

  void _fetchInitialProducts() {
    setState(() {
      futureProducts = fetchProducts(currentPage, pageSize);
      futureProducts.then((newProducts) {
        setState(() {
          products.clear();
          products.addAll(newProducts);
        });
      });
    });
  }

  void _fetchMoreProducts() {
    setState(() {
      isLoading = true;
    });

    fetchProducts(currentPage * pageSize + pageSize, pageSize).then((newProducts) {
      setState(() {
        currentPage++;
        products.clear();
        products.addAll(newProducts);
        isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<List<Product>> fetchProducts(int skip, int limit) async {
    final baseUrl = Uri.parse(
        'https://dummyjson.com/products?limit=$limit&skip=$skip');
    final response = await http.get(baseUrl, headers: {
      'Content-Type': 'application/json; charset=UTF-16',
    });

    if (response.statusCode == 200) {
      return _parseProducts(response.bodyBytes);
    }

    throw Exception('Failed to load Product');
  }

  Future<void> _refreshProducts() async {
    final result = fetchProducts(0, pageSize);
    setState(() {
      futureProducts = result;
    });
  }

  List<Product> _parseProducts(List<int> response) {
    final Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response));
    final List<dynamic> content = jsonResponse["products"];
    for (var item in content) {
      if (item is Map<String, dynamic>) {
        if (!item.containsKey("Qty") || item["Qty"] == null) {
          item["Qty"] = 1;
        }
      }
    }

    return content.map<Product>((json) => Product.fromJson(json)).toList();
  }
  Future<List<Categorytt>> _fetchCategories() async {
    final baseUrl = Uri.parse('https://dummyjson.com/products/categories');
    final response = await http.get(baseUrl, headers: {
      'Content-Type': 'application/json; charset=UTF-16',
    });

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((category) => Categorytt(slug: category['slug'], name: category['name'], url: category['url']))
          .toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // Hàm khởi tạo và tải danh sách categories
  void _fetchInitialCategories() {
    futureCategories = _fetchCategories();
    futureCategories.then((fetchedCategories) {
      setState(() {
        Categories = fetchedCategories; // Cập nhật danh sách từ API
        if (Categories.isNotEmpty) {
          dropdownValue = Categories.first.slug; // Đặt giá trị mặc định
        }
      });
    });
  }
  void _fetchProductsByCategory(String category) async {
    final baseUrl = Uri.parse('https://dummyjson.com/products/category/$category');
    final response = await http.get(baseUrl, headers: {
      'Content-Type': 'application/json; charset=UTF-16',
    });

    if (response.statusCode == 200) {
      final result = _parseProducts(response.bodyBytes);
      setState(() {
        products = result; // Cập nhật danh sách sản phẩm theo danh mục
      });
    } else {
      print("Error fetching products by category: ${response.statusCode}");
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget buildList(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store Products'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Row(
              children: [
                Expanded(child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search products',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                )),

                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _fetchInitialProducts(); // Load lại danh sách ban đầu
                  },
                ),
                DropdownButton<String>(
    value: dropdownValue,
    icon: const Icon(Icons.arrow_downward),
    iconSize: 24,
    elevation: 16,
    style: const TextStyle(color: Colors.deepPurple),
    underline: Container(
    height: 2,
    color: Colors.deepPurpleAccent,
    ),
    onChanged: (String? newValue) {
    setState(() {
    dropdownValue = newValue!;
    });
    _fetchProductsByCategory(dropdownValue!);


    https://dummyjson.com/products/category/smartphones
    // In ra "Hello World" khi chọn một mục
    print("Hello World categoryyyyyyyyyyyyyy ${dropdownValue}");
    },
    items: Categories.map<DropdownMenuItem<String>>((Categorytt category) {
    return DropdownMenuItem<String>(
    value: category.slug, // Sử dụng slug làm giá trị
    child: Text(category.name), // Hiển thị tên danh mục
    );
    }).toList(),
    ),


              ],
            )
            ,
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollEndNotification) {
                  _fetchMoreProducts();
                }
                return false;
              },
              child: RefreshIndicator(
                onRefresh: _refreshProducts,
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 10,
                        ),
                        child:

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                '${product.thumbnail}',
                                fit: BoxFit.contain,
                                height: 80,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    height: 80,
                                    width: 80,
                                    color: Colors.grey.shade200,
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error);
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${product.title}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    '\$${product.price} USD',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    '${product.stock} units in stock',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    '${product.discountPercentage} discountPercentage',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                // Hàm xử lý khi nhấn nút

                                context.read<CartCubit>().setIsDetailProduct(true);
                                context.read<CartCubit>().setIdDetailProduct(product.id!);

                              },
                              child: const Text("Detail"),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                            ),
                          ],
                        ),

                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, Map<String, dynamic>>(
        builder: (context, state) {
          bool isDetailProduct = state['isDetailProduct'
          ] ?? false;
          if (!isDetailProduct) {
            return buildList(context);
          }
          else {
            return DetailsProduct();
          }
        }
    );
  }
}