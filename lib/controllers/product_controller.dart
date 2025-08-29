import 'package:get/get.dart';
import 'package:ecommerce_ui/model/product.dart';
import 'package:ecommerce_ui/services/product_firestore_service.dart';

class ProductController extends GetxController {
  final RxList<Product> _allProducts = <Product>[].obs;
  final RxList<Product> _filteredProducts = <Product>[].obs;
  final RxList<Product> _featuredProducts = <Product>[].obs;
  final RxList<Product> _saleProducts = <Product>[].obs;
  final RxList<String> _categories = <String>[].obs;
  final RxBool _isLoading = false.obs;
  final RxBool _hasError = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxString _selectedCategory = 'All'.obs;
  final RxString _searchQuery = ''.obs;

  // Getters
  List<Product> get allProducts => _allProducts;
  List<Product> get filteredProducts => _filteredProducts;
  List<Product> get featuredProducts => _featuredProducts;
  List<Product> get saleProducts => _saleProducts;
  List<String> get categories => _categories;
  bool get isLoading => _isLoading.value;
  bool get hasError => _hasError.value;
  String get errorMessage => _errorMessage.value;
  String get selectedCategory => _selectedCategory.value;
  String get searchQuery => _searchQuery.value;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  // Load all products from Firestore
  Future<void> loadProducts() async {
    _isLoading.value = true;
    _hasError.value = false;

    try {
      final products = await ProductFirestoreService.getAllProducts();

      // Set products from Firestore (no fallback to dummy data)
      _allProducts.value = products;
      _filteredProducts.value = products;

      // Load other product lists
      await _loadFeaturedProducts();
      await _loadSaleProducts();
      await _loadCategories();
    } catch (e) {
      _hasError.value = true;
      _errorMessage.value = 'Failed to load products. Please try again.';
      print('Error loading products: $e');

      // Clear products on error (no fallback to dummy data)
      _allProducts.value = [];
      _filteredProducts.value = [];
    } finally {
      _isLoading.value = false;
    }
  }

  // Load featured products
  Future<void> _loadFeaturedProducts() async {
    try {
      final featured = await ProductFirestoreService.getFeaturedProducts();
      _featuredProducts.value = featured;
    } catch (e) {
      print('Error loading featured products: $e');
    }
  }

  // Load sale products
  Future<void> _loadSaleProducts() async {
    try {
      final sale = await ProductFirestoreService.getSaleProducts();
      _saleProducts.value = sale;
    } catch (e) {
      print('Error loading sale products: $e');
    }
  }

  // Load categories
  Future<void> _loadCategories() async {
    try {
      final categories = await ProductFirestoreService.getAllCategories();
      _categories.value = ['All', ...categories];
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  // Filter products by category
  void filterByCategory(String category) {
    _selectedCategory.value = category;
    _applyFilters();
  }

  // Search products
  void searchProducts(String query) {
    _searchQuery.value = query;
    _applyFilters();
  }

  // Apply filters and search
  void _applyFilters() {
    List<Product> filtered = _allProducts;

    // Apply category filter
    if (_selectedCategory.value != 'All') {
      filtered = filtered
          .where((product) =>
              product.category.toLowerCase() ==
              _selectedCategory.value.toLowerCase())
          .toList();
    }

    // Apply search filter
    if (_searchQuery.value.isNotEmpty) {
      final query = _searchQuery.value.toLowerCase();
      filtered = filtered
          .where((product) =>
              product.name.toLowerCase().contains(query) ||
              product.category.toLowerCase().contains(query) ||
              product.description.toLowerCase().contains(query) ||
              (product.brand?.toLowerCase().contains(query) ?? false))
          .toList();
    }

    _filteredProducts.value = filtered;
  }

  // Get products by category
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      return await ProductFirestoreService.getProductsByCategory(category);
    } catch (e) {
      print('Error getting products by category: $e');
      return [];
    }
  }

  // Search products in Firestore
  Future<List<Product>> searchProductsInFirestore(String searchTerm) async {
    try {
      return await ProductFirestoreService.searchProducts(searchTerm);
    } catch (e) {
      print('Error searching products: $e');
      return [];
    }
  }

  // Get product by ID
  Future<Product?> getProductById(String productId) async {
    try {
      return await ProductFirestoreService.getProductById(productId);
    } catch (e) {
      print('Error getting product by ID: $e');
      return null;
    }
  }

  // Refresh products
  Future<void> refreshProducts() async {
    await loadProducts();
  }

  // Clear filters
  void clearFilters() {
    _selectedCategory.value = 'All';
    _searchQuery.value = '';
    _filteredProducts.value = _allProducts;
  }

  // Get products for display (Firestore only, no dummy data)
  List<Product> getDisplayProducts() {
    return _filteredProducts.isNotEmpty ? _filteredProducts : _allProducts;
  }
}
