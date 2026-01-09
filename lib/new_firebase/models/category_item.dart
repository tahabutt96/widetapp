import 'package:flutter/material.dart';

class CategoryItem {
  final String name;
  final String emoji;
  final IconData? icon; // Optional Flutter icon

  CategoryItem({
    required this.name,
    required this.emoji,
    this.icon,
  });
}

// List of all categories matching Excel columns (Sheet1)
// Categories from "test developer.xlsx" - EXACT names from Excel file
List<CategoryItem> getAllCategories() {
  return [
    CategoryItem(name: 'هم وحزن', emoji: '😔', icon: Icons.nights_stay_rounded),
    CategoryItem(name: 'توفى شخص عزيز', emoji: '😢', icon: Icons.person_off_rounded),
    CategoryItem(name: 'اشعر بالوحدة', emoji: '😞', icon: Icons.person_outline_rounded),
    CategoryItem(name: 'انتهى صبري', emoji: '😤', icon: Icons.hourglass_empty_rounded),
    CategoryItem(name: 'اشعر بالظلم', emoji: '😠', icon: Icons.balance_rounded),
    CategoryItem(name: 'اشعر بالندم', emoji: '😰', icon: Icons.heart_broken_rounded),
    CategoryItem(name: 'احتاج الى الامل', emoji: '💭', icon: Icons.lightbulb_outline_rounded),
    CategoryItem(name: 'اشعر بالعجز والكسل', emoji: '😑', icon: Icons.battery_0_bar_rounded),
    CategoryItem(name: 'اشعر بالقلق والخوف', emoji: '😨', icon: Icons.psychology_alt_rounded),
    CategoryItem(name: 'اشعر بضيق الرزق', emoji: '💸', icon: Icons.account_balance_wallet_rounded),
    CategoryItem(name: 'ارتكبت ذنب', emoji: '😓', icon: Icons.error_outline_rounded),
    CategoryItem(name: 'احتاج الى الرضا والقناعة', emoji: '😌', icon: Icons.eco_rounded),
    CategoryItem(name: 'ارغب في التغيير وبداية جديدة', emoji: '🌟', icon: Icons.wb_sunny_rounded),
    CategoryItem(name: 'كيف اتعامل مع الناس', emoji: '🤔', icon: Icons.people_outline_rounded),
    CategoryItem(name: 'اشعر بالخذلان وعدم التقدير', emoji: '😢', icon: Icons.cloud_off_rounded),
    CategoryItem(name: 'اريد التقرب من الله', emoji: '🤲', icon: Icons.favorite_rounded),
  ];
}
