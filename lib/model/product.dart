class Product {
  final String name;
  final String category;
  final double price;
  final double? oldPrice;
  final String imageUrl;
  final bool isFavorite;

  const Product({
    required this.name,
    required this.category,
    required this.price,
    this.oldPrice,
    required this.imageUrl,
    this.isFavorite = false,
  });
}

final List<Product> products = [
  const Product(
    name: 'Cotton T-Shirt',
    category: 'Outerwear Men',
    price: 69.00,
    oldPrice: 189.00,
    imageUrl: 'assets/images/shoe.jpg',
  ),
  const Product(
    name: 'Ladies Top',
    category: 'Women',
    price: 88.00,
    oldPrice: 150.00,
    imageUrl: 'assets/images/shoe.jpg',
  ),
  const Product(
    name: 'Denim Jacket',
    category: 'Outerwear Men',
    price: 129.00,
    imageUrl: 'assets/images/shoe.jpg',
  ),
  const Product(
    name: 'Floral Dress',
    category: 'Women',
    price: 99.00,
    imageUrl: 'assets/images/shoe.jpg',
    isFavorite: true,
  ),
];
