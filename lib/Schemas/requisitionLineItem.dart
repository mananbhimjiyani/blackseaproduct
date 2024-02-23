class RequisitionLineItem {
  final String productName;
  final int quantity;

  RequisitionLineItem({
    required this.productName,
    required this.quantity,
  });

  factory RequisitionLineItem.fromJson(Map<String, dynamic> json) {
    return RequisitionLineItem(
      productName: json['productName'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'quantity': quantity,
    };
  }
}
