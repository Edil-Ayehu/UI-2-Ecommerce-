import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_ui/model/product.dart';

class ProductFirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _productsCollection = 'products';

  // Get all products
  static Future<List<Product>> getAllProducts() async {
    try {
      final querySnapshot = await _firestore
          .collection(_productsCollection)
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        return Product.fromFirestore(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  // Get products by category
  static Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final querySnapshot = await _firestore
          .collection(_productsCollection)
          .where('isActive', isEqualTo: true)
          .where('category', isEqualTo: category)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        return Product.fromFirestore(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching products by category: $e');
      return [];
    }
  }

  // Get featured products
  static Future<List<Product>> getFeaturedProducts() async {
    try {
      final querySnapshot = await _firestore
          .collection(_productsCollection)
          .where('isActive', isEqualTo: true)
          .where('isFeatured', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .limit(10)
          .get();

      return querySnapshot.docs.map((doc) {
        return Product.fromFirestore(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching featured products: $e');
      return [];
    }
  }

  // Get products on sale
  static Future<List<Product>> getSaleProducts() async {
    try {
      final querySnapshot = await _firestore
          .collection(_productsCollection)
          .where('isActive', isEqualTo: true)
          .where('isOnSale', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        return Product.fromFirestore(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching sale products: $e');
      return [];
    }
  }

  // Search products
  static Future<List<Product>> searchProducts(String searchTerm) async {
    try {
      final querySnapshot = await _firestore
          .collection(_productsCollection)
          .where('isActive', isEqualTo: true)
          .where('searchKeywords', arrayContains: searchTerm.toLowerCase())
          .get();

      return querySnapshot.docs.map((doc) {
        return Product.fromFirestore(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      print('Error searching products: $e');
      return [];
    }
  }

  // Get product by ID
  static Future<Product?> getProductById(String productId) async {
    try {
      final doc = await _firestore
          .collection(_productsCollection)
          .doc(productId)
          .get();

      if (doc.exists) {
        return Product.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('Error fetching product by ID: $e');
      return null;
    }
  }

  // Get products stream for real-time updates
  static Stream<List<Product>> getProductsStream() {
    return _firestore
        .collection(_productsCollection)
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  // Get products by price range
  static Future<List<Product>> getProductsByPriceRange({
    required double minPrice,
    required double maxPrice,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection(_productsCollection)
          .where('isActive', isEqualTo: true)
          .where('price', isGreaterThanOrEqualTo: minPrice)
          .where('price', isLessThanOrEqualTo: maxPrice)
          .orderBy('price')
          .get();

      return querySnapshot.docs.map((doc) {
        return Product.fromFirestore(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching products by price range: $e');
      return [];
    }
  }

  // Get all categories
  static Future<List<String>> getAllCategories() async {
    try {
      final querySnapshot = await _firestore
          .collection(_productsCollection)
          .where('isActive', isEqualTo: true)
          .get();

      final categories = <String>{};
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        if (data['category'] != null) {
          categories.add(data['category'] as String);
        }
      }

      return categories.toList()..sort();
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  // Add sample products (for testing/admin use)
  static Future<void> addSampleProducts() async {
    final sampleProducts = [
      {
        'name': 'Nike Air Max',
        'description': 'Comfortable running shoes with excellent cushioning',
        'category': 'Footwear',
        'subcategory': 'Running Shoes',
        'price': 129.99,
        'oldPrice': 179.99,
        'currency': 'USD',
        'images': ['assets/images/shoe.jpg'],
        'primaryImage': 'assets/images/shoe.jpg',
        'brand': 'Nike',
        'sku': 'NIKE-AM-001',
        'stock': 25,
        'isActive': true,
        'isFeatured': true,
        'isOnSale': true,
        'rating': 4.5,
        'reviewCount': 89,
        'tags': ['popular', 'trending'],
        'specifications': {
          'color': 'White/Blue',
          'material': 'Synthetic',
          'weight': '0.8kg'
        },
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'searchKeywords': ['nike', 'air', 'max', 'shoes', 'running', 'footwear']
      },
      {
        'name': 'MacBook Pro',
        'description': 'High-performance laptop for professionals',
        'category': 'Electronics',
        'subcategory': 'Laptops',
        'price': 1299.99,
        'oldPrice': 1499.99,
        'currency': 'USD',
        'images': ['assets/images/laptop.jpg'],
        'primaryImage': 'assets/images/laptop.jpg',
        'brand': 'Apple',
        'sku': 'APPLE-MBP-001',
        'stock': 15,
        'isActive': true,
        'isFeatured': true,
        'isOnSale': false,
        'rating': 4.8,
        'reviewCount': 156,
        'tags': ['premium', 'professional'],
        'specifications': {
          'screen': '13-inch',
          'processor': 'M2',
          'memory': '8GB',
          'storage': '256GB'
        },
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'searchKeywords': ['macbook', 'pro', 'laptop', 'apple', 'electronics']
      }
    ];

    for (var product in sampleProducts) {
      await _firestore.collection(_productsCollection).add(product);
    }
  }
}
