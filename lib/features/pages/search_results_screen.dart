import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_ui/utils/app_textstyles.dart';
import 'package:ecommerce_ui/controllers/product_controller.dart';
import 'package:ecommerce_ui/features/widgets/product_grid.dart';
import 'package:ecommerce_ui/features/widgets/custom_search_bar.dart';

class SearchResultsScreen extends StatefulWidget {
  final String searchQuery;

  const SearchResultsScreen({
    super.key,
    required this.searchQuery,
  });

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchQuery;
    // Perform initial search
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productController = Get.find<ProductController>();
      productController.searchProducts(widget.searchQuery);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) {
      final productController = Get.find<ProductController>();
      productController.clearSearch();
      return;
    }
    
    final productController = Get.find<ProductController>();
    productController.searchProducts(query.trim());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () {
            // Clear search when going back
            final productController = Get.find<ProductController>();
            productController.clearSearch();
            Get.back();
          },
        ),
        title: Text(
          'Search Results',
          style: AppTextStyle.withColor(
            AppTextStyle.h3,
            isDark ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.clear,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () {
              _searchController.clear();
              _performSearch('');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              style: AppTextStyle.withColor(
                AppTextStyle.bodyMedium,
                Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
              ),
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle: AppTextStyle.withColor(
                  AppTextStyle.bodyMedium,
                  isDark ? Colors.grey[400]! : Colors.grey[600]!,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        onPressed: () {
                          _searchController.clear();
                          _performSearch('');
                        },
                      )
                    : Icon(
                        Icons.tune,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                filled: true,
                fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 1,
                  ),
                ),
              ),
              onChanged: (value) {
                setState(() {}); // Rebuild to show/hide clear button
              },
              onSubmitted: _performSearch,
            ),
          ),
          
          // Search results
          Expanded(
            child: GetBuilder<ProductController>(
              builder: (productController) {
                if (productController.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (productController.searchQuery.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          size: 64,
                          color: isDark ? Colors.grey[600] : Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Search for products',
                          style: AppTextStyle.withColor(
                            AppTextStyle.h3,
                            isDark ? Colors.grey[400]! : Colors.grey[600]!,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Enter a search term to find products',
                          style: AppTextStyle.withColor(
                            AppTextStyle.bodyMedium,
                            isDark ? Colors.grey[500]! : Colors.grey[500]!,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (productController.filteredProducts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: isDark ? Colors.grey[600] : Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No products found',
                          style: AppTextStyle.withColor(
                            AppTextStyle.h3,
                            isDark ? Colors.grey[400]! : Colors.grey[600]!,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try searching with different keywords',
                          style: AppTextStyle.withColor(
                            AppTextStyle.bodyMedium,
                            isDark ? Colors.grey[500]! : Colors.grey[500]!,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '${productController.filteredProducts.length} results for "${productController.searchQuery}"',
                        style: AppTextStyle.withColor(
                          AppTextStyle.bodyMedium,
                          isDark ? Colors.grey[400]! : Colors.grey[600]!,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Expanded(
                      child: ProductGrid(),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
