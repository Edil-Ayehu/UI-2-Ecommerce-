import 'package:ecommerce_ui/controllers/auth_controller.dart';
import 'package:ecommerce_ui/controllers/theme_controller.dart';
import 'package:ecommerce_ui/controllers/product_controller.dart';
import 'package:ecommerce_ui/controllers/category_controller.dart';
import 'package:ecommerce_ui/controllers/wishlist_controller.dart';
import 'package:ecommerce_ui/utils/app_themes.dart';
import 'package:ecommerce_ui/features/pages/splash_screen.dart';
import 'package:ecommerce_ui/utils/firestore_data_seeder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  Get.put(ThemeController());
  Get.put(AuthController());
  Get.put(CategoryController());
  Get.put(ProductController());
  Get.put(WishlistController());

  // Uncomment the line below to seed sample data (for testing only)
  await FirestoreDataSeeder.seedAllData();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fashion Store',
      theme: AppThemes.light,
      darkTheme: AppThemes.dark,
      themeMode: themeController.theme,
      defaultTransition: Transition.fade,
      home: SplashScreen(),
    );
  }
}
