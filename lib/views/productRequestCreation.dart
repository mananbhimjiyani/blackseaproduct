import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'productDetails.dart';
import '../Schemas/product.dart';
import '../views/product_list.dart';
import '../views/stockMove.dart';
import '../views/stockMoveList.dart';
import '../widget/drawer_widget.dart';
import '../widget/bottom_navigation_bar_widget.dart';
import 'package:intl/intl.dart';
import '../DummyData/ProductsDummy.dart';

class ProductRequestCreation extends StatefulWidget {
  @override
  _ProductRequestCreationState createState() => _ProductRequestCreationState();
}

class _ProductRequestCreationState extends State<ProductRequestCreation> {
  late List<Product> _products;
  late List<Product> _filteredProducts;
  late Map<int, TextEditingController> _quantityControllers = {};
  TextEditingController _searchController = TextEditingController();
  late Timer _timer;
  String? _selectedValue;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _products = [];
    _filteredProducts = [];
    _loadProducts();
    _startTimer();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _timer.cancel();
    _quantityControllers.values.forEach((controller) => controller.dispose());
    _focusNode.dispose(); // Dispose the focus node
    super.dispose();
  }

  void _startTimer() {
    const duration = Duration(seconds: 30);
    _timer = Timer.periodic(duration, (Timer t) {
      // Check if any text field is focused
      bool isTextFieldFocused = _quantityControllers.values.any((controller) =>
          controller.text.isNotEmpty &&
          controller.selection.baseOffset != -1 &&
          _focusNode.hasFocus); // Check if any text field is focused
      if (!isTextFieldFocused) {
        _loadProducts();
      } else {
        t.cancel();
      }
    });
  }

  void _loadProducts() async {
    List<Product> dummyProducts = generateDummyProducts();
    setState(() {
      _products = dummyProducts;
      _filteredProducts = List.from(_products);
      _quantityControllers = Map.fromIterable(_products,
          key: (product) => _products.indexOf(product),
          value: (product) => TextEditingController());
    });
    // final response =
    //     await http.get(Uri.parse('http://172.20.10.8:3000/products'));
    // if (response.statusCode == 200) {
    //   final List<dynamic> data = json.decode(response.body);
    //   setState(() {
    //     _products = data.map((json) => Product.fromJson(json)).toList();
    //     _filteredProducts = List.from(_products); // Initialize filtered list
    //     // Initialize quantity controllers
    //     _quantityControllers = Map.fromIterable(_products,
    //         key: (product) => _products.indexOf(product),
    //         value: (product) => TextEditingController());
    //   });
    // } else {
    //   throw Exception('Failed to load products');
    // }

  }

  void _filterProducts(String query) {
    setState(() {
      _filteredProducts = _products
          .where((product) =>
              product.productName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _navigateToProductDetails(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProductDetailsView(product: product)),
    );
  }

  @override
  Widget build(BuildContext context) {
    late TextEditingController _quantityController =
        TextEditingController(text: '0');
    int quantityRequired = 0;
    int _currentIndex = 1;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // Disable the automatic drawer button
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu), // Use the menu icon for the drawer
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the drawer
              },
            );
          },
        ),
        title: Row(
          children: [
            SizedBox(width: 8),
            // Add space between the menu icon and the logo
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/images/appbar.png',
                height: 40,
              ),
            ),
            SizedBox(width: 8),
            // Add space between the logo and the product list title
            Text('Request Creation',
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: _ProductSearchDelegate(_filterProducts,
                    _filteredProducts, _navigateToProductDetails),
              );
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _filteredProducts.isEmpty
          ? Center(
              child: Text('No products available'),
            )
          : Column(
              children: [
                // Container(
                //   color: Colors.grey.shade300, // Set backdrop color
                //   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       if (_selectedValue != 'Create New Request')
                //         Text(
                //           DateFormat('yyyy-MM-dd').format(DateTime.now()),
                //           style: TextStyle(
                //             fontWeight: FontWeight.bold,
                //             fontSize: 20,
                //           ),
                //         ),
                //       Container(
                //         alignment: Alignment.center,
                //         child: DropdownButton<String>(
                //           hint: Text('Request'),
                //           value: _selectedValue,
                //           alignment: Alignment.center,
                //           onChanged: (String? newValue) {
                //             setState(() {
                //               _selectedValue = newValue;
                //             });
                //           },
                //           items: [
                //             DropdownMenuItem<String>(
                //               value: 'Create New Request',
                //               child: Center(child: Text('Create New Request')),
                //             ),
                //             DropdownMenuItem<String>(
                //               value: '1',
                //               child: Center(child: Text('1')),
                //             ),
                //             DropdownMenuItem<String>(
                //               value: '2',
                //               child: Center(child: Text('2')),
                //             ),
                //             DropdownMenuItem<String>(
                //               value: '3',
                //               child: Center(child: Text('3')),
                //             ),
                //             DropdownMenuItem<String>(
                //               value: '4',
                //               child: Center(child: Text('4')),
                //             ),
                //             DropdownMenuItem<String>(
                //               value: '5',
                //               child: Center(child: Text('5')),
                //             ),
                //             DropdownMenuItem<String>(
                //               value: '6',
                //               child: Center(child: Text('6')),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                Flexible(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 1,
                    child: ListView.builder(
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = _filteredProducts[index];
                        return GestureDetector(
                          onTap: () {
                            // Navigate to product details page
                            _navigateToProductDetails(product);
                          },
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16),
                            // Adjust padding as needed
                            leading: product.productImage1 != null &&
                                    product.productImage1!.isNotEmpty
                                ? Image.network(
                                    product.productImage1!,
                                    width: 80, // Increase image width
                                    height: 80, // Increase image height
                                    fit: BoxFit.cover,
                                  )
                                : Icon(Icons.image,
                                    size: 80, color: Colors.grey),
                            // Display disabled icon
                            title: Text(
                              product.productName.isNotEmpty
                                  ? (product.productName.length > 20
                                      ? product.productName.substring(0, 20) +
                                          "..."
                                      : product.productName)
                                  : 'Product Name Unavailable',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: product.productName.isNotEmpty
                                    ? Colors.black
                                    : Colors.red,
                              ),
                            ),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.eachUnitContains + ' ' + product.unit,
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  product.brand.isNotEmpty
                                      ? '${product.brand}'
                                      : 'Generic',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              _navigateToProductDetails(product);
                            },
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.remove,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        final currentQuantity = int.tryParse(
                                                _quantityControllers[index]
                                                        ?.text ??
                                                    '0') ??
                                            0;
                                        if (currentQuantity > 0) {
                                          setState(() {
                                            _quantityControllers[index]?.text =
                                                (currentQuantity - 1)
                                                    .toString();
                                          });
                                        }
                                      },
                                    ),
                                    SizedBox(width: 4),
                                    Container(
                                      width: 50,
                                      child: TextFormField(
                                        controller: _quantityControllers[index],
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            product.requiredQuantity =
                                                int.tryParse(value) ?? 0;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    IconButton(
                                      icon: Icon(
                                        Icons.add,
                                        color: Colors.green,
                                      ),
                                      onPressed: () {
                                        final currentQuantity = int.tryParse(
                                                _quantityControllers[index]
                                                        ?.text ??
                                                    '0') ??
                                            0;
                                        setState(() {
                                          _quantityControllers[index]?.text =
                                              (currentQuantity + 1).toString();
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: _selectedValue == 'Create New Request'
          ? FloatingActionButton(
              onPressed: () {
                // Action when other values are selected
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              backgroundColor: Colors.blue,
            )
          : FloatingActionButton(
              onPressed: () {
                // Action when 'Create New Request' is selected
              },
              child: Icon(
                Icons.check,
                color: Colors.white,
              ),
              backgroundColor: Colors.green,
            ),
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: _currentIndex),
    );
  }
}

class _ProductSearchDelegate extends SearchDelegate<String> {
  final Function(String) filterCallback;
  final List<Product> filteredProducts;
  final Function(Product) navigateToProductDetails;

  _ProductSearchDelegate(this.filterCallback, this.filteredProducts,
      this.navigateToProductDetails);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
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
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView.builder(
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return ListTile(
          title: Text(product.productName),
          onTap: () {
            _navigateToProductDetails(context, product);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Product> suggestionList = query.isEmpty
        ? []
        : filteredProducts
            .where((product) =>
                product.productName.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final product = suggestionList[index];
        return ListTile(
          title: Text(product.productName),
          onTap: () {
            _navigateToProductDetails(
                context, product); // Navigate to product details view
          },
        );
      },
    );
  }

  void _navigateToProductDetails(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProductDetailsView(product: product)),
    );
  }
}
