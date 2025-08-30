import 'package:ecommerce_ui/model/product.dart';
import 'package:ecommerce_ui/utils/app_textstyles.dart';
import 'package:ecommerce_ui/controllers/wishlist_controller.dart';
import 'package:ecommerce_ui/controllers/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';
import '../widgets/size_selector.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String? selectedSize;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Details',
          style: AppTextStyle.withColor(
            AppTextStyle.h3,
            isDark ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          // share button
          IconButton(
            icon: Icon(
              Icons.share,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () => _shareProduct(
                context, widget.product.name, widget.product.description),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // image
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: widget.product.imageUrl.startsWith('http')
                      ? Image.network(
                          widget.product.imageUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        )
                      : Image.asset(
                          widget.product.imageUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),
                ),
                // favorite button
                Positioned(
                  right: screenWidth * 0.04,
                  top: screenWidth * 0.04,
                  child: GetBuilder<WishlistController>(
                    id: 'wishlist_${widget.product.id}',
                    builder: (wishlistController) {
                      final isInWishlist = wishlistController
                          .isProductInWishlist(widget.product.id);

                      return IconButton(
                        icon: Icon(
                          isInWishlist ? Icons.favorite : Icons.favorite_border,
                          color: isInWishlist
                              ? Theme.of(context).primaryColor
                              : (isDark ? Colors.white : Colors.black),
                        ),
                        onPressed: () {
                          wishlistController.toggleWishlist(widget.product);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            // product details
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.name,
                          style: AppTextStyle.withColor(
                            AppTextStyle.h2,
                            Theme.of(context).textTheme.headlineMedium!.color!,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${widget.product.price.toStringAsFixed(2)}',
                            style: AppTextStyle.withColor(
                              AppTextStyle.h2,
                              Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .color!,
                            ),
                          ),
                          if (widget.product.oldPrice != null &&
                              widget.product.oldPrice! >
                                  widget.product.price) ...[
                            Text(
                              '\$${widget.product.oldPrice!.toStringAsFixed(2)}',
                              style: AppTextStyle.withColor(
                                AppTextStyle.bodySmall,
                                isDark ? Colors.grey[400]! : Colors.grey[600]!,
                              ).copyWith(
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${widget.product.discountPercentage}% OFF',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        widget.product.category,
                        style: AppTextStyle.withColor(
                          AppTextStyle.bodyMedium,
                          isDark ? Colors.grey[400]! : Colors.grey[600]!,
                        ),
                      ),
                      if (widget.product.brand != null) ...[
                        Text(
                          ' • ',
                          style: AppTextStyle.withColor(
                            AppTextStyle.bodyMedium,
                            isDark ? Colors.grey[400]! : Colors.grey[600]!,
                          ),
                        ),
                        Text(
                          widget.product.brand!,
                          style: AppTextStyle.withColor(
                            AppTextStyle.bodyMedium,
                            Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                  // Stock status
                  if (widget.product.stock <= 5 && widget.product.stock > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Only ${widget.product.stock} left in stock!',
                        style: AppTextStyle.withColor(
                          AppTextStyle.bodySmall,
                          Colors.orange,
                        ),
                      ),
                    )
                  else if (widget.product.stock == 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Out of stock',
                        style: AppTextStyle.withColor(
                          AppTextStyle.bodySmall,
                          Colors.red,
                        ),
                      ),
                    ),
                  SizedBox(height: screenHeight * 0.02),
                  // Show size selector only if sizes are available
                  if (_getAvailableSizes().isNotEmpty) ...[
                    Text(
                      'Select Size',
                      style: AppTextStyle.withColor(
                        AppTextStyle.labelMedium,
                        Theme.of(context).textTheme.bodyLarge!.color!,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    // size selector with product sizes
                    SizeSelector(
                      sizes: _getAvailableSizes(),
                      onSizeSelected: (size) {
                        // Handle size selection
                        // You can add size selection logic here
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),
                  ],
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'Description',
                    style: AppTextStyle.withColor(
                      AppTextStyle.labelMedium,
                      Theme.of(context).textTheme.bodyLarge!.color!,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    widget.product.description,
                    style: AppTextStyle.withColor(
                      AppTextStyle.bodySmall,
                      isDark ? Colors.grey[400]! : Colors.grey[600]!,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // buttons
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Row(
            children: [
              Expanded(
                child: GetBuilder<CartController>(
                  builder: (cartController) {
                    final isInCart = cartController.isProductInCart(
                      widget.product.id,
                      selectedSize: selectedSize,
                    );

                    return OutlinedButton(
                      onPressed: widget.product.stock > 0
                          ? () => _addToCart(cartController)
                          : null,
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02,
                        ),
                        side: BorderSide(
                          color: widget.product.stock > 0
                              ? (isDark ? Colors.white70 : Colors.black12)
                              : Colors.grey,
                        ),
                      ),
                      child: Text(
                        widget.product.stock > 0
                            ? (isInCart ? 'Update Cart' : 'Add To Cart')
                            : 'Out of Stock',
                        style: AppTextStyle.withColor(
                          AppTextStyle.buttonMedium,
                          widget.product.stock > 0
                              ? Theme.of(context).textTheme.bodyLarge!.color!
                              : Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: screenWidth * 0.04),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02,
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: Text(
                    'Buy Now',
                    style: AppTextStyle.withColor(
                      AppTextStyle.buttonMedium,
                      Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Get available sizes from product specifications
  List<String> _getAvailableSizes() {
    if (widget.product.specifications.containsKey('sizes')) {
      final sizes = widget.product.specifications['sizes'];
      if (sizes is List) {
        return List<String>.from(sizes);
      }
    }
    // Return empty list if no sizes specified (will hide size selector)
    return [];
  }

  // Add product to cart
  Future<void> _addToCart(CartController cartController) async {
    // Check if size selection is required
    final availableSizes = _getAvailableSizes();
    if (availableSizes.isNotEmpty && selectedSize == null) {
      Get.snackbar(
        'Size Required',
        'Please select a size before adding to cart',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    // Add to cart with selected options
    await cartController.addToCart(
      product: widget.product,
      quantity: 1,
      selectedSize: selectedSize,
    );
  }

  Future<void> _shareProduct(
      BuildContext context, String productName, String description) async {
    // Get the render box for share position origin (required for iPad)
    final box = context.findRenderObject() as RenderBox?;

    const String shopLink = 'https://yourshop.com/product/cotton-tshirt';

    final String shareMessage = '$description\n\nShop now at: $shopLink';

    try {
      final ShareResult result = await Share.share(
        shareMessage,
        subject: productName,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );

      if (result.status == ShareResultStatus.success) {
        debugPrint('Thank you for sharing!');
      }
    } catch (e) {
      debugPrint('Error sharing: $e');
    }
  }
}
