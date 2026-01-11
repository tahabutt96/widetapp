import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/verse_model.dart';

class JsonService {
  static Map<String, dynamic>? _cachedJsonData;
  static List<String>? _cachedCategories;
  static Map<String, List<VerseModel>>? _cachedCategoryVerses;

  /// Load JSON file from assets
  static Future<Map<String, dynamic>> loadJsonFromAssets() async {
    if (_cachedJsonData != null) {
      return _cachedJsonData!;
    }

    try {
      print('📥 Loading JSON file...');
      final String jsonString = await rootBundle.loadString('assets/testdeveloper.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      _cachedJsonData = jsonData;
      print('✅ JSON file loaded successfully');
      return jsonData;
    } catch (e) {
      print('❌ Error loading JSON file: $e');
      rethrow;
    }
  }

  /// Get all category names from JSON
  static Future<List<String>> getCategoryHeaders() async {
    if (_cachedCategories != null) {
      return _cachedCategories!;
    }

    try {
      final jsonData = await loadJsonFromAssets();
      final List<dynamic> sheet1 = jsonData['Sheet1'] ?? [];

      if (sheet1.isEmpty) {
        return [];
      }

      // Get first row (header row) and extract category names
      final Map<String, dynamic> firstRow = sheet1[0];
      final categories = <String>[];

      // Skip 'Column1' which contains the verse text
      firstRow.forEach((key, value) {
        if (key != 'Column1' && key.trim().isNotEmpty) {
          categories.add(key.trim()); // Trim spaces from category names
        }
      });

      _cachedCategories = categories;
      print('✅ Found ${categories.length} categories');
      return categories;
    } catch (e) {
      print('❌ Error getting categories: $e');
      return [];
    }
  }

  /// Get verses for a specific category
  static Future<List<VerseModel>> getVersesByCategory(String categoryName) async {
    try {
      // Check cache first
      _cachedCategoryVerses ??= {};

      // Trim the category name for consistent matching
      final trimmedCategoryName = categoryName.trim();

      if (_cachedCategoryVerses!.containsKey(trimmedCategoryName)) {
        print('✅ Using cached data for category: $trimmedCategoryName');
        return _cachedCategoryVerses![trimmedCategoryName]!;
      }

      print('🔍 Loading verses for category: $trimmedCategoryName');

      final jsonData = await loadJsonFromAssets();
      final List<dynamic> sheet1 = jsonData['Sheet1'] ?? [];

      if (sheet1.isEmpty) {
        return [];
      }

      final verses = <VerseModel>[];

      // Skip first row (headers) and process data rows
      for (int i = 1; i < sheet1.length; i++) {
        final Map<String, dynamic> row = sheet1[i];

        // Check if this verse belongs to the category (trim keys for matching)
        bool belongsToCategory = false;
        row.forEach((key, value) {
          if (key.trim() == trimmedCategoryName && value == true) {
            belongsToCategory = true;
          }
        });

        if (belongsToCategory) {
          final verseText = row['Column1']?.toString() ?? '';
          if (verseText.isNotEmpty) {
            // Get all categories this verse belongs to
            final verseCategories = <String>[];
            row.forEach((key, value) {
              if (key != 'Column1' && value == true) {
                verseCategories.add(key.trim()); // Trim category names
              }
            });

            // Try to extract surah name from verse text
            String surah = 'القرآن الكريم';
            String verse = verseText;

            // Check if verse text contains surah name (usually at the end after newline or space)
            if (verseText.contains('سورة')) {
              final parts = verseText.split(RegExp(r'سورة\s+'));
              if (parts.length > 1) {
                surah = 'سورة ' + parts[1].trim();
                verse = parts[0].trim();
              }
            }

            verses.add(VerseModel(
              surah: surah,
              verse: verse,
              categories: verseCategories,
            ));
          }
        }
      }

      print('✅ Found ${verses.length} verses for category: $trimmedCategoryName');

      // Cache the result with trimmed name
      _cachedCategoryVerses![trimmedCategoryName] = verses;

      return verses;
    } catch (e) {
      print('❌ Error loading verses for category: $e');
      return [];
    }
  }

  /// Get all verses with all categories
  static Future<List<VerseModel>> getAllVerses() async {
    try {
      final jsonData = await loadJsonFromAssets();
      final List<dynamic> sheet1 = jsonData['Sheet1'] ?? [];

      if (sheet1.isEmpty) {
        return [];
      }

      final verses = <VerseModel>[];

      // Skip first row (headers) and process data rows
      for (int i = 1; i < sheet1.length; i++) {
        final Map<String, dynamic> row = sheet1[i];
        final verseText = row['Column1']?.toString() ?? '';

        if (verseText.isNotEmpty) {
          // Get all categories this verse belongs to
          final verseCategories = <String>[];
          row.forEach((key, value) {
            if (key != 'Column1' && value == true) {
              verseCategories.add(key.trim()); // Trim category names
            }
          });

          if (verseCategories.isNotEmpty) {
            // Try to extract surah name from verse text
            String surah = 'القرآن الكريم';
            String verse = verseText;

            // Check if verse text contains surah name
            if (verseText.contains('سورة')) {
              final parts = verseText.split(RegExp(r'سورة\s+'));
              if (parts.length > 1) {
                surah = 'سورة ' + parts[1].trim();
                verse = parts[0].trim();
              }
            }

            verses.add(VerseModel(
              surah: surah,
              verse: verse,
              categories: verseCategories,
            ));
          }
        }
      }

      print('✅ Loaded ${verses.length} total verses');
      return verses;
    } catch (e) {
      print('❌ Error loading all verses: $e');
      return [];
    }
  }

  /// Clear cache
  static void clearCache() {
    _cachedJsonData = null;
    _cachedCategories = null;
    _cachedCategoryVerses = null;
  }
}
