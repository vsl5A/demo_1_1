import 'package:testtwo/cubit/product_state.dart';
import 'package:testtwo/models/product.dart';

class AllProductsState extends ProductState{
  final List<Product> products;
  const AllProductsState(this.products);
}