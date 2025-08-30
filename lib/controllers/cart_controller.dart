import 'package:get/get.dart';
import 'package:ecommerce_ui/model/cart_item.dart';
import 'package:ecommerce_ui/model/product.dart';
import 'package:ecommerce_ui/services/cart_firestore_service.dart';
import 'package:ecommerce_ui/controllers/auth_controller.dart';

class CartController extends GetxController {
  final RxList<CartItem> _cartItems = <CartItem>[].obs;
  final RxBool _isLoading = false.obs;
  final RxBool _hasError = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxInt _itemCount = 0.obs;
  final RxDouble _subtotal = 0.0.obs;
  final RxDouble _savings = 0.0.obs;
  final RxDouble _shipping = 0.0.obs;
  final RxDouble _total = 0.0.obs;

  // Get authenticated user ID
  String? get _userId {
    final authController = Get.find<AuthController>();
    return authController.user?.uid;
  }

  // Getters
  List<CartItem> get cartItems => _cartItems;
  bool get isLoading => _isLoading.value;
  bool get hasError => _hasError.value;
  String get errorMessage => _errorMessage.value;
  int get itemCount => _itemCount.value;
  double get subtotal => _subtotal.value;
  double get savings => _savings.value;
  double get shipping => _shipping.value;
  double get total => _total.value;
  bool get isEmpty => _cartItems.isEmpty;

  @override
  void onInit() {
    super.onInit();
    loadCartItems();
    _listenToAuthChanges();
  }

  // Listen to authentication changes
  void _listenToAuthChanges() {
    final authController = Get.find<AuthController>();

    // Listen to auth state changes
    ever(authController.isLoggedIn.obs, (bool isLoggedIn) {
      if (isLoggedIn) {
        // User signed in, load their cart
        loadCartItems();
      } else {
        // User signed out, clear cart
        _cartItems.clear();
        _itemCount.value = 0;
        _resetTotals();
        update();
      }
    });
  }

  // Reset cart totals
  void _resetTotals() {
    _subtotal.value = 0.0;
    _savings.value = 0.0;
    _total.value = _shipping.value;
  }

  // Load cart items from Firestore
  Future<void> loadCartItems() async {
    _isLoading.value = true;
    _hasError.value = false;

    try {
      final userId = _userId;
      if (userId == null) {
        _cartItems.clear();
        _itemCount.value = 0;
        _resetTotals();
        _hasError.value = true;
        _errorMessage.value = 'Please sign in to view your cart.';
        return;
      }

      final items = await CartFirestoreService.getUserCartItems(userId);
      _cartItems.value = items;
      _calculateTotals();
      update(); // Notify UI
    } catch (e) {
      _hasError.value = true;
      _errorMessage.value = 'Failed to load cart items. Please try again.';
      print('Error loading cart items: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  // Calculate cart totals
  void _calculateTotals() {
    double subtotal = 0.0;
    double savings = 0.0;
    int totalItems = 0;

    for (var item in _cartItems) {
      subtotal += item.totalPrice;
      savings += item.savings;
      totalItems += item.quantity;
    }

    _subtotal.value = subtotal;
    _savings.value = savings;
    _itemCount.value = totalItems;
    _total.value = subtotal + _shipping.value;
  }

  // Add product to cart
  Future<bool> addToCart({
    required Product product,
    int quantity = 1,
    String? selectedSize,
    String? selectedColor,
    Map<String, dynamic>? customizations,
    bool showNotification = true,
  }) async {
    try {
      final userId = _userId;
      if (userId == null) {
        Get.snackbar(
          'Authentication Required',
          'Please sign in to add items to your cart',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        return false;
      }

      // Check stock availability
      if (product.stock < quantity) {
        Get.snackbar(
          'Insufficient Stock',
          'Only ${product.stock} items available',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        return false;
      }

      final success = await CartFirestoreService.addToCart(
        userId: userId,
        product: product,
        quantity: quantity,
        selectedSize: selectedSize,
        selectedColor: selectedColor,
        customizations: customizations,
      );

      if (success) {
        await loadCartItems(); // Refresh cart
        update(); // Notify UI
        if (showNotification) {
          Get.snackbar(
            'Added to Cart',
            '${product.name} added to your cart',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
        }
      } else {
        if (showNotification) {
          Get.snackbar(
            'Error',
            'Failed to add item to cart',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
        }
      }

      return success;
    } catch (e) {
      print('Error adding to cart: $e');
      Get.snackbar(
        'Error',
        'Failed to add item to cart',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      return false;
    }
  }

  // Update cart item quantity
  Future<bool> updateQuantity(String cartItemId, int newQuantity) async {
    try {
      final userId = _userId;
      if (userId == null) {
        Get.snackbar(
          'Authentication Required',
          'Please sign in to manage your cart',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        return false;
      }

      // Find the cart item to check stock
      final cartItem = _cartItems.firstWhere((item) => item.id == cartItemId);

      if (newQuantity > cartItem.product.stock) {
        Get.snackbar(
          'Insufficient Stock',
          'Only ${cartItem.product.stock} items available',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        return false;
      }

      final success = await CartFirestoreService.updateCartItemQuantity(
          cartItemId, newQuantity);

      if (success) {
        await loadCartItems(); // Refresh cart
        update(); // Notify UI
      }

      return success;
    } catch (e) {
      print('Error updating cart quantity: $e');
      return false;
    }
  }

  // Remove item from cart
  Future<bool> removeFromCart(String cartItemId) async {
    try {
      final success = await CartFirestoreService.removeCartItem(cartItemId);

      if (success) {
        await loadCartItems(); // Refresh cart
        update(); // Notify UI
        Get.snackbar(
          'Removed from Cart',
          'Item removed from your cart',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }

      return success;
    } catch (e) {
      print('Error removing from cart: $e');
      return false;
    }
  }

  // Clear entire cart
  Future<bool> clearCart() async {
    try {
      final userId = _userId;
      if (userId == null) {
        Get.snackbar(
          'Authentication Required',
          'Please sign in to manage your cart',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        return false;
      }

      final success = await CartFirestoreService.clearUserCart(userId);

      if (success) {
        _cartItems.clear();
        _itemCount.value = 0;
        _resetTotals();
        update();
        Get.snackbar(
          'Cart Cleared',
          'All items removed from cart',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }

      return success;
    } catch (e) {
      print('Error clearing cart: $e');
      return false;
    }
  }

  // Check if product is in cart
  bool isProductInCart(String productId, {String? selectedSize}) {
    return _cartItems.any((item) =>
        item.productId == productId &&
        (selectedSize == null || item.selectedSize == selectedSize));
  }

  // Get cart item for product
  CartItem? getCartItem(String productId, {String? selectedSize}) {
    try {
      return _cartItems.firstWhere((item) =>
          item.productId == productId &&
          (selectedSize == null || item.selectedSize == selectedSize));
    } catch (e) {
      return null;
    }
  }

  // Refresh cart
  Future<void> refreshCart() async {
    await loadCartItems();
  }
}
