import 'package:testtwo/cubit/product_detail_state.dart';
import 'package:testtwo/models/product.dart';

import 'all_products_state.dart';
import 'error_state.dart';
import 'init_state.dart';
import 'loading_state.dart';

class ProductState{
  const ProductState();
  factory ProductState.init() => InitState();
  factory ProductState.loading() => LoadingState();
  factory ProductState.all(List<Product> products) => AllProductsState(products);
  factory ProductState.detail(int id) => ProductDetailState(id);
  factory ProductState.error(String error) => ErrorState(error);
}