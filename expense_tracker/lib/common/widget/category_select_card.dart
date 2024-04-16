import 'package:flutter/material.dart';
import '../enums/saving_category.dart';

Widget buildCategorySelectCard(Widget Function(ItemCategory) mapFunction) {
  return Padding(
    padding: const EdgeInsets.all(28.0),
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const Text(
              "Select category",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 16.0,
              runSpacing: 10.0,
              children: ItemCategory.values.map(mapFunction).toList(),
            )
          ],
        ),
      ),
    ),
  );
}
