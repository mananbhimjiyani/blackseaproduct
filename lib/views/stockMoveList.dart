import 'package:flutter/material.dart';
import 'dart:async';
import 'productDetails.dart';
import '../Schemas/product.dart';
import '../widget/drawer_widget.dart';
import '../widget/bottom_navigation_bar_widget.dart';
import '../DummyData/ProductsDummy.dart';
import '../DummyData/LocationDummy.dart';

class StockMoveList extends StatefulWidget {
  String selectedFromLocation;
  String selectedToLocation;

  StockMoveList({super.key, 
    required this.selectedFromLocation,
    required this.selectedToLocation,
  });

  @override
  _StockMoveListState createState() => _StockMoveListState();
}

class _StockMoveListState extends State<StockMoveList> {
  final int _currentIndex = 2;
  late List<Product> _products;
  late List<Product> _filteredProducts;
  final TextEditingController _searchController = TextEditingController();
  late Timer _timer;
  late Map<int, TextEditingController> _quantityControllers = {};
  List<String> locations = [];
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _products = [];
    _filteredProducts = [];
    _loadProducts();
    _startTimer();
    fetchLocations();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _quantityControllers.values) {
      controller.dispose();
    }
    _focusNode.dispose(); // Dispose the focus node
    super.dispose();
  }

  void _startTimer() {
    const duration = Duration(seconds: 30);
    _timer = Timer.periodic(duration, (Timer t) {
      // Check if any text field is focused
      bool isTextFieldFocused = _quantityControllers.values.any(
              (controller) =>
          controller.text.isNotEmpty &&
              controller.selection.baseOffset != -1 &&
              _focusNode.hasFocus); // Check if any text field is focused
      if (!isTextFieldFocused) {
        _loadProducts();
      } else {
        t.cancel(); // Cancel the timer if a text field is focused
      }
    });
  }

  void _loadProducts() async {
    List<Product> dummyProducts = generateDummyProducts();
    setState(() {
      _products = dummyProducts;
      _filteredProducts = List.from(_products);
      _quantityControllers = { for (var product in _products) _products.indexOf(product) : TextEditingController() };
    });
    // final response =
    //     await http.get(Uri.parse('http://172.20.10.8:3000/products'));
    // if (response.statusCode == 200) {
    //   final List<dynamic> data = json.decode(response.body);
    //   setState(() {
    //     _products = data.map((json) => Product.fromJson(json)).toList();
    //     _filteredProducts = List.from(_products); // Initialize filtered list
    //     // Initialize quantity controllers for each product
    //     _quantityControllers.clear();
    //     for (int i = 0; i < _filteredProducts.length; i++) {
    //       _quantityControllers[i] =
    //           TextEditingController(text: '');
    //     }
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

  void fetchLocations() async {
    // final response =
    //     await http.get(Uri.parse('http://172.20.10.8:3000/locations'));
    //
    // if (response.statusCode == 200) {
    //   List<dynamic> data = json.decode(response.body);
    //   List<String> fetchedLocations = [];
    //   for (var location in data) {
    //     fetchedLocations.add(location['Name']);
    //   }
    //   setState(() {
    //     locations = fetchedLocations;
    //   });
    // } else {
    //   throw Exception('Failed to fetch locations');
    // }
    List<String> dummyLocations = generateDummyLocations();

    setState(() {
      locations = dummyLocations;
    });
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
              icon: const Icon(Icons.menu), // Use the menu icon for the drawer
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
                    const SizedBox(width: 8),
                    // Add space between the menu icon and the logo
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/images/appbar.png',
                        height: 40,
                      ),
                    ),
                    const SizedBox(width: 30),
                    // Add space between the logo and the product list title
                    const Text(
                      'Stock Move',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Add space between the title and locations
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
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
      drawer: const AppDrawer(),
      body: _filteredProducts.isEmpty
          ? const Center(
              child: Text('No products available'),
            )
          : Column(
              children: [
                Container(
                  color: Colors.grey.shade300, // Set backdrop color
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButton<String>(
                        hint: const Text('From Location'),
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
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_circle_right_outlined,
                        size: 35,
                      ),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        hint: const Text('To Location'),
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
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          leading: product.productImage1 != null &&
                                  product.productImage1!.isNotEmpty
                              ? Image.network(
                                  product.productImage1!,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.image, size: 80, color: Colors.grey),
                          title: Text(
                            product.productName.isNotEmpty
                                ? (product.productName.length > 20
                                    ? "${product.productName.substring(0, 20)}..."
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
                                '${product.eachUnitContains} ${product.unit}',
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                product.brand.isNotEmpty
                                    ? (product.brand.length > 18
                                        ? '${product.brand.substring(0, 18)}...'
                                        : product.brand)
                                    : 'Generic',
                                style: const TextStyle(
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
                                    icon: const Icon(
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
                                  const SizedBox(width: 4),
                                  SizedBox(
                                    width: 50,
                                    child: TextFormField(
                                      controller: _quantityControllers[index],
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      decoration: const InputDecoration(
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
                                  const SizedBox(width: 4),
                                  IconButton(
                                    icon: const Icon(
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
                              const SizedBox(height: 8),
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
        backgroundColor: Colors.green,
        onPressed: () {},
        child: const Icon(
          Icons.check,
          color: Colors.white,
        ),
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
