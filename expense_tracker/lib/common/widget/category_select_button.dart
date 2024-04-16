import 'package:flutter/material.dart';
import '../enums/saving_category.dart';
import '../functions/reusable.dart';

Widget buildCategorySelectButton(ItemCategory category, VoidCallback callback,
    bool isCurrentlySelected, BuildContext context) {
  Color color =
      isCurrentlySelected ? getCategoryColor(category, context) : Colors.grey;
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: IntrinsicWidth(
      child: IconButton.filledTonal(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          color: color,
          hoverColor: getCategoryColor(category, context).withAlpha(45),
          onPressed: () => callback(),
          icon: Row(children: [
            const Icon(Icons.check_circle_outline),
            const SizedBox(width: 4),
            Text(category.toString().split('.')[1])
          ])),
    ),
  );
}
