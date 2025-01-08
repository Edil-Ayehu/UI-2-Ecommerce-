import 'package:flutter/material.dart';
import 'package:ecommerce_ui/utils/app_textstyles.dart';

class SaleBanner extends StatelessWidget {
  const SaleBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Get Your',
                  style: AppTextStyle.withColor(
                    AppTextStyle.h3,
                    Colors.white,
                  ),
                ),
                Text(
                  'Special Sale',
                  style: AppTextStyle.withColor(
                    AppTextStyle.withWeight(
                      AppTextStyle.h2,
                      FontWeight.bold,
                    ),
                    Colors.white,
                  ),
                ),
                Text(
                  'Up to 40%',
                  style: AppTextStyle.withColor(
                    AppTextStyle.h3,
                    Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            child: Text(
              'Shop Now',
              style: AppTextStyle.buttonMedium,
            ),
          ),
        ],
      ),
    );
  }
}
