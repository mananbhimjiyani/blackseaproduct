class Product {
  final String productID;
  final String productName;
  final String brand;
  final String? barCode;
  final String category;
  final String unit;
  final String? bulkPack;
  final String unitConversion;
  final String eachUnitContains;
  final String? productImage1;
  final String? productImage2;
  final String? productImage3;
  final String? specification;
  final String? reorderLevel;
  int requiredQuantity;

  Product({
    required this.productID,
    required this.productName,
    required this.brand,
    required this.barCode,
    required this.category,
    required this.unit,
    required this.bulkPack,
    required this.unitConversion,
    required this.eachUnitContains,
    required this.productImage1,
    required this.productImage2,
    required this.productImage3,
    required this.specification,
    required this.reorderLevel,
    this.requiredQuantity = 0,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productID: json['ProductID'].toString(), // Convert int to String
      productName: json['ProductName'] ?? '',
      brand: json['Brand'] ?? '',
      barCode: json['BarCode'] ?? '',
      category: json['Category'] ?? '',
      unit: json['Unit'] ?? '',
      bulkPack: json['BulkPack'],
      unitConversion: json['UnitConversion'] ?? '',
      eachUnitContains: json['EachUnitContains'] ?? '',
      productImage1: json['ProductImage1'],
      productImage2: json['ProductImage2'],
      productImage3: json['ProductImage3'],
      specification: json['Specification'],
      reorderLevel: json['ReorderLevel'],
    );
  }
}