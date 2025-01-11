import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testtwo/cubit/loaded_list_state.dart';
import 'package:testtwo/cubit/product_state.dart';
import 'package:testtwo/models/category.dart';

import '../apis/product/product_api.dart';
import '../models/product.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductState.loading());

  final _pageSize = 5;
  LoadedListState? _lastLoadedListState;
  List<Category> _categories = [];
  List<List<Product>> _chunkedProducts = [];

  Future<void> fetchProducts(
      {required int page, String? searchKeyword, bool isNeedLoadCategories = false, String selectedCategory = 'All'}) async {
    try {
      emit(ProductState.loading());

      var productInfo = (searchKeyword == null)
          ? await ProductApi.fetchProducts()
          : await ProductApi.searchProducts(
              keyword: searchKeyword);

      List<Product> products = List<Product>.from(productInfo['products']);
      _chunkedProducts = products.slices(_pageSize).toList();

      int totalPages = _chunkedProducts.length;

      if (isNeedLoadCategories){
        _categories = await ProductApi.fetchAllCategories();
      }

      if (selectedCategory != 'All'){
        var filteredProductsInfo = await ProductApi.fetchFilterProducts(category: selectedCategory);
        List<Product> filteredProducts = List<Product>.from(filteredProductsInfo['products']);
        var commonProducts = products.toSet().intersection(filteredProducts.toSet()).toList();
        products = commonProducts;
        _chunkedProducts = products.isNotEmpty ? products.slices(_pageSize).toList() : [];
        totalPages = _chunkedProducts.length;
      }

      debugPrint(products.length.toString());
      debugPrint(_chunkedProducts.length.toString());
      debugPrint(page.toString());
      debugPrint(selectedCategory);

      emit(ProductState.loadedList(
          products: _chunkedProducts.isNotEmpty ? _chunkedProducts[page - 1] : [],
          categories: _categories,
          totalPage: totalPages,
          currentPage: page, selectedCategory: selectedCategory));
    } catch (e) {
      emit(ProductState.error(e.toString()));
    }
  }

  Future<void> showProductDetail(int productId) async {
    try {
      if (state is LoadedListState) {
        _lastLoadedListState = state as LoadedListState;
      }
      emit(ProductState.loading());
      var product = await ProductApi.fetchProductById(productId);
      emit(ProductState.loadedDetail(product));
    } catch (e) {
      emit(ProductState.error(e.toString()));
    }
  }

  void loadLastListState() {
    if (_lastLoadedListState != null) {
      emit(_lastLoadedListState!);
      _lastLoadedListState = null;
    }
  }
}
