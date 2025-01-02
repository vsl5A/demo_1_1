
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';





import '../cubit/cubit_couter.dart';
import '../pages/product_list.dart';





class MyHomePages extends StatefulWidget {
  const MyHomePages({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePages> {
  int _selectedIndex = 0;
  CartCubit counterCubit = CartCubit(); // Thêm Cubit mới

  static List<Widget> _widgetOptions = <Widget>[

    ProductList(),
    Text('abc'),
  Text('def'),
    //DetailsProduct(),
    //CartList(),
    //AccUser(),
    //LoginForm89()
  ];

  // Hàm _onItemTapped không cần thay đổi
  @override
  void initState() {
    super.initState();
    // Thực thi hàm khi vào giao diện này

    // Đặt tên hàm của bạn vào đây
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, Map<String, dynamic>>(
      builder: (context,state) {
        _selectedIndex = context.read<CartCubit>().state['indexWidget'];
        return Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: _widgetOptions,
          ),

          bottomNavigationBar: Builder(
            builder: (BuildContext context) {

              final hasBottomNavigationBar =
                  context.findAncestorWidgetOfExactType<BottomNavigationBar>() != null;

              return hasBottomNavigationBar
                  ? const SizedBox.shrink() // Nếu đã có, trả về một widget rỗng
                  : BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart),
                    label: 'Cart',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Account',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.blue,
                onTap: (int index) {
                  setState(() {
                    context.read<CartCubit>().setIndexWidget(index);

                  });
                  // if (index == 1) {
                  //   counterCubit.increment();
                  // }
                },
              );
            },
          ),
        );
      },
    );
  }
}



