import 'package:get/get.dart';
import 'package:ecommerce_ui/model/wishlist_item.dart';
import 'package:ecommerce_ui/model/product.dart';
import 'package:ecommerce_ui/services/wishlist_firestore_service.dart';

class WishlistController extends GetxController {
  final RxList<WishlistItem> _wishlistItems = <WishlistItem>[].obs;
  final RxBool _isLoading = false.obs;
  final RxBool _hasError = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxInt _itemCount = 0.obs;

  // Mock user ID - In a real app, this would come from authentication
  final String _userId = 'user_123';

  // Getters
  List<WishlistItem> get wishlistItems => _wishlistItems;
  bool get isLoading => _isLoading.value;
  bool get hasError => _hasError.value;
  String get errorMessage => _errorMessage.value;
  int get itemCount => _itemCount.value;
  bool get isEmpty => _wishlistItems.isEmpty;

  @override
  void onInit() {
    super.onInit();
    loadWishlistItems();
  }

  // Load wishlist items from Firestore
  Future<void> loadWishlistItems() async {
    _isLoading.value = true;
    _hasError.value = false;

    try {
      final items =
          await WishlistFirestoreService.getUserWishlistItems(_userId);
      _wishlistItems.value = items;
      _itemCount.value = items.length;
      update(); // Notify UI
    } catch (e) {
      _hasError.value = true;
      _errorMessage.value = 'Failed to load wishlist items. Please try again.';
      print('Error loading wishlist items: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  // Add product to wishlist
  Future<bool> addToWishlist(Product product) async {
    try {
      final success = await WishlistFirestoreService.addToWishlist(
        userId: _userId,
        product: product,
      );

      if (success) {
        await loadWishlistItems(); // Refresh wishlist
        update(); // Notify UI
        Get.snackbar(
          'Added to Wishlist',
          '${product.name} added to your wishlist',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to add item to wishlist',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }

      return success;
    } catch (e) {
      print('Error adding to wishlist: $e');
      Get.snackbar(
        'Error',
        'Failed to add item to wishlist',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      return false;
    }
  }

  // Remove product from wishlist
  Future<bool> removeFromWishlist(String productId) async {
    try {
      final success =
          await WishlistFirestoreService.removeFromWishlist(_userId, productId);

      if (success) {
        await loadWishlistItems(); // Refresh wishlist
        update(); // Notify UI
        Get.snackbar(
          'Removed from Wishlist',
          'Item removed from your wishlist',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }

      return success;
    } catch (e) {
      print('Error removing from wishlist: $e');
      return false;
    }
  }

  // Toggle product in wishlist
  Future<bool> toggleWishlist(Product product) async {
    try {
      final isInWishlist = isProductInWishlist(product.id);

      // Update UI immediately for better user experience
      if (isInWishlist) {
        // Optimistically remove from local list
        _wishlistItems.removeWhere((item) => item.productId == product.id);
        _itemCount.value = _wishlistItems.length;
        update(); // Notify all UI
        update(['wishlist_${product.id}']); // Notify specific product UI

        final success = await removeFromWishlist(product.id);
        if (!success) {
          // Revert if failed
          await loadWishlistItems();
        }
        return success;
      } else {
        // Optimistically add to local list (create temporary item)
        final tempItem = WishlistItem(
          id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
          userId: _userId,
          productId: product.id,
          product: product,
          addedAt: DateTime.now(),
        );
        _wishlistItems.insert(0, tempItem);
        _itemCount.value = _wishlistItems.length;
        update(); // Notify all UI
        update(['wishlist_${product.id}']); // Notify specific product UI

        final success = await addToWishlist(product);
        if (!success) {
          // Revert if failed
          await loadWishlistItems();
        }
        return success;
      }
    } catch (e) {
      print('Error toggling wishlist: $e');
      // Revert changes on error
      await loadWishlistItems();
      return false;
    }
  }

  // Check if product is in wishlist
  bool isProductInWishlist(String productId) {
    return _wishlistItems.any((item) => item.productId == productId);
  }

  // Get wishlist item for product
  WishlistItem? getWishlistItem(String productId) {
    try {
      return _wishlistItems.firstWhere((item) => item.productId == productId);
    } catch (e) {
      return null;
    }
  }

  // Clear entire wishlist
  Future<bool> clearWishlist() async {
    try {
      final success = await WishlistFirestoreService.clearUserWishlist(_userId);

      if (success) {
        _wishlistItems.clear();
        _itemCount.value = 0;
        Get.snackbar(
          'Wishlist Cleared',
          'All items removed from wishlist',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }

      return success;
    } catch (e) {
      print('Error clearing wishlist: $e');
      return false;
    }
  }

  // Refresh wishlist
  Future<void> refreshWishlist() async {
    await loadWishlistItems();
  }

  // Get products from wishlist
  List<Product> get wishlistProducts {
    return _wishlistItems.map((item) => item.product).toList();
  }
}
