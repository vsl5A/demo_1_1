import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testtwo/screens/product_list.dart';

import 'cubit/product_cubit.dart';

void main() {
  runApp(MaterialApp(
    home: BlocProvider(
      create: (context) => ProductCubit(), // CounterCubit sẽ được sử dụng ở cấp cao nhất của ứng dụng
      child: const ProductList(),
    ),
  )
    ,
  );
}

