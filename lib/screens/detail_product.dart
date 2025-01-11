import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testtwo/cubit/error_state.dart';
import 'package:testtwo/cubit/loading_state.dart';
import 'package:testtwo/cubit/loaded_detail_state.dart';
import 'package:testtwo/cubit/product_state.dart';

import '../cubit/product_cubit.dart';
import '../models/product.dart';

class DetailsProduct extends StatefulWidget {
  const DetailsProduct({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<DetailsProduct> {
  late Product product;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final productId = ModalRoute.of(context)!.settings.arguments as int;
    context.read<ProductCubit>().showProductDetail(productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          leading: IconButton(onPressed: handlePressedBack, icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white,)),
          title: const Text(
            'Product Detail',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: WillPopScope(child: BlocBuilder<ProductCubit, ProductState>(builder: (context, state) {
          if (state is LoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ErrorState) {
            return Center(child: Text(state.error));
          } else if (state is LoadedDetailState) {
            product = state.product;
            return SingleChildScrollView(
              child: Card(
                elevation: 5,
                margin: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1, // Phần hình ảnh chiếm 1 phần
                          child: Image.network(
                            product.images ?? '',
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          flex: 2, // Nội dung chiếm 2 phần
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  product.title ?? 'No Title',
                                  style: const TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                    product.description ?? 'No Description'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Row(
                                  children: [
                                    Text('Id: ',
                                        style: const TextStyle(fontSize: 18.0)),
                                    Text('${product.id}',
                                        style: const TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.yellow)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Row(
                                  children: [
                                    Text('Rating: ',
                                        style: const TextStyle(fontSize: 18.0)),
                                    Text('${product.rating}',
                                        style: const TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.yellow)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Row(
                                  children: [
                                    Text('Sku: ',
                                        style: const TextStyle(fontSize: 18.0)),
                                    Text('${product.sku}',
                                        style: const TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.yellow)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Row(
                                  children: [
                                    Text('Weight: ',
                                        style: const TextStyle(fontSize: 18.0)),
                                    Text('${product.weight}',
                                        style: const TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.yellow)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Row(
                                  children: [
                                    Text('WarrantyInformation: ',
                                        style: const TextStyle(fontSize: 18.0)),
                                    Flexible(
                                        child: Text(
                                            '${product.warrantyInformation}',
                                            style: const TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.yellow),
                                            overflow: TextOverflow.ellipsis)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Row(
                                  children: [
                                    const Text(
                                      'ShippingInformation: ',
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                    Flexible(
                                      child: Text(
                                        '${product.shippingInformation}',
                                        style: const TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.yellow),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 150, // Chiều cao của ô chứa
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal, // Cuộn ngang
                        itemCount: product.reviews?.length ?? 0,
                        itemBuilder: (context, index) {
                          final review = product.reviews?[index];
                          return Container(
                            width: 300,
                            // Chiều rộng cho mỗi ô review
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            // Khoảng cách giữa các review
                            padding: const EdgeInsets.all(16.0),
                            // Nội dung padding
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  review?['reviewerName'] ?? 'Anonymous',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  review?['comment'] ?? 'No comment provided',
                                  style: const TextStyle(fontSize: 14.0),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Rating: ${review?['rating'] ?? 0}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber,
                                      ),
                                    ),
                                    Text(
                                      review?['date'] != null
                                          ? DateTime.parse(review!['date'])
                                          .toLocal()
                                          .toString()
                                          .split(' ')[0]
                                          : 'Unknown Date',
                                      style:
                                      const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: handlePressedBack,
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Back'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        }), onWillPop: () async {
          handlePressedBack();
          return true;
        }
    ));
    }

  void handlePressedBack() {
    Navigator.pop(context, true);
  }
}
