// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import '../Schemas/product.dart';
import 'productDetails.dart';
import '../widget/drawer_widget.dart';
import '../widget/bottom_navigation_bar_widget.dart';
import 'package:http/http.dart' as http;

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  late List<Product> _products;
  late List<Product> _filteredProducts;
  late Map<int, TextEditingController> _quantityControllers; // Define _quantityControllers here
  final TextEditingController _searchController = TextEditingController();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _products = [];
    _filteredProducts = [];
    _quantityControllers = {}; // Initialize _quantityControllers here
    _loadProducts();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    const duration = Duration(seconds: 30);
    _timer = Timer.periodic(duration, (Timer t) => _loadProducts());
  }

  void _loadProducts() async {
    final response =
        await http.get(Uri.parse('http://172.20.10.8:3000/products'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _products = data.map((json) => Product.fromJson(json)).toList();
        _filteredProducts = List.from(_products); // Initialize filtered list
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

  final int _currentIndex = 0;

  void _addProduct() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final _formKey = GlobalKey<FormState>();
        String _productID = '';
        String _productName = '';
        String _brand = '';
        String? _barCode = '';
        String _category = '';
        String? _bulkPack = '';
        String _unit = '';
        String _unitConversion = '';
        String _eachUnitContains = '';
        String? _productImage1 = '';
        String? _productImage2 = '';
        String? _productImage3 = '';
        String? _specification = '';
        String? _reorderLevel = '';
        int _requiredQuantity = 0;
        

        return AlertDialog(
          title: const Text('Add New Product'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Product ID'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a product ID';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _productID = value!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Product Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a product name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _productName = value!;
                    },
                  ),
                   TextFormField(
                    decoration: const InputDecoration(labelText: 'Brand'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the brand';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _brand = value!;
                    },
                  ),
                   TextFormField(
                    decoration: const InputDecoration(labelText: 'Barcode'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the barcode';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _barCode = value!;
                    },
                  ),
                   TextFormField(
                    decoration: const InputDecoration(labelText: 'Category'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the category';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _category = value!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Unit'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the unit';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _unit = value!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'BulkPack'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the bulk pack';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _bulkPack = value!;
                    },
                  ),
                   TextFormField(
                    decoration: const InputDecoration(labelText: 'Convert Unit'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the unit coversion';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _unitConversion = value!;
                    },
                  ),
                 TextFormField(
                    decoration: const InputDecoration(labelText: 'Each Unit Contains'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the quantity per unit';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _eachUnitContains = value!;
                    },
                  ),
                 TextFormField(
                  decoration: const InputDecoration(labelText: 'Product Image 1'),
                  onSaved: (value) {
                    _productImage1 = value;
                    },
                  ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Product Image 2'),
                  onSaved: (value) {
                    _productImage2 = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Product Image 3'),
                  onSaved: (value) {
                    _productImage3 = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Specification'),
                  onSaved: (value) {
                    _specification = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Reorder Level'),
                  onSaved: (value) {
                    _reorderLevel = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Required Quantity'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the required quantity';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _requiredQuantity = int.parse(value!);
                  },
                ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
            onPressed: () async {  
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                // Make a POST request to the server to save the new product
                final response = await http.post(
                  Uri.parse('http://172.20.10.8:3000/products'),
                  body: json.encode({
                    'productID': _productID,
                    'productName': _productName,
                    'brand': _brand,
                    'barCode': _barCode,
                    'category': _category,
                    'unit': _unit,
                    'bulkPack': _bulkPack,
                    'unitConversion': _unitConversion,
                    'eachUnitContains': _eachUnitContains,
                    'productImage1': _productImage1,
                    'productImage2': _productImage2,
                    'productImage3': _productImage3,
                    'specification': _specification,
                    'reorderLevel': _reorderLevel,
                    'requiredQuantity': _requiredQuantity,               
            
            
                    // Add other fields as needed
                  }),
                  headers: {
                    'Content-Type': 'application/json',
                  },
                );

                if (response.statusCode == 201) {
                  // If the product is successfully saved on the server,
                  // reload the products from the server
                  _loadProducts();  

                  Navigator.of(context).pop(); 
                } else {
                  
                  print('Failed to add product. Status code: ${response.statusCode}');
                }
              }
            },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }


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
            const Text('Product List'),
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: Colors.grey.shade300, // Set backdrop color
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Stock Location: All',
                        style: TextStyle(fontSize: 25),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _filteredProducts.isEmpty
                      ? const Center(
                          child: Text('No products available'),
                        )
                      : SizedBox(
                          height: MediaQuery.of(context).size.height *
                              1, // Adjust height as needed
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
                                  contentPadding: const EdgeInsets.symmetric(
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
                                      : const Icon(Icons.image,
                                          size: 80, color: Colors.grey),
                                  // Display disabled icon
                                  title: Text(
                                    product.productName.isNotEmpty
                                        ? (product.productName.length > 20
                                            ? "${product.productName
                                                    .substring(0, 20)}..."
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${product.eachUnitContains} ${product.unit}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        product.brand.isNotEmpty
                                            ? product.brand
                                            : 'Generic',
                                        style: const TextStyle(
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
                                      Text(
                                        product.eachUnitContains,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _addProduct,
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _currentIndex,
      ),
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
