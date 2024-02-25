// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:async';
// import 'productDetails.dart';
// import 'Schemas/product.dart';
// import 'product_list.dart';
// import 'stockMove.dart';
// import 'stockMoveList.dart';
// import 'widget/drawer_widget.dart';
// import 'widget/bottom_navigation_bar_widget.dart';
// import 'package:intl/intl.dart';
// import 'DummyData/ProductsDummy.dart';
//
// class ProductRequestView extends StatefulWidget {
//   @override
//   _ProductRequestViewState createState() => _ProductRequestViewState();
// }
//
// class _ProductRequestViewState extends State<ProductRequestView> {
//   late List<Product> _products;
//   late List<Product> _filteredProducts;
//   late Map<int, TextEditingController> _quantityControllers = {};
//   TextEditingController _searchController = TextEditingController();
//   late Timer _timer;
//   String? _selectedValue;
//   late FocusNode _focusNode;
//
//   @override
//   void initState() {
//     super.initState();
//     _products = [];
//     _filteredProducts = [];
//     _loadProducts();
//     _startTimer();
//     _focusNode = FocusNode();
//   }
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     _quantityControllers.values.forEach((controller) => controller.dispose());
//     _focusNode.dispose(); // Dispose the focus node
//     super.dispose();
//   }
//
//   void _startTimer() {
//     const duration = Duration(seconds: 30);
//     _timer = Timer.periodic(duration, (Timer t) {
//       // Check if any text field is focused
//       bool isTextFieldFocused = _quantityControllers.values.any((controller) =>
//           controller.text.isNotEmpty &&
//           controller.selection.baseOffset != -1 &&
//           _focusNode.hasFocus); // Check if any text field is focused
//       if (!isTextFieldFocused) {
//         _loadProducts();
//       } else {
//         t.cancel();
//       }
//     });
//   }
//
//   void _loadProducts() async {
//     List<Product> dummyProducts = generateDummyProducts();
//     setState(() {
//       _products = dummyProducts;
//       _filteredProducts = List.from(_products);
//       _quantityControllers = Map.fromIterable(_products,
//           key: (product) => _products.indexOf(product),
//           value: (product) => TextEditingController());
//     });
//     // final response =
//     //     await http.get(Uri.parse('http://172.20.10.8:3000/products'));
//     // if (response.statusCode == 200) {
//     //   final List<dynamic> data = json.decode(response.body);
//     //   setState(() {
//     //     _products = data.map((json) => Product.fromJson(json)).toList();
//     //     _filteredProducts = List.from(_products); // Initialize filtered list
//     //     // Initialize quantity controllers
//     //     _quantityControllers = Map.fromIterable(_products,
//     //         key: (product) => _products.indexOf(product),
//     //         value: (product) => TextEditingController());
//     //   });
//     // } else {
//     //   throw Exception('Failed to load products');
//     // }
//
//   }
//
//   void _filterProducts(String query) {
//     setState(() {
//       _filteredProducts = _products
//           .where((product) =>
//               product.productName.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     });
//   }
//
//   void _navigateToProductDetails(Product product) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//           builder: (context) => ProductDetailsView(product: product)),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     late TextEditingController _quantityController =
//         TextEditingController(text: '0');
//     int quantityRequired = 0;
//     int _currentIndex = 1;
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         // Disable the automatic drawer button
//         leading: Builder(
//           builder: (BuildContext context) {
//             return IconButton(
//               icon: Icon(Icons.menu), // Use the menu icon for the drawer
//               onPressed: () {
//                 Scaffold.of(context).openDrawer(); // Open the drawer
//               },
//             );
//           },
//         ),
//         title: Row(
//           children: [
//             SizedBox(width: 8),
//             // Add space between the menu icon and the logo
//             Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Image.asset(
//                 'assets/images/appbar.png',
//                 height: 40,
//               ),
//             ),
//             SizedBox(width: 8),
//             // Add space between the logo and the product list title
//             Text('Request View',
//                 style:
//                     TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
//           ],
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.search),
//             onPressed: () {
//               showSearch(
//                 context: context,
//                 delegate: _ProductSearchDelegate(_filterProducts,
//                     _filteredProducts, _navigateToProductDetails),
//               );
//             },
//           ),
//         ],
//       ),
//       drawer: AppDrawer(),
//       body: _filteredProducts.isEmpty
//           ? Center(
//               child: Text('No products available'),
//             )
//           : Column(
//               children: [
//                 Container(
//                   color: Colors.grey.shade300, // Set backdrop color
//                   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       if (_selectedValue != 'Create New Request')
//                         Text(
//                           DateFormat('yyyy-MM-dd').format(DateTime.now()),
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 20,
//                           ),
//                         ),
//                       Container(
//                         alignment: Alignment.center,
//                         child: DropdownButton<String>(
//                           hint: Text('Request'),
//                           value: _selectedValue,
//                           alignment: Alignment.center,
//                           onChanged: (String? newValue) {
//                             setState(() {
//                               _selectedValue = newValue;
//                             });
//                           },
//                           items: [
//                             DropdownMenuItem<String>(
//                               value: 'Create New Request',
//                               child: Center(child: Text('Create New Request')),
//                             ),
//                             DropdownMenuItem<String>(
//                               value: '1',
//                               child: Center(child: Text('1')),
//                             ),
//                             DropdownMenuItem<String>(
//                               value: '2',
//                               child: Center(child: Text('2')),
//                             ),
//                             DropdownMenuItem<String>(
//                               value: '3',
//                               child: Center(child: Text('3')),
//                             ),
//                             DropdownMenuItem<String>(
//                               value: '4',
//                               child: Center(child: Text('4')),
//                             ),
//                             DropdownMenuItem<String>(
//                               value: '5',
//                               child: Center(child: Text('5')),
//                             ),
//                             DropdownMenuItem<String>(
//                               value: '6',
//                               child: Center(child: Text('6')),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Flexible(
//                   child: Container(
//                     height: MediaQuery.of(context).size.height * 1,
//                     child: ListView.builder(
//                       itemCount: _filteredProducts.length,
//                       itemBuilder: (context, index) {
//                         final product = _filteredProducts[index];
//                         return GestureDetector(
//                           onTap: () {
//                             // Navigate to product details page
//                             _navigateToProductDetails(product);
//                           },
//                           child: ListTile(
//                             contentPadding: EdgeInsets.symmetric(
//                                 vertical: 10, horizontal: 16),
//                             // Adjust padding as needed
//                             leading: product.productImage1 != null &&
//                                     product.productImage1!.isNotEmpty
//                                 ? Image.network(
//                                     product.productImage1!,
//                                     width: 80, // Increase image width
//                                     height: 80, // Increase image height
//                                     fit: BoxFit.cover,
//                                   )
//                                 : Icon(Icons.image,
//                                     size: 80, color: Colors.grey),
//                             // Display disabled icon
//                             title: Text(
//                               product.productName.isNotEmpty
//                                   ? (product.productName.length > 20
//                                       ? product.productName.substring(0, 20) +
//                                           "..."
//                                       : product.productName)
//                                   : 'Product Name Unavailable',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                                 color: product.productName.isNotEmpty
//                                     ? Colors.black
//                                     : Colors.red,
//                               ),
//                             ),
//                             subtitle: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   product.eachUnitContains + ' ' + product.unit,
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                                 Text(
//                                   product.brand.isNotEmpty
//                                       ? '${product.brand}'
//                                       : 'Generic',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             onTap: () {
//                               _navigateToProductDetails(product);
//                             },
//                             trailing: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   children: [
//                                     IconButton(
//                                       icon: Icon(
//                                         Icons.remove,
//                                         color: Colors.red,
//                                       ),
//                                       onPressed: () {
//                                         final currentQuantity = int.tryParse(
//                                                 _quantityControllers[index]
//                                                         ?.text ??
//                                                     '0') ??
//                                             0;
//                                         if (currentQuantity > 0) {
//                                           setState(() {
//                                             _quantityControllers[index]?.text =
//                                                 (currentQuantity - 1)
//                                                     .toString();
//                                           });
//                                         }
//                                       },
//                                     ),
//                                     SizedBox(width: 4),
//                                     Container(
//                                       width: 50,
//                                       child: TextFormField(
//                                         controller: _quantityControllers[index],
//                                         keyboardType: TextInputType.number,
//                                         textAlign: TextAlign.center,
//                                         decoration: InputDecoration(
//                                           border: OutlineInputBorder(),
//                                         ),
//                                         onChanged: (value) {
//                                           setState(() {
//                                             product.requiredQuantity =
//                                                 int.tryParse(value) ?? 0;
//                                           });
//                                         },
//                                       ),
//                                     ),
//                                     SizedBox(width: 4),
//                                     IconButton(
//                                       icon: Icon(
//                                         Icons.add,
//                                         color: Colors.green,
//                                       ),
//                                       onPressed: () {
//                                         final currentQuantity = int.tryParse(
//                                                 _quantityControllers[index]
//                                                         ?.text ??
//                                                     '0') ??
//                                             0;
//                                         setState(() {
//                                           _quantityControllers[index]?.text =
//                                               (currentQuantity + 1).toString();
//                                         });
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: 8),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//       floatingActionButton: _selectedValue == 'Create New Request'
//           ? FloatingActionButton(
//               onPressed: () {
//                 // Action when other values are selected
//               },
//               child: Icon(
//                 Icons.add,
//                 color: Colors.white,
//               ),
//               backgroundColor: Colors.blue,
//             )
//           : FloatingActionButton(
//               onPressed: () {
//                 // Action when 'Create New Request' is selected
//               },
//               child: Icon(
//                 Icons.check,
//                 color: Colors.white,
//               ),
//               backgroundColor: Colors.green,
//             ),
//       bottomNavigationBar: AppBottomNavigationBar(currentIndex: _currentIndex),
//     );
//   }
// }
//
// class _ProductSearchDelegate extends SearchDelegate<String> {
//   final Function(String) filterCallback;
//   final List<Product> filteredProducts;
//   final Function(Product) navigateToProductDetails;
//
//   _ProductSearchDelegate(this.filterCallback, this.filteredProducts,
//       this.navigateToProductDetails);
//
//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//           filterCallback(query);
//         },
//       ),
//     ];
//   }
//
//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, '');
//       },
//     );
//   }
//
//   @override
//   Widget buildResults(BuildContext context) {
//     return ListView.builder(
//       itemCount: filteredProducts.length,
//       itemBuilder: (context, index) {
//         final product = filteredProducts[index];
//         return ListTile(
//           title: Text(product.productName),
//           onTap: () {
//             _navigateToProductDetails(context, product);
//           },
//         );
//       },
//     );
//   }
//
//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final List<Product> suggestionList = query.isEmpty
//         ? []
//         : filteredProducts
//             .where((product) =>
//                 product.productName.toLowerCase().contains(query.toLowerCase()))
//             .toList();
//
//     return ListView.builder(
//       itemCount: suggestionList.length,
//       itemBuilder: (context, index) {
//         final product = suggestionList[index];
//         return ListTile(
//           title: Text(product.productName),
//           onTap: () {
//             _navigateToProductDetails(
//                 context, product); // Navigate to product details view
//           },
//         );
//       },
//     );
//   }
//
//   void _navigateToProductDetails(BuildContext context, Product product) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//           builder: (context) => ProductDetailsView(product: product)),
//     );
//   }
// }
//

import 'dart:async';
import 'package:flutter/material.dart';
import '../Schemas/requisition.dart'; // Import the Requisition class
import '../DummyData/RequisitionDummy.dart'; // Update the path according to your file structure
import '../widget/drawer_widget.dart';
import '../widget/bottom_navigation_bar_widget.dart';
import '../Schemas/product.dart';
import '../views/productDetails.dart';
import '../views/RequisitionDetailsView.dart';

class RequisitionListView extends StatefulWidget {
  const RequisitionListView({super.key});

  @override
  _RequisitionListViewState createState() => _RequisitionListViewState();
}

class _RequisitionListViewState extends State<RequisitionListView> {
  late List<Requisition> _requisitions;
  late List<Requisition> _filteredRequisitions;
  late Map<int, TextEditingController> _quantityControllers;
  TextEditingController _searchController = TextEditingController();
  late Timer _timer;

  Widget _buildStatusIndicator(String status) {
    Color color;
    switch (status) {
      case 'Pending':
        color = Colors.orange;
        break;
      case 'Approved':
        color = Colors.green;
        break;
      case 'On Hold':
        color = Colors.redAccent;
        break;
      case 'WIP':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
        break;
    }
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      margin: const EdgeInsets.only(right: 8),
    );
  }

  @override
  void initState() {
    super.initState();
    _requisitions = [];
    _filteredRequisitions = [];
    _quantityControllers = {};
    _searchController = TextEditingController();
    _loadRequisitions();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    const duration = Duration(seconds: 30);
    _timer = Timer.periodic(duration, (Timer t) => _loadRequisitions());
  }

  void _loadRequisitions() async {
    List<Requisition> dummyRequisitions = generateDummyRequisitions();
    setState(() {
      _requisitions = dummyRequisitions;
      _filteredRequisitions = List.from(_requisitions);
      _quantityControllers = { for (var requisition in _requisitions) _requisitions.indexOf(requisition) : TextEditingController() };
    });
  }

  void _filterRequisitions(String query) {
    setState(() {
      _filteredRequisitions = _requisitions
          .where((requisition) =>
              requisition.user.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _navigateToProductDetails(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsView(product: product),
      ),
    );
  }

  final int _currentIndex = 1;
  Offset _offset = const Offset(0, double.infinity);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable the automatic drawer button
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu), // Use the menu icon for the drawer
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the drawer
              },
            );
          },
        ),
        title: Row(
          children: [
            const SizedBox(width: 8),
            // Add space between the menu icon and the logo
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 40,
                width: 40, // Specify the desired width
                child: Image.asset(
                  'assets/images/appbar2.jpeg',
                  fit: BoxFit.cover, // Adjust the fit as needed
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Add space between the logo and the product list title
            const Text('Requisition List'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: _RequisitionSearchDelegate(
                  _filterRequisitions,
                  _filteredRequisitions,
                  _navigateToProductDetails,
                ),
              );
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _filteredRequisitions.isEmpty
          ? const Center(
              child: Text('No requisitions available'),
            )
          : ListView.builder(
              itemCount: _filteredRequisitions.length,
              itemBuilder: (context, index) {
                final requisition = _filteredRequisitions[index];
                return ListTile(
                  title: Row(
                    children: [
                      Text(
                        'Req ID: ${requisition.reqID}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  subtitle: Text('User: ${requisition.user}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (requisition.status ==
                          'Delivered') // Show approved text if status is Approved
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Delivered',
                            style: TextStyle(color: Colors.green, fontSize: 20),
                          ),
                        ),
                      if (requisition.status == 'Out for Delivery')
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Out for Delivery',
                            style: TextStyle(color: Colors.brown, fontSize: 20),
                          ),
                        ),
                      if (requisition.status == 'Order Placed')
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Order Placed',
                            style: TextStyle(color: Colors.brown, fontSize: 20),
                          ),
                        ),
                      if (requisition.status != 'Delivered') ...[
                        if (requisition.status != 'Out for Delivery') ...[
                          if (requisition.status != 'Order Placed') ...[
                            _buildStatusIndicator(requisition.status),
                            IconButton(
                              icon: const Icon(Icons.check),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Requisition approved'),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Requisition Rejected'),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                // Handle edit action
                              },
                            ),
                          ],
                        ],
                      ],
                    ],
                  ),
                  onTap: () {
                    if (requisition.status != 'Delivered') {
                      if (requisition.status != 'Out for Delivery') {
                        if (requisition.status != 'Order Placed') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RequisitionDetailsView(
                                  requisition: requisition),
                            ),
                          );
                        }
                      }
                    }
                  },
                );
              },
            ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            left: _offset.dx,
            top: (_offset.dy + MediaQuery.of(context).padding.top + kToolbarHeight + 16).clamp(
              MediaQuery.of(context).padding.top + kToolbarHeight + 16, // Minimum top position
              MediaQuery.of(context).size.height - kBottomNavigationBarHeight - 16 - 56, // Maximum top position
            ),
            child: Draggable(
              feedback: FloatingActionButton(
                onPressed: () {},
                backgroundColor: Colors.blue,
                child: const Icon(Icons.add, color: Colors.white,),
              ),
              onDraggableCanceled: (velocity, offset) {
                setState(() {
                  _offset = offset;
                });
              },
              childWhenDragging: Container(),
              child: FloatingActionButton(
                onPressed: () {},
                backgroundColor: Colors.blue,
                child: const Icon(Icons.add ,color: Colors.white,),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _currentIndex,
      ),
    );
  }
}

class _RequisitionSearchDelegate extends SearchDelegate<String> {
  final Function(String) filterCallback;
  final List<Requisition> filteredRequisitions;
  final Function(Product) navigateToProductDetails;

  _RequisitionSearchDelegate(
    this.filterCallback,
    this.filteredRequisitions,
    this.navigateToProductDetails,
  );

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          filterCallback(query);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<Requisition> resultList = query.isEmpty
        ? []
        : filteredRequisitions
        .where((requisition) =>
        requisition.user.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: resultList.length,
      itemBuilder: (context, index) {
        final requisition = resultList[index];
        return ListTile(
          title: Text(
            'Req ID: ${requisition.reqID}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          subtitle: Text('User: ${requisition.user}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Requisition approved'),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Requisition rejected'),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Handle edit action
                },
              ),
            ],
          ),
          onTap: () {
            // Handle tap on a requisition item
            // You can navigate to a details screen or perform other actions here
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Requisition> suggestionList = query.isEmpty
        ? []
        : filteredRequisitions
        .where((requisition) =>
        requisition.user.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final requisition = suggestionList[index];
        return ListTile(
          title: Text('Req ID: ${requisition.reqID}'),
          subtitle: Text('User: ${requisition.user}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Requisition approved'),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Requisition rejected'),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Handle edit action
                },
              ),
            ],
          ),
          onTap: () {
            // Handle tap on a requisition item
            // You can navigate to a details screen or perform other actions here
          },
        );
      },
    );
  }
}
