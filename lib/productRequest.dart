import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'productDetails.dart';
import 'product.dart';
import 'product_list.dart';
import 'stockMove.dart';
import 'stockMoveList.dart';
import 'drawer_widget.dart';
import 'bottom_navigation_bar_widget.dart';

class _ProductRequestState extends State<ProductRequest> {
  late List<Product> _products;
  late List<Product> _filteredProducts;
  late Map<int, TextEditingController> _quantityControllers = {};
  TextEditingController _searchController = TextEditingController();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _products = [];
    _filteredProducts = [];
    _loadProducts();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _quantityControllers.values.forEach((controller) {
      controller.dispose();
    });
    super.dispose();
  }

  void _startTimer() {
    const duration = Duration(seconds: 30);
    _timer = Timer.periodic(duration, (Timer t) => _loadProducts());
  }

  void _loadProducts() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/products'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _products = data.map((json) => Product.fromJson(json)).toList();
        _filteredProducts = List.from(_products); // Initialize filtered list
        // Initialize quantity controllers
        _quantityControllers = Map.fromIterable(_products,
            key: (product) => _products.indexOf(product),
            value: (product) => TextEditingController());
      });
    } else {
      throw Exception('Failed to load products');
    }
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
            Text('Request'),
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
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

      // : Column(
      //     children: ListView.builder(
      //       itemCount: _filteredProducts.length,
      //       itemBuilder: (context, index) {
      //         final product = _filteredProducts[index];
      //         return GestureDetector(
      //           onTap: () {
      //             _navigateToProductDetails(product);
      //           },
      //           child: ListTile(
      //             contentPadding:
      //                 EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      //             // Adjust padding as needed
      //             leading: product.productImage1 != null &&
      //                     product.productImage1!.isNotEmpty
      //                 ? Image.network(
      //                     product.productImage1!,
      //                     width: 80, // Increase image width
      //                     height: 80, // Increase image height
      //                     fit: BoxFit.cover,
      //                   )
      //                 : Icon(Icons.image, size: 80, color: Colors.grey),
      //             title: Text(
      //               product.productName.isNotEmpty
      //                   ? (product.productName.length > 20
      //                       ? product.productName.substring(0, 20) + "..."
      //                       : product.productName)
      //                   : 'Product Name Unavailable',
      //               style: TextStyle(
      //                 fontSize: 14,
      //                 fontWeight: FontWeight.bold,
      //                 color: product.productName.isNotEmpty
      //                     ? Colors.black
      //                     : Colors.red,
      //               ),
      //             ),
      //             subtitle: Column(
      //               children: [
      //                 Text(
      //                   product.eachUnitContains + ' ' + product.unit,
      //                   style: TextStyle(
      //                     fontSize: 12,
      //                   ),
      //                 ),
      //                 SizedBox(height: 8), // Add some space between the two Text widgets
      //                 Text(
      //                   product.brand.isNotEmpty
      //                       ? (product.brand.length > 18
      //                       ? '${product.brand.substring(0, 18)}...'
      //                       : '${product.brand}')
      //                       : 'Generic',
      //                   style: TextStyle(
      //                     fontSize: 12,
      //                   ),
      //                 ),
      //               ],
      //             ),
      //
      //               onTap: () {
      //               // Navigate to product details page
      //               _navigateToProductDetails(product);
      //             },
      //             trailing: Row(
      //               mainAxisSize: MainAxisSize.min,
      //               children: [
      //                 IconButton(
      //                   icon: Icon(Icons.check),
      //                   onPressed: () {
      //                     // Handle edit button tap
      //                   },
      //                 ),
      //                 IconButton(
      //                   icon: Icon(Icons.close),
      //                   onPressed: () {
      //                     // Handle delete button tap
      //                   },
      //                 ),
      //               ],
      //             ),
      //           ),
      //         );
      //       },
      //     ),
      //   ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
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
            _navigateToProductDetails(
                context, product); // Navigate to product details view
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
