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

// List of all categories with their emojis
List<CategoryItem> getAllCategories() {
  return [
    CategoryItem(name: 'سعادة', emoji: '😊', icon: Icons.sentiment_satisfied_alt),
    CategoryItem(name: 'الحزن', emoji: '😢', icon: Icons.sentiment_dissatisfied),
    CategoryItem(name: 'غضب', emoji: '😠', icon: Icons.sentiment_very_dissatisfied),
    CategoryItem(name: 'قلق', emoji: '😰', icon: Icons.psychology_alt),
    CategoryItem(name: 'حيرة', emoji: '🤨', icon: Icons.help_outline),
    CategoryItem(name: 'فضول', emoji: '😑', icon: Icons.search),
    CategoryItem(name: 'حب', emoji: '😍', icon: Icons.favorite),
    CategoryItem(name: 'ضعف الإيمان', emoji: '😔', icon: Icons.trending_down),
    CategoryItem(name: 'المرض - الرقية الشرعية', emoji: '🤒', icon: Icons.healing),
    CategoryItem(name: 'عدم الصبر', emoji: '😳', icon: Icons.timer_off),
    CategoryItem(name: 'هم', emoji: '😞', icon: Icons.cloud),
    CategoryItem(name: 'الراحة', emoji: '🙂', icon: Icons.spa),
    CategoryItem(name: 'الرضى', emoji: '😌', icon: Icons.check_circle_outline),
    CategoryItem(name: 'الصدق', emoji: '😤', icon: Icons.verified),
  ];
}
