
import 'dart:async';
import 'dart:convert';



import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:testtwo/pro2/models/Product.dart';
import 'package:http/http.dart' as http;

import '../Constants/constants.dart';

class CartCubit extends Cubit<Map<String, dynamic>> {
  int indexPage = 0;

  CartCubit() : super({'token': '', 'product': [],'indexWidget': 0,

    'isLogin' : true,'isDetailProduct' :false,'idDetailProduct' : 1,
    'passwordVisible' : true,'passwordComfrimVisible' : true});


  void startTokenExpiration() {
    List<Product> updatedList = List.from(state['product']);
    Timer(Duration(minutes: 30), () {
      emit({ ...state,'product': updatedList,'token': '',});
    });

}

  // double get price {
  //   List<Product> products = List.from(state['product']);
  //
  //   if (products.isEmpty) {
  //     return 0; // Hoặc giá trị mặc định khác
  //   }
  //
  //   return products.fold<int>(0, (previousValue, item) {
  //     final itemPrice = item.price ?? 0;
  //     final itemQty = item.Qty ?? 0;
  //     return previousValue + (itemPrice * itemQty);
  //   });
  // }
  double get price {
    List<Product> products = List.from(state['product'] ?? []); //Handle null state

    return products.fold<double>(0.0, (previousValue, item) {
      final itemPrice = item.price ?? 0.0;
      final itemQty = item.Qty ?? 0; //Assuming Qty is an integer
      return previousValue + (itemPrice * itemQty);
    });
  }

  void setToken ( String token) {
     List<Product> updatedList = List.from(state['product']);
     emit({ ...state,'product': updatedList,'token': token,
       });
     print('token hien tai ${state['token']}');
   }
   void setPasswordComfrimVisible () {
     List<Product> updatedList = List.from(state['product']);
     emit({...state, 'product': updatedList,
     'passwordComfrimVisible':!state['passwordComfrimVisible']});
   }
  void setIndexWidget ( int index) {
    List<Product> updatedList = List.from(state['product']);
    emit({...state, 'product': updatedList,'indexWidget' : index});
  }
  void setIndexPage (int indexPage) {
    indexPage = indexPage;
    List<Product> updatedList = List.from(state['product']);

    emit({...state, 'product': updatedList});
  }
  int getIndexPage() => indexPage;
  void setIsLogin ( bool check) {
    List<Product> updatedList = List.from(state['product']);
    emit({...state, 'product': updatedList, 'isLogin':check});
  }
  void setIsDetailProduct ( bool check) {
    List<Product> updatedList = List.from(state['product']);
    emit({...state, 'product': updatedList,
      'isDetailProduct':check});
  }
  void setIdDetailProduct ( int id) {
    List<Product> updatedList = List.from(state['product']);
    emit({...state, 'product': updatedList,
      'idDetailProduct':id});
  }
  void setPasswordVisible ( ) {
    List<Product> updatedList = List.from(state['product']);
    emit({...state, 'product': updatedList,
      'passwordVisible':!state['passwordVisible']
    });
  }
  void remove(int index) {
    List<Product> updatedList = List.from(state['product']);
    String updateToken = state['token'];
    updatedList[index].Qty = 1;
    updatedList.removeAt(index);
    emit({...state, 'product': updatedList,});
  }

  void addItem(Product item) {
    List<Product> updatedList = List.from(state['product']);

    bool isUpdated = false;
    if (state['product'].isNotEmpty) {
      for (var element in updatedList) {
        if (element.id == item.id) {
          if (element.Qty != null) {
            if (element.Qty! < element.stock!) {
              element.Qty = (element.Qty! + 1);
            }
          }
          isUpdated = true;
        }
      }
    }

    if (!isUpdated) {
      updatedList.add(item);
    }
   //print('check product list order ${state['product'].length}');
    emit({...state, 'product': updatedList
      });
  }

  void clearOrder() {
    List<Product> updatedList = List.from(state['product']);
    if (state['product'].isNotEmpty) {
      for (var element in updatedList) {

          if (element.Qty != null) {
            element.Qty = 1;
          }


      }
    }
    emit({...state, 'product': []});
  }

  Future<void> checkOut() async {

    List<Product> updatedList = List.from(state['product']);
    List<Map<String, dynamic>> newList = updatedList.map((user) => {
      "productId": user.id,
      "quantity": user.Qty,
      "unitPrice": user.price,
    }).toList();

    final url = Uri.parse('${Constants.baseUrl}/orders');
    final body = {
      "total": price,
      "paymentMethod": 2,
      "orderStatus": 1,
      "details": newList
    };

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ${state['token']}',
        'Content-Type': 'application/json', // Các header khác nếu cần
      },
      body: jsonEncode(body),
    );


//200

    clearOrder();

  }


}