import 'package:testtwo/cubit/product_state.dart';

import '../models/product.dart';

class LoadedDetailState extends ProductState{
  final Product product;
  const LoadedDetailState(this.product);
}