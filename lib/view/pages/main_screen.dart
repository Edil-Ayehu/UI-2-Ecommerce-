import 'package:ecommerce_ui/view/pages/wishlist_screen.dart';
import 'package:ecommerce_ui/view/widgets/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_ui/controllers/navigation_controller.dart';
import 'home_screen.dart';
import 'shopping_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationController navigationController =
        Get.put(NavigationController());

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: navigationController.currentIndex.value,
          children: const [
            HomeScreen(),
            ShoppingScreen(),
            WishlistScreen(),
            Scaffold(body: Center(child: Text('Account'))),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
