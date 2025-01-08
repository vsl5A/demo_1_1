import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:testtwo/apis/product/product_api.dart';
import 'package:testtwo/cubit/all_products_state.dart';
import 'package:testtwo/cubit/error_state.dart';
import 'package:testtwo/cubit/init_state.dart';
import 'package:testtwo/cubit/loading_state.dart';
import 'package:testtwo/cubit/product_detail_state.dart';
import 'package:testtwo/cubit/product_state.dart';
import 'package:testtwo/utils/convert_utils.dart';

import '../apis/api_constant.dart';
import '../cubit/product_cubit.dart';
import '../models/category.dart';
import '../models/product.dart';
import 'Detail_product.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _HomePageState();
}

class _HomePageState extends State<ProductList> {
  List<Product> _products = [];
  List<Category> categories = [];
  final TextEditingController _searchController = TextEditingController();
  int _currentPage = 0;
  final _pageSize = 5;
  String? dropdownValue;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _fetchCategories();
  }

  Future<void> _fetchProducts() async {
    await context.read<ProductCubit>().fetchProducts(skip: _currentPage, limit: _pageSize,);
  }

  Future<void> _fetchMoreProducts() async {
        await context.read<ProductCubit>().fetchProducts(skip: _currentPage * _pageSize + _pageSize,limit: _pageSize);

    setState(() {
      _currentPage++;
    });
  }



  Future<void> _refreshProducts() async {
     await context.read<ProductCubit>().fetchProducts(skip: 0, limit: _pageSize);
  }

  // Hàm khởi tạo và tải danh sách categories
  Future<void> _fetchCategories() async {
    final result = await ProductApi.fetchCategories();
    setState(() {
      categories = result; // Cập nhật danh sách từ API
      if (categories.isNotEmpty) {
        dropdownValue = categories.first.slug; // Đặt giá trị mặc định
      }
    });
  }

  void _fetchProductsByCategory(String category) async {
    final baseUrl =
        Uri.parse('https://dummyjson.com/products/category/$category');
    final response = await http.get(baseUrl, headers: {
      'Content-Type': 'application/json; charset=UTF-16',
    });

    if (response.statusCode == 200) {
      final result = ConvertUtils.parseProducts(response.bodyBytes);
      setState(() {
        _products = result;
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

  Widget _buildProducts(){
    return ListView.builder(
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    '${product.thumbnail}',
                    fit: BoxFit.contain,
                    height: 80,
                    loadingBuilder:
                        (context, child, loadingProgress) {
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
                  },
                  child: const Text("Detail"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                Expanded(
                    child: TextField(
                      onChanged: (keyword) async => await handleSearching(keyword),
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
                    _fetchProducts(); // Load lại danh sách ban đầu
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
                  },
                  items: categories
                      .map<DropdownMenuItem<String>>((Category category) {
                    return DropdownMenuItem<String>(
                      value: category.slug, // Sử dụng slug làm giá trị
                      child: Text(category.name), // Hiển thị tên danh mục
                    );
                  }).toList(),
                ),
              ],
            ),
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
                child: BlocBuilder<ProductCubit, ProductState>(
                    builder: (context, state) {
                      if (state is InitState || state is LoadingState){
                        return const Center(child: CircularProgressIndicator());
                      }else if (state is ErrorState){
                        return Center(child: Text(state.error));
                      }else if (state is ProductDetailState){
                        return DetailsProduct();
                      }else{
                        _products = (state is AllProductsState) ? state.products : [];
                        return _buildProducts();
                      }
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> handleSearching(String keyword) async {
    if (keyword.isNotEmpty) {
      final searchResult = await ProductApi.getProductsByKeyword(keyword);
      setState(() {
        _products = searchResult;
      });
    } else {
      _fetchProducts();
    }
  }
}
