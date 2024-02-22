import 'package:flutter/material.dart';
import 'product.dart';
import 'product_list.dart';
import 'productRequest.dart';
import 'stockMove.dart';
import 'stockMoveList.dart';

class ProductDetailsView extends StatefulWidget {
  final Product product;

  ProductDetailsView({required this.product});

  @override
  _ProductDetailsViewState createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  late TextEditingController _quantityController =
      TextEditingController(text: '0');
  int quantityRequired = 0;

  @override
  void initState() {
    super.initState();
    _quantityController =
        TextEditingController(text: quantityRequired.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: widget.product.productImage1 != null &&
                          widget.product.productImage1!.isNotEmpty
                      ? Image.network(
                          widget.product.productImage1!,
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          fit: BoxFit.cover,
                        )
                      : Icon(
                          Icons.image,
                          size: 200,
                          color: Colors.grey,
                        ),
                ),
                SizedBox(height: 16),
                Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Barcode',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8), // Add spacing between label and value
                      Text(
                        widget.product.barCode?.isNotEmpty ?? false
                            ? widget.product.barCode!
                            : 'N/A',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Product:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.product.productName.isNotEmpty
                                ? widget.product.productName
                                : 'N/A',
                            style: TextStyle(fontSize: 16),
                          ),
                        ]),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Brand:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 23,
                          ),
                          Text(
                            widget.product.brand.isNotEmpty
                                ? widget.product.brand
                                : 'N/A',
                            style: TextStyle(fontSize: 16),
                          ),
                        ])
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Unit:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.product.unit ?? 'N/A',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bulk Pack:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.product.bulkPack.toString(),
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Conversion:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.product.unitConversion.toString() ?? 'N/A',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'Each Unit Contains:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.product.unitConversion.toString() ?? 'N/A',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Stock ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.product.eachUnitContains ?? 'N/A',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Required',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.remove,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  if (quantityRequired > 0) {
                                    setState(() {
                                      quantityRequired--;
                                      _quantityController.text =
                                          quantityRequired.toString();
                                    });
                                  }
                                },
                              ),
                              SizedBox(width: 8),
                              Container(
                                width: 100,
                                child: TextFormField(
                                  controller: _quantityController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      quantityRequired =
                                          int.tryParse(value) ?? 0;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: 8),
                              IconButton(
                                icon: Icon(
                                  Icons.add,
                                  color: Colors
                                      .green, // Change to the color you desire
                                ),
                                onPressed: () {
                                  setState(() {
                                    quantityRequired++;
                                    _quantityController.text =
                                        quantityRequired.toString();
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          if (quantityRequired > 0)
                            ElevatedButton(
                              onPressed: () {
                                // Action to perform if quantity is not zero
                              },
                              child: Text('Submit Requisition'),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        currentIndex: 0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Product',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            label: 'Product Request',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.move_down_rounded),
            label: 'Stock Move',
          ),
        ],
        onTap: (int index) {
          // Define the destination screen for each bottom navigation item
          late Widget destinationScreen;
          switch (index) {
            case 0:
              destinationScreen = ProductList();
              break;
            case 1:
              destinationScreen = ProductRequest();
              break;
            case 2:
              destinationScreen = StockMove();
              break;
            default:
              destinationScreen = ProductRequest();
              break;
          }

          // Navigate to the selected destination screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => destinationScreen),
          );
        },
      ),
    );
  }
}
