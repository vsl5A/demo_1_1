
import 'dart:async';
import 'dart:convert';



import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testtwo/cubit/product_state.dart';


import '../apis/product/product_api.dart';
import '../models/product.dart';

// class ProductCubit extends Cubit<Map<String, dynamic>> {
//   int indexPage = 0;
//
//   ProductCubit() : super({'token': '', 'product': [],'indexWidget': 0,
//
//     'isLogin' : true,'isDetailProduct' :false,'idDetailProduct' : 1,
//     'passwordVisible' : true,'passwordComfrimVisible' : true});
//
//   void setIsDetailProduct ( bool check) {
//     List<Product> updatedList = List.from(state['product']);
//     emit({...state, 'product': updatedList,
//       'isDetailProduct':check});
//   }
//   void setIdDetailProduct ( int id) {
//     List<Product> updatedList = List.from(state['product']);
//     emit({...state, 'product': updatedList,
//       'idDetailProduct':id});
//   }
// }

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductState.init());

  Future<void> fetchProducts({required int skip, required int limit}) async {
    try{
      emit(ProductState.loading());
      final products = await ProductApi.fetchProducts(skip, limit);
      emit(ProductState.all(products));
    }catch(e){
      emit(ProductState.error(e.toString()));
    }
  }
}