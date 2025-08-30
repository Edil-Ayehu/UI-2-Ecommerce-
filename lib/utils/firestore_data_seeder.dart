import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDataSeeder {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Seed all data
  static Future<void> seedAllData() async {
    await seedProducts();
    await seedCategories();
  }

  // Add sample categories to Firestore
  static Future<void> seedCategories() async {
    final sampleCategories = [
      {
        'name': 'Electronics',
        'displayName': 'Electronics',
        'description': 'Electronic devices and gadgets',
        'isActive': true,
        'sortOrder': 1,
        'subcategories': [
          'Smartphones',
          'Laptops',
          'Tablets',
          'Wearables',
          'Audio'
        ],
        'metadata': {'color': '#2196F3', 'icon': 'electronics'},
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Footwear',
        'displayName': 'Footwear',
        'description': 'Shoes and footwear for all occasions',
        'isActive': true,
        'sortOrder': 2,
        'subcategories': [
          'Running Shoes',
          'Basketball Shoes',
          'Lifestyle Shoes',
          'Boots',
          'Sandals'
        ],
        'metadata': {'color': '#FF9800', 'icon': 'footwear'},
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Clothing',
        'displayName': 'Clothing',
        'description': 'Fashion and apparel for men and women',
        'isActive': true,
        'sortOrder': 3,
        'subcategories': [
          'T-Shirts',
          'Jeans',
          'Dresses',
          'Jackets',
          'Activewear'
        ],
        'metadata': {'color': '#E91E63', 'icon': 'clothing'},
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Accessories',
        'displayName': 'Accessories',
        'description': 'Fashion accessories and jewelry',
        'isActive': true,
        'sortOrder': 4,
        'subcategories': ['Watches', 'Jewelry', 'Bags', 'Sunglasses', 'Belts'],
        'metadata': {'color': '#9C27B0', 'icon': 'accessories'},
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Home',
        'displayName': 'Home & Living',
        'description': 'Home decor and living essentials',
        'isActive': true,
        'sortOrder': 5,
        'subcategories': [
          'Furniture',
          'Decor',
          'Kitchen',
          'Bedding',
          'Storage'
        ],
        'metadata': {'color': '#4CAF50', 'icon': 'home'},
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Sports',
        'displayName': 'Sports & Fitness',
        'description': 'Sports equipment and fitness gear',
        'isActive': true,
        'sortOrder': 6,
        'subcategories': [
          'Gym Equipment',
          'Outdoor Sports',
          'Team Sports',
          'Fitness Apparel'
        ],
        'metadata': {'color': '#FF5722', 'icon': 'sports'},
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }
    ];

    try {
      // Check if categories already exist
      final existingCategories =
          await _firestore.collection('categories').limit(1).get();

      if (existingCategories.docs.isEmpty) {
        // Add sample categories only if collection is empty
        for (var category in sampleCategories) {
          await _firestore.collection('categories').add(category);
        }
        print('Sample categories added to Firestore successfully!');
      } else {
        print('Categories already exist in Firestore. Skipping seed data.');
      }
    } catch (e) {
      print('Error seeding categories: $e');
    }
  }

  // Add sample products to Firestore
  static Future<void> seedProducts() async {
    final sampleProducts = [
      {
        'name': 'Nike Air Max 270',
        'description':
            'Comfortable running shoes with excellent cushioning and modern design. Perfect for daily wear and light exercise.',
        'category': 'Footwear',
        'subcategory': 'Running Shoes',
        'price': 129.99,
        'oldPrice': 179.99,
        'currency': 'USD',
        'images': [
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpnHmorysRSZDBWnzVo5jLfKV4RqHmd6rvng&s',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTxY2tiV09tdOiSP9kAak6m4RqCR_U2gptIhQ&s'
        ],
        'primaryImage':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRt6iUchu-11e_L2o9aZ76zGGlxPcbBH23X8_Fcoli7k9lsn8SuTfg8lGmPlZ239a5uF3s&usqp=CAU',
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
        'searchKeywords': [
          'nike',
          'air',
          'max',
          '270',
          'shoes',
          'running',
          'footwear',
          'white',
          'blue'
        ]
      },
      {
        'name': 'MacBook Pro 13"',
        'description':
            'High-performance laptop with M2 chip, perfect for professionals and creative work. Features stunning Retina display.',
        'category': 'Electronics',
        'subcategory': 'Laptops',
        'price': 1299.99,
        'oldPrice': 1499.99,
        'currency': 'USD',
        'images': [
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQXsU8yOX6zeR_Mq8vTVL90KU6Fryj_VEEhYyOho5nFryl-zldj6Fm20ZvvXbII8IhdKQY&usqp=CAU',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTt68OlDYzbSg-hn_rZMvJu3Zsf8sM5J6w0i2Bb-Z6dmCSWLb_ETNLN1GxjQ9mBTtBaS7k&usqp=CAU'
        ],
        'primaryImage':
            'https://techcrunch.com/wp-content/uploads/2020/05/00100trPORTRAIT_00100_BURST20200506153653558_COVER.jpg',
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
        'searchKeywords': [
          'macbook',
          'pro',
          'laptop',
          'apple',
          'electronics',
          'm2',
          'retina'
        ]
      },
      {
        'name': 'Air Jordan 1 Retro',
        'description':
            'Classic basketball shoes with iconic design. A timeless sneaker that combines style and performance.',
        'category': 'Footwear',
        'subcategory': 'Basketball Shoes',
        'price': 170.00,
        'currency': 'USD',
        'images': [
          'https://static.ftshp.digital/img/p/1/3/9/9/6/3/6/1399636-full_product.jpg',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSZXSwSg15jP36lnxKLqQ86BOpOA3TOl4KwN5z-JkJvka0xeyNzgO94oXYa2O5iKFvnaac&usqp=CAU'
        ],
        'primaryImage':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSMls5XcxKp5mn5W5j_euxK3p_CJe39xXD6Tw&s',
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
        'searchKeywords': [
          'jordan',
          'air',
          'retro',
          'basketball',
          'shoes',
          'black',
          'red'
        ]
      },
      {
        'name': 'Puma RS-X',
        'description':
            'Modern lifestyle sneakers with bold design and superior comfort. Perfect for casual wear and street style.',
        'category': 'Footwear',
        'subcategory': 'Lifestyle Shoes',
        'price': 110.00,
        'currency': 'USD',
        'images': [
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRKvPgVz9zuWTVfRyS3fySHILl9db8bjTMsA&s',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQoSLTa0cE1YuiCib2IEFUWVF63ZVskEUFf4w&s'
        ],
        'primaryImage':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRmu3U0IX1Wif_smZZdVs0SGAhodvDFPAF79g&s',
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
        'searchKeywords': [
          'puma',
          'rs-x',
          'lifestyle',
          'shoes',
          'casual',
          'colorful'
        ]
      },
      {
        'name': 'iPhone 15 Pro',
        'description':
            'Latest iPhone with titanium design, advanced camera system, and A17 Pro chip for ultimate performance.',
        'category': 'Electronics',
        'subcategory': 'Smartphones',
        'price': 999.99,
        'currency': 'USD',
        'images': [
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSLykA4073n2UFAgLP0G9WoRhR54C0Nf2dm-su3GcASw7Qz8bq37cX5kNfg97oG9MDKI60&usqp=CAU',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRCGn0N5jOZHd4F6atw6IDvrWTMmitxfPjNgA&s'
        ],
        'primaryImage':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSbUvMRzaNJcahY1xUz-e8yvvrbQcsoYLFuTw&s',
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
        'searchKeywords': [
          'iphone',
          '15',
          'pro',
          'apple',
          'smartphone',
          'titanium',
          'camera'
        ]
      },
      {
        'name': 'Samsung Galaxy Watch',
        'description':
            'Smart fitness watch with health monitoring, GPS, and long battery life. Perfect companion for active lifestyle.',
        'category': 'Electronics',
        'subcategory': 'Wearables',
        'price': 249.99,
        'oldPrice': 299.99,
        'currency': 'USD',
        'images': [
          'https://m.media-amazon.com/images/I/71SZNup1qrL._UF894,1000_QL80_.jpg',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSomqN-QSvm7vA223a62AfOCxc5Ynu0TaIGoNNi0BhSrq2CjUgWPiQB4Uz8-UUouwStun4&usqp=CAU'
        ],
        'primaryImage':
            'https://m.media-amazon.com/images/I/71ajpQVSv+L._UF894,1000_QL80_.jpg',
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
        'searchKeywords': [
          'samsung',
          'galaxy',
          'watch',
          'smart',
          'fitness',
          'health',
          'wearable'
        ]
      },
      {
        'name': 'Nike Dri-FIT T-Shirt',
        'description':
            'Comfortable athletic t-shirt with moisture-wicking technology. Perfect for workouts and casual wear.',
        'category': 'Clothing',
        'subcategory': 'T-Shirts',
        'price': 29.99,
        'oldPrice': 39.99,
        'currency': 'USD',
        'images': [
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQNyrA0nJsq6eF3Y4e0iodxRXl1j-S7jOO6bA&s',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxgx3ypP_e1yMR1Q933G4tG4_uqoq9ykqRUg&s',
        ],
        'primaryImage':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5dabyiV2uLVOuvcmgoqjdohkpK1KVZhqOqw&s',
        'brand': 'Nike',
        'sku': 'NIKE-TSHIRT-001',
        'stock': 50,
        'isActive': true,
        'isFeatured': false,
        'isOnSale': true,
        'rating': 4.2,
        'reviewCount': 76,
        'tags': ['athletic', 'comfortable', 'moisture-wicking'],
        'specifications': {
          'color': 'Black',
          'material': 'Polyester',
          'fit': 'Regular',
          'sizes': ['S', 'M', 'L', 'XL', 'XXL']
        },
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'searchKeywords': [
          'nike',
          'dri-fit',
          'tshirt',
          'shirt',
          'clothing',
          'athletic',
          'black'
        ]
      },
      {
        'name': 'Wireless Bluetooth Headphones',
        'description':
            'Premium wireless headphones with noise cancellation and long battery life. Perfect for music and calls.',
        'category': 'Electronics',
        'subcategory': 'Audio',
        'price': 199.99,
        'oldPrice': 249.99,
        'currency': 'USD',
        'images': [
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRXpXRzW83eZKLKziTv7T-Bv6ewxwdEcGSMh_J7NSH3mNydRY0CgpNguDODeRjkpeFJLCk&usqp=CAU',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR_PMYOAavmiNDnfCcf9b6a6OS-rfbnPxRc6w&s',
        ],
        'primaryImage':
            'https://m.media-amazon.com/images/I/41JACWT-wWL._UF1000,1000_QL80_.jpg',
        'brand': 'Sony',
        'sku': 'SONY-WH-001',
        'stock': 30,
        'isActive': true,
        'isFeatured': true,
        'isOnSale': true,
        'rating': 4.6,
        'reviewCount': 234,
        'tags': ['wireless', 'noise-cancelling', 'premium'],
        'specifications': {
          'color': 'Black',
          'battery': '30 hours',
          'connectivity': 'Bluetooth 5.0',
          'weight': '0.3kg'
        },
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'searchKeywords': [
          'sony',
          'headphones',
          'wireless',
          'bluetooth',
          'audio',
          'electronics',
          'noise'
        ]
      },
      {
        'name': 'Designer Leather Handbag',
        'description':
            'Elegant leather handbag with premium craftsmanship. Perfect for professional and casual occasions.',
        'category': 'Accessories',
        'subcategory': 'Bags',
        'price': 149.99,
        'currency': 'USD',
        'images': [
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQbRJSEKDOWXYISNWgkvoKxwHAVs5vYtQAL6Qz9fpzfByZnaSwUdgUEsI_o4RtaVe52380&usqp=CAU',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTlmWkRyL_HIbd-4UMmvUzmAVnrLCi-69vxNGXBEwM9rICQ1qZFVg0K7WjNQOsLkfcj8p0&usqp=CAU'
        ],
        'primaryImage':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_hbkRcYsQQC0_L--z4lK9WxSRWP8dZECA1g&s',
        'brand': 'Coach',
        'sku': 'COACH-BAG-001',
        'stock': 15,
        'isActive': true,
        'isFeatured': true,
        'isOnSale': false,
        'rating': 4.7,
        'reviewCount': 89,
        'tags': ['luxury', 'leather', 'designer'],
        'specifications': {
          'color': 'Brown',
          'material': 'Genuine Leather',
          'dimensions': '30x25x15 cm',
          'weight': '0.8kg'
        },
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'searchKeywords': [
          'coach',
          'handbag',
          'bag',
          'leather',
          'accessories',
          'designer',
          'brown'
        ]
      },
      {
        'name': 'Yoga Mat Premium',
        'description':
            'High-quality yoga mat with excellent grip and cushioning. Perfect for yoga, pilates, and fitness exercises.',
        'category': 'Sports',
        'subcategory': 'Fitness Equipment',
        'price': 39.99,
        'oldPrice': 59.99,
        'currency': 'USD',
        'images': [
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLHECoa3WE2V8uX8rIfmV-Zu2YxyqsMtLYgA&s',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQWLbBEoG7tTlUp96hQakV4GPtGIqugBlhc4w&s'
        ],
        'primaryImage':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShe19dG4JJgzXrRsJWC45Rbn2Q-J0S_3WK4w&s',
        'brand': 'Manduka',
        'sku': 'MANDUKA-MAT-001',
        'stock': 25,
        'isActive': true,
        'isFeatured': false,
        'isOnSale': true,
        'rating': 4.4,
        'reviewCount': 156,
        'tags': ['yoga', 'fitness', 'exercise'],
        'specifications': {
          'color': 'Purple',
          'material': 'Natural Rubber',
          'dimensions': '183x61x0.6 cm',
          'weight': '2.5kg'
        },
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'searchKeywords': [
          'yoga',
          'mat',
          'fitness',
          'exercise',
          'sports',
          'manduka',
          'purple'
        ]
      }
    ];

    try {
      // Check if products already exist
      final existingProducts =
          await _firestore.collection('products').limit(1).get();

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
