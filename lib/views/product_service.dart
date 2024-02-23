import 'package:cloud_firestore/cloud_firestore.dart';
import 'Schemas/product.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Product>> getProducts() {
    return _firestore.collection('products').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Product.fromMap(doc.data())).toList());
  }

  Future<void> addProduct(Product product) {
    return _firestore.collection('products').add(product.toMap());
  }

  Future<void> updateProduct(Product product) {
    return _firestore.collection('products').doc(product.id).update(product.toMap());
  }

  Future<void> deleteProduct(String id) {
    return _firestore.collection('products').doc(id).delete();
  }
}