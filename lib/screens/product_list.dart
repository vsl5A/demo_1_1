import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testtwo/cubit/loaded_list_state.dart';
import 'package:testtwo/cubit/error_state.dart';
import 'package:testtwo/cubit/loading_state.dart';
import 'package:testtwo/cubit/product_state.dart';

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
  final List<Category> _categories = [
    Category(slug: 'All', name: 'All', url: '')
  ];
  bool _isInitializedCategories = false;
  final TextEditingController _searchController = TextEditingController();
  late ProductCubit _cubit;
  bool _isSearching = false;
  late int _currentPage;
  late int _totalPage;
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<ProductCubit>();
    _fetchAllData();
  }

  Future<void> _fetchAllData() async {
    await _cubit.fetchProducts(page: 1, isNeedLoadCategories: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _isSearching
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () async {
                  setState(() {
                    _isSearching = false;
                    _searchController.clear();
                  });
                  await _cubit.fetchProducts(
                      page: 1, selectedCategory: _selectedCategory);
                },
              )
            : null,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search product...',
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
                onChanged: _handleSearching,
                autofocus: true,
              )
            : const Text('Store Products',
                style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        actions: [
          _isSearching
              ? const SizedBox()
              : IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = true;
                    });
                  },
                  icon: const Icon(Icons.search, color: Colors.white),
                ),
          IconButton(
              onPressed: _showCategoriesDialog,
              icon: const Icon(Icons.filter_alt_rounded, color: Colors.white))
        ],
      ),
      body: BlocBuilder<ProductCubit, ProductState>(builder: (context, state) {
        if (state is LoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ErrorState) {
          return Center(child: Text(state.error));
        } else if (state is LoadedListState) {
          _products = state.products;
          if (!_isInitializedCategories) {
            _categories.addAll(state.categories);
            _isInitializedCategories = true;
          }
          _currentPage = state.currentPage;
          _totalPage = state.totalPage;
          _selectedCategory = state.selectedCategory;

          return _buildProductsPages();
        } else {
          return const SizedBox();
        }
      }),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildProductsPages() {
    return _products.isNotEmpty
        ? Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Page $_currentPage in $_totalPage pages'),
              ),
              Expanded(
                  child: NotificationListener<ScrollNotification>(
                      onNotification: _scrollProductsListener,
                      child: ListView.builder(
                        itemCount: _products.length,
                        itemBuilder: (context, index) {
                          return _buildProductItem(_products[index]);
                        },
                      )))
            ],
          )
        : const Center(
            child: Text('Don\'t have any products'),
          );
  }

  Widget _buildProductItem(Product product) {
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
                    'Category: ${product.category}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () async => await _handleDetailPressed(product.id!),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              child: const Text("Detail"),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCategoryItems() {
    return _categories
        .map((category) => Container(
              color: _selectedCategory == category.slug
                  ? Colors.blue
                  : Colors.white,
              child: SimpleDialogOption(
                onPressed: () async =>
                    await _handleSelectCategory(category.slug),
                child: Text(
                  category.name,
                  style: TextStyle(
                      color: _selectedCategory == category.slug
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ))
        .toList();
  }

  Future<void> _handleSearching(String keyword) async {
    if (keyword.isNotEmpty) {
      await _cubit.fetchProducts(
          page: 1, searchKeyword: keyword, selectedCategory: _selectedCategory);
    } else {
      await _cubit.fetchProducts(page: 1, selectedCategory: _selectedCategory);
    }
  }

  Future<void> _handleDetailPressed(int productId) async {
    final loadLastListState = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const DetailsProduct(),
            settings: RouteSettings(arguments: productId)));

    if (loadLastListState) {
      _cubit.loadLastListState();
    }
  }

  void _showCategoriesDialog() {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              backgroundColor: Colors.white,
              title: const Text('Select category:', style: TextStyle(color: Colors.blue),),
              contentPadding: const EdgeInsets.all(24),
              children: _buildCategoryItems(),
            ));
  }

  Future<void> _handleSelectCategory(String categorySlug) async {
    Navigator.pop(context);
    await _cubit.fetchProducts(
        page: 1,
        searchKeyword: _isSearching ? _searchController.text : null,
        selectedCategory: categorySlug);
  }

  bool _scrollProductsListener(ScrollNotification scrollNotification) {
    if (scrollNotification is UserScrollNotification) {
      if (scrollNotification.direction == ScrollDirection.reverse) {
        loadNextPage();
      } else if (scrollNotification.direction == ScrollDirection.forward) {
        loadPreviousPage();
      }
    }
    return false;
  }

  Future<void> loadNextPage() async {
    if (_currentPage < _totalPage) {
      await _cubit.fetchProducts(
          page: _currentPage + 1,
          searchKeyword: _isSearching ? _searchController.text : null,
          selectedCategory: _selectedCategory);
    }
  }

  Future<void> loadPreviousPage() async {
    if (_currentPage > 1) {
      await _cubit.fetchProducts(
          page: _currentPage - 1,
          searchKeyword: _isSearching ? _searchController.text : null,
          selectedCategory: _selectedCategory);
    }
  }
}
