import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cubit_couter.dart';
import '../models/Product.dart';
 // File chứa model Product của bạn

class DetailsProduct extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<DetailsProduct> {
  late Future<Product> futureProduct;

  @override
  void initState() {
    super.initState();
    // Lấy ID từ CartCubit hoặc bất kỳ nguồn nào khác
    int id = context.read<CartCubit>().state['idDetailProduct'];
    futureProduct = fetchProduct(id);
  }

  Future<Product> fetchProduct(int id) async {
    final url = Uri.parse('https://dummyjson.com/products/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Product.fromJson(jsonData);
    } else {
      throw Exception('Failed to load product');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product Details',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<Product>(
        future: futureProduct,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final product = snapshot.data!;
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
                                  style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(product.description ?? 'No Description'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child:
                                Row(
                                  children: [
                                    Text('Id: ', style: const TextStyle(fontSize: 18.0)),
                                    Text('${product.id}',style: const TextStyle(fontSize: 18.0,color: Colors.yellow)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child:
                                Row(
                                  children: [
                                    Text('Rating: ', style: const TextStyle(fontSize: 18.0)),
                                    Text('${product.rating}',style: const TextStyle(fontSize: 18.0,color: Colors.yellow)),
                                  ],
                                ),

                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Row(
                                  children: [
                                    Text('Sku: ', style: const TextStyle(fontSize: 18.0)),
                                    Text('${product.sku}',style: const TextStyle(fontSize: 18.0,color: Colors.yellow)),
                                  ],
                                ),

                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Row(
                                  children: [
                                    Text('Weight: ', style: const TextStyle(fontSize: 18.0)),
                                    Text('${product.weight}',style: const TextStyle(fontSize: 18.0,color: Colors.yellow)),
                                  ],
                                ),

                              ),
                              // dimension
                              // Row(
                              //   children: [
                              //     Padding(
                              //       padding: const EdgeInsets.all(6.0),
                              //       child: Text('dimensions:', style: const TextStyle(fontSize: 18.0)),
                              //     ),
                              //     DropdownButton<String>(
                              //       value:'${product.dimensions['width']}',
                              //       icon: const Icon(Icons.arrow_downward),
                              //       iconSize: 24,
                              //       elevation: 16,
                              //       style: const TextStyle(color: Colors.deepPurple),
                              //       underline: Container(
                              //         height: 2,
                              //         color: Colors.deepPurpleAccent,
                              //       ),
                              //       onChanged: (String? newValue) {
                              //         // setState(() {
                              //         //   dropdownValue = newValue!;
                              //         // });
                              //         // _fetchProductsByCategory(dropdownValue!);
                              //
                              //
                              //         https://dummyjson.com/products/category/smartphones
                              //         // In ra "Hello World" khi chọn một mục
                              //         //print("Hello World categoryyyyyyyyyyyyyy ${dropdownValue}");
                              //       },
                              //       items: Categories.map<DropdownMenuItem<String>>((Categorytt category) {
                              //         return DropdownMenuItem<String>(
                              //           value: category.slug, // Sử dụng slug làm giá trị
                              //           child: Text(category.name), // Hiển thị tên danh mục
                              //         );
                              //       }).toList(),
                              //     ),
                              //   ],
                              // )
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Row(
                                  children: [
                                    Text('WarrantyInformation: ', style: const TextStyle(fontSize: 18.0)),
                                    Flexible(child: Text('${product.warrantyInformation}',
                                        style: const TextStyle(fontSize: 18.0,color: Colors.yellow),
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
                                        style: const TextStyle(fontSize: 18.0, color: Colors.yellow),
                                        overflow: TextOverflow.ellipsis, // Thêm dấu "..." nếu nội dung quá dài
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
                            width: 300, // Chiều rộng cho mỗi ô review
                            margin: const EdgeInsets.symmetric(horizontal: 8.0), // Khoảng cách giữa các review
                            padding: const EdgeInsets.all(16.0), // Nội dung padding
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          ? DateTime.parse(review!['date']).toLocal().toString().split(' ')[0]
                                          : 'Unknown Date',
                                      style: const TextStyle(color: Colors.grey),
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
                          onPressed: () {
                            context.read<CartCubit>().setIsDetailProduct(false);
                          },
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Back'),
                        ),
                        // ElevatedButton.icon(
                        //   onPressed: () {
                        //     context.read<CartCubit>().addItem(product);
                        //   },
                        //   icon: const Icon(Icons.shopping_cart),
                        //   label: const Text('Order Now'),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('No data found'));
          }
        },
      ),
    );
  }
}
