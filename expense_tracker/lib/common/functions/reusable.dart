import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../enums/saving_category.dart';
import '../utils/app_colors.dart';

String formatDate(DateTime date) {
  return DateFormat("dd.MM.yyyy").format(date);
}

Color getCategoryColor(ItemCategory category, BuildContext context) {
  switch (category) {
    case ItemCategory.apparel:
      return _getColorDependingOnTheme(AppColors.apparelLight, AppColors.apparelDark, context);
    case ItemCategory.food:
      return _getColorDependingOnTheme(AppColors.foodLight, AppColors.foodDark, context);
    case ItemCategory.sport:
      return _getColorDependingOnTheme(AppColors.sportLight, AppColors.sportDark, context);
    case ItemCategory.electronics:
      return _getColorDependingOnTheme(
          AppColors.electronicsLight, AppColors.electronicsDark, context);
    case ItemCategory.other:
      return _getColorDependingOnTheme(AppColors.otherLight, AppColors.otherDark, context);
    default:
      return _getColorDependingOnTheme(const Color(0xff9f761c), const Color(0xffffe4a9), context);
  }
}

Color _getColorDependingOnTheme(Color lightModeColor, Color darkModeColor, BuildContext context) {
  bool isInLightMode = MediaQuery.of(context).platformBrightness == Brightness.light;
  return isInLightMode ? lightModeColor : darkModeColor;
}

// chunk categories into rows of 3
List<List<ItemCategory>> chunk<ItemCategory>(List<ItemCategory> list, int chunkSize) {
  List<List<ItemCategory>> chunks = [];
  for (var i = 0; i < list.length; i += chunkSize) {
    chunks.add(list.sublist(i, i + chunkSize > list.length ? list.length : i + chunkSize));
  }
  return chunks;
}

String capitalizeWord(String word) => word.substring(0, 1).toUpperCase() + word.substring(1);
