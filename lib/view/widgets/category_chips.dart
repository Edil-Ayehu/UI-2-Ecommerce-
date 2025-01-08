import 'package:flutter/material.dart';

class CategoryChips extends StatefulWidget {
  const CategoryChips({super.key});

  @override
  State<CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  int selectedIndex = 0;
  final categories = ['All', 'Men', 'Women', 'Girls'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: List.generate(
          categories.length,
          (index) => Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(categories[index]),
              selected: selectedIndex == index,
              onSelected: (bool selected) {
                setState(() {
                  selectedIndex = selected ? index : selectedIndex;
                });
              },
              selectedColor: Theme.of(context).primaryColor,
              labelStyle: TextStyle(
                color: selectedIndex == index ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
