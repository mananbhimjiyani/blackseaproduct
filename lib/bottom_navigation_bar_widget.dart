import 'package:flutter/material.dart';
import 'product_list.dart';
import 'productRequest.dart';
import 'stockMove.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  AppBottomNavigationBar({
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.blue,
      selectedItemColor: Colors.white,
      currentIndex: currentIndex,
      onTap: (index) {
        // Update the currentIndex directly when an item is tapped
        // You can add your navigation logic here
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProductList()),
            );
            break;
          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProductRequest()),
            );
            break;
          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => StockMove()),
            );
            break;
        }
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Product',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt_outlined),
          label: 'Requisition',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.move_down_rounded),
          label: 'Stock Move',
        ),
      ],
    );
  }
}
