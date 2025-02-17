import 'package:ecommerce_ui/features/auth/widgets/custom_textfield.dart';
import 'package:ecommerce_ui/features/pages/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_ui/utils/app_textstyles.dart';
import 'package:ecommerce_ui/features/auth/signin_screen.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Create Account',
                style: AppTextStyle.withColor(
                  AppTextStyle.h1,
                  Theme.of(context).textTheme.bodyLarge!.color!,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sign up to get started',
                style: AppTextStyle.withColor(
                  AppTextStyle.bodyLarge,
                  isDark ? Colors.grey[400]! : Colors.grey[600]!,
                ),
              ),
              const SizedBox(height: 40),
              // Full Name TextField
CustomTextField(
  label: 'Full Name',
  prefixIcon: Icons.person_outline,
  keyboardType: TextInputType.name,
  controller: _nameController,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  },
),
              const SizedBox(height: 16),
              // Email TextField
CustomTextField(
  label: 'Email',
  prefixIcon: Icons.email_outlined,
  keyboardType: TextInputType.emailAddress,
  controller: _emailController,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  },
),
              const SizedBox(height: 16),
              // Password TextField
CustomTextField(
  label: 'Password',
  prefixIcon: Icons.lock_outline,
  keyboardType: TextInputType.visiblePassword,
  isPassword: true,
  controller: _passwordController,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  },
),
              const SizedBox(height: 16),
              // Confirm Password TextField
CustomTextField(
  label: 'Confirm Password',
  prefixIcon: Icons.lock_outline,
  keyboardType: TextInputType.visiblePassword,
  isPassword: true,
  controller: _confirmPasswordController,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  },
),
              const SizedBox(height: 24),
              // Sign Up Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.off(() => MainScreen()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Sign Up',
                    style: AppTextStyle.withColor(
                      AppTextStyle.buttonMedium,
                      Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Sign In TextButton
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: AppTextStyle.withColor(
                      AppTextStyle.bodyMedium,
                      isDark ? Colors.grey[400]! : Colors.grey[600]!,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.off(() => SignInScreen()),
                    child: Text(
                      'Sign In',
                      style: AppTextStyle.withColor(
                        AppTextStyle.buttonMedium,
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
