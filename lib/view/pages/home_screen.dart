import 'package:ecommerce_ui/controllers/theme_controller.dart';
import 'package:ecommerce_ui/view/pages/all_products_screen.dart';
import 'package:ecommerce_ui/view/pages/cart_screen.dart';
import 'package:ecommerce_ui/view/pages/notifications_screen.dart';
import 'package:ecommerce_ui/view/widgets/custom_search_bar.dart';
import 'package:ecommerce_ui/view/widgets/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/category_chips.dart';
import '../widgets/sale_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // header section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/images/avatar.jpg'),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Hello Alex',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Good Morning!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // notification button
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () => Get.to(() => const NotificationsScreen()),
                  ),
                  // cart button
                  IconButton(
                    icon: const Icon(Icons.shopping_bag_outlined),
                    onPressed: () => Get.to(() => const CartScreen()),
                  ),
                  // theme button
                  GetBuilder<ThemeController>(
                    builder: (controller) => IconButton(
                      icon: Icon(
                        controller.isDarkMode
                            ? Icons.light_mode
                            : Icons.dark_mode,
                      ),
                      onPressed: () => controller.toggleTheme(),
                    ),
                  ),
                ],
              ),
            ),

            // search bar
            const CustomSearchBar(),

            // category chips
            const CategoryChips(),

            // sale banner
            const SaleBanner(),

            // popular product
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Popular Product',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => const AllProductsScreen()),
                    child: Text(
                      'See All',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // product grid
            const Expanded(child: ProductGrid()),
          ],
        ),
      ),
    );
  }
}
