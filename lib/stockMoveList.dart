import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'productDetails.dart';
import 'product.dart';
import 'drawer_widget.dart';
import 'package:intl/intl.dart';
import 'bottom_navigation_bar_widget.dart';

class StockMoveList extends StatefulWidget {
  String selectedFromLocation;
  String selectedToLocation;

  StockMoveList({
    required this.selectedFromLocation,
    required this.selectedToLocation,
  });

  @override
  _StockMoveListState createState() => _StockMoveListState();
}

class _StockMoveListState extends State<StockMoveList> {
  int _currentIndex = 2;
  late List<Product> _products;
  late List<Product> _filteredProducts;
  TextEditingController _searchController = TextEditingController();
  late Timer _timer;
  late Map<int, TextEditingController> _quantityControllers = {};
  List<String> locations = [];

  @override
  void initState() {
    super.initState();
    _products = [];
    _filteredProducts = [];
    _loadProducts();
    _startTimer();
    fetchLocations();
  }

  @override
  void dispose() {
    _timer.cancel();
    // Dispose all quantity controllers
    _quantityControllers.values.forEach((controller) => controller.dispose());
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
        // Initialize quantity controllers for each product
        _quantityControllers.clear();
        for (int i = 0; i < _filteredProducts.length; i++) {
          _quantityControllers[i] = TextEditingController(text: '0');
        }
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

  void fetchLocations() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/locations'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<String> fetchedLocations = [];
      for (var location in data) {
        fetchedLocations.add(location['Name']);
      }
      setState(() {
        locations = fetchedLocations;
      });
    } else {
      throw Exception('Failed to fetch locations');
    }
  }

  @override
  Widget build(BuildContext context) {
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
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
                    SizedBox(width: 30),
                    // Add space between the logo and the product list title
                    Text(
                      'Stock Move',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                // Add space between the title and locations
              ],
            ),
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
                Container(
                  color: Colors.grey.shade300, // Set backdrop color
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButton<String>(
                        hint: Text('From Location'),
                        value: widget.selectedFromLocation,
                        // Accessing from widget property
                        onChanged: (String? newValue) {
                          setState(() {
                            widget.selectedFromLocation =
                                newValue ?? ''; // Update via widget property
                          });
                        },
                        items: locations
                            .where((value) =>
                                value !=
                                widget
                                    .selectedToLocation) // Accessing from widget property
                            .map<DropdownMenuItem<String>>(
                              (String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ),
                            )
                            .toList(),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_circle_right_outlined,
                        size: 35,
                      ),
                      SizedBox(width: 8),
                      DropdownButton<String>(
                        hint: Text('To Location'),
                        value: widget.selectedToLocation,
                        // Accessing from widget property
                        onChanged: (String? newValue) {
                          setState(() {
                            widget.selectedToLocation =
                                newValue ?? ''; // Update via widget property
                          });
                        },

                        items: locations
                            .where((value) =>
                                value !=
                                widget
                                    .selectedFromLocation) // Accessing from widget property
                            .map<DropdownMenuItem<String>>(
                              (String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView.builder(
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      return GestureDetector(
                        onTap: () {
                          _navigateToProductDetails(product);
                        },
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          leading: product.productImage1 != null &&
                                  product.productImage1!.isNotEmpty
                              ? Image.network(
                                  product.productImage1!,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                )
                              : Icon(Icons.image, size: 80, color: Colors.grey),
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
                                    ? (product.brand.length > 18
                                        ? '${product.brand.substring(0, 18)}...'
                                        : '${product.brand}')
                                    : 'Generic',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
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
                                              (currentQuantity - 1).toString();
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
                                          _filteredProducts[index]
                                                  .requiredQuantity =
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
              ],
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
        backgroundColor: Colors.green,
        onPressed: () {},
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
