import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../Schemas/product.dart';
import 'productDetails.dart';
import '../widget/drawer_widget.dart';
import '../widget/bottom_navigation_bar_widget.dart';
import '../DummyData/ProductsDummy.dart';

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  late List<Product> _products;
  late List<Product> _filteredProducts;
  late Map<int, TextEditingController> _quantityControllers; // Define _quantityControllers here
  TextEditingController _searchController = TextEditingController();
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

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable the automatic drawer button
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
              child: SizedBox(
                height: 40,
                width: 40, // Specify the desired width
                child: Image.asset(
                  'assets/images/appbar2.jpeg',
                  fit: BoxFit.cover, // Adjust the fit as needed
                ),
              ),
            ),
            SizedBox(width: 8),
            // Add space between the logo and the product list title
            Text('List'),
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
                Container(
                  color: Colors.grey.shade300, // Set backdrop color
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Column(
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
                      ? Center(
                          child: Text('No products available'),
                        )
                      : Container(
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
                                            ? product.productName
                                                    .substring(0, 20) +
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.eachUnitContains +
                                            ' ' +
                                            product.unit,
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
                                      Text(
                                        product.eachUnitContains,
                                        style: TextStyle(
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
        onPressed: () {},
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
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
