import 'package:testtwo/cubit/loaded_detail_state.dart';
import 'package:testtwo/models/category.dart';
import 'package:testtwo/models/product.dart';

import 'loaded_list_state.dart';
import 'error_state.dart';
import 'loading_state.dart';

class ProductState {
  const ProductState();

  factory ProductState.loading() => LoadingState();

  factory ProductState.loadedList({
    required List<Product> products,
    required List<Category> categories,
    required int currentPage,
    required int totalPage,
    required String selectedCategory,
  }) =>
      LoadedListState(
          products: products,
          categories: categories,
          currentPage: currentPage,
          totalPage: totalPage,
          selectedCategory: selectedCategory);

  factory ProductState.loadedDetail(Product product) =>
      LoadedDetailState(product);

  factory ProductState.error(String error) => ErrorState(error);
}
