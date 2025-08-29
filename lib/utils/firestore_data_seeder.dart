import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDataSeeder {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add sample products to Firestore
  static Future<void> seedProducts() async {
    final sampleProducts = [
      {
        'name': 'Nike Air Max 270',
        'description': 'Comfortable running shoes with excellent cushioning and modern design. Perfect for daily wear and light exercise.',
        'category': 'Footwear',
        'subcategory': 'Running Shoes',
        'price': 129.99,
        'oldPrice': 179.99,
        'currency': 'USD',
        'images': ['assets/images/shoe.jpg'],
        'primaryImage': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQzSOrIHIncvVwcn86Yj1lG2no3rymRPhF1AQ&s',
        'brand': 'Nike',
        'sku': 'NIKE-AM270-001',
        'stock': 25,
        'isActive': true,
        'isFeatured': true,
        'isOnSale': true,
        'rating': 4.5,
        'reviewCount': 89,
        'tags': ['popular', 'trending', 'comfortable'],
        'specifications': {
          'color': 'White/Blue',
          'material': 'Synthetic',
          'weight': '0.8kg',
          'sizes': ['7', '8', '9', '10', '11']
        },
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'searchKeywords': ['nike', 'air', 'max', '270', 'shoes', 'running', 'footwear', 'white', 'blue']
      },
      {
        'name': 'MacBook Pro 13"',
        'description': 'High-performance laptop with M2 chip, perfect for professionals and creative work. Features stunning Retina display.',
        'category': 'Electronics',
        'subcategory': 'Laptops',
        'price': 1299.99,
        'oldPrice': 1499.99,
        'currency': 'USD',
        'images': ['assets/images/laptop.jpg'],
        'primaryImage': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQzSOrIHIncvVwcn86Yj1lG2no3rymRPhF1AQ&s',
        'brand': 'Apple',
        'sku': 'APPLE-MBP13-001',
        'stock': 15,
        'isActive': true,
        'isFeatured': true,
        'isOnSale': false,
        'rating': 4.8,
        'reviewCount': 156,
        'tags': ['premium', 'professional', 'powerful'],
        'specifications': {
          'screen': '13-inch Retina',
          'processor': 'Apple M2',
          'memory': '8GB',
          'storage': '256GB SSD',
          'color': 'Space Gray'
        },
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'searchKeywords': ['macbook', 'pro', 'laptop', 'apple', 'electronics', 'm2', 'retina']
      },
      {
        'name': 'Air Jordan 1 Retro',
        'description': 'Classic basketball shoes with iconic design. A timeless sneaker that combines style and performance.',
        'category': 'Footwear',
        'subcategory': 'Basketball Shoes',
        'price': 170.00,
        'currency': 'USD',
        'images': ['assets/images/shoe2.jpg'],
        'primaryImage': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQzSOrIHIncvVwcn86Yj1lG2no3rymRPhF1AQ&s',
        'brand': 'Jordan',
        'sku': 'JORDAN-AJ1-001',
        'stock': 30,
        'isActive': true,
        'isFeatured': false,
        'isOnSale': false,
        'rating': 4.7,
        'reviewCount': 203,
        'tags': ['classic', 'basketball', 'iconic'],
        'specifications': {
          'color': 'Black/Red',
          'material': 'Leather',
          'weight': '0.9kg',
          'sizes': ['7', '8', '9', '10', '11', '12']
        },
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'searchKeywords': ['jordan', 'air', 'retro', 'basketball', 'shoes', 'black', 'red']
      },
      {
        'name': 'Puma RS-X',
        'description': 'Modern lifestyle sneakers with bold design and superior comfort. Perfect for casual wear and street style.',
        'category': 'Footwear',
        'subcategory': 'Lifestyle Shoes',
        'price': 110.00,
        'currency': 'USD',
        'images': ['assets/images/shoes2.jpg'],
        'primaryImage': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQzSOrIHIncvVwcn86Yj1lG2no3rymRPhF1AQ&s',
        'brand': 'Puma',
        'sku': 'PUMA-RSX-001',
        'stock': 40,
        'isActive': true,
        'isFeatured': true,
        'isOnSale': false,
        'rating': 4.3,
        'reviewCount': 67,
        'tags': ['lifestyle', 'casual', 'modern'],
        'specifications': {
          'color': 'Multi-color',
          'material': 'Synthetic/Mesh',
          'weight': '0.7kg',
          'sizes': ['6', '7', '8', '9', '10', '11']
        },
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'searchKeywords': ['puma', 'rs-x', 'lifestyle', 'shoes', 'casual', 'colorful']
      },
      {
        'name': 'iPhone 15 Pro',
        'description': 'Latest iPhone with titanium design, advanced camera system, and A17 Pro chip for ultimate performance.',
        'category': 'Electronics',
        'subcategory': 'Smartphones',
        'price': 999.99,
        'currency': 'USD',
        'images': ['assets/images/phone.jpg'],
        'primaryImage': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQzSOrIHIncvVwcn86Yj1lG2no3rymRPhF1AQ&s',
        'brand': 'Apple',
        'sku': 'APPLE-IP15P-001',
        'stock': 20,
        'isActive': true,
        'isFeatured': true,
        'isOnSale': false,
        'rating': 4.9,
        'reviewCount': 324,
        'tags': ['premium', 'latest', 'flagship'],
        'specifications': {
          'screen': '6.1-inch Super Retina XDR',
          'processor': 'A17 Pro',
          'storage': '128GB',
          'color': 'Titanium Blue',
          'camera': '48MP Main'
        },
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'searchKeywords': ['iphone', '15', 'pro', 'apple', 'smartphone', 'titanium', 'camera']
      },
      {
        'name': 'Samsung Galaxy Watch',
        'description': 'Smart fitness watch with health monitoring, GPS, and long battery life. Perfect companion for active lifestyle.',
        'category': 'Electronics',
        'subcategory': 'Wearables',
        'price': 249.99,
        'oldPrice': 299.99,
        'currency': 'USD',
        'images': ['assets/images/watch.jpg'],
        'primaryImage': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQzSOrIHIncvVwcn86Yj1lG2no3rymRPhF1AQ&s',
        'brand': 'Samsung',
        'sku': 'SAMSUNG-GW-001',
        'stock': 35,
        'isActive': true,
        'isFeatured': false,
        'isOnSale': true,
        'rating': 4.4,
        'reviewCount': 142,
        'tags': ['fitness', 'smart', 'health'],
        'specifications': {
          'display': '1.4-inch AMOLED',
          'battery': '40 hours',
          'waterproof': 'IP68',
          'color': 'Black',
          'connectivity': 'Bluetooth 5.0'
        },
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'searchKeywords': ['samsung', 'galaxy', 'watch', 'smart', 'fitness', 'health', 'wearable']
      }
    ];

    try {
      // Check if products already exist
      final existingProducts = await _firestore.collection('products').limit(1).get();
      
      if (existingProducts.docs.isEmpty) {
        // Add sample products only if collection is empty
        for (var product in sampleProducts) {
          await _firestore.collection('products').add(product);
        }
        print('Sample products added to Firestore successfully!');
      } else {
        print('Products already exist in Firestore. Skipping seed data.');
      }
    } catch (e) {
      print('Error seeding products: $e');
    }
  }
}
