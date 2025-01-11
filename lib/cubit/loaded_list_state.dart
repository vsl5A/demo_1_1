import 'package:testtwo/cubit/product_state.dart';
import 'package:testtwo/models/category.dart';
import 'package:testtwo/models/product.dart';

class LoadedListState extends ProductState{
  final List<Product> products;
  final List<Category> categories;
  final int currentPage;
  final int totalPage;
  final String selectedCategory;
  LoadedListState({required this.products, required this.categories, required this.currentPage,required this.totalPage, required this.selectedCategory});
}