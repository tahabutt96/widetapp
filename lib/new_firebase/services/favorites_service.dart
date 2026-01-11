import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _favoritesKey = 'favorite_verses';

  /// Get all favorite verses
  static Future<List<String>> getFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? favorites = prefs.getStringList(_favoritesKey);
      return favorites ?? [];
    } catch (e) {
      print('❌ Error getting favorites: $e');
      return [];
    }
  }

  /// Check if a verse is favorited
  static Future<bool> isFavorite(String verseText) async {
    try {
      final favorites = await getFavorites();
      return favorites.contains(verseText);
    } catch (e) {
      print('❌ Error checking favorite: $e');
      return false;
    }
  }

  /// Add a verse to favorites
  static Future<bool> addFavorite(String verseText) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favorites = await getFavorites();

      if (!favorites.contains(verseText)) {
        favorites.add(verseText);
        await prefs.setStringList(_favoritesKey, favorites);
        print('✅ Added to favorites');
        return true;
      }
      return false;
    } catch (e) {
      print('❌ Error adding favorite: $e');
      return false;
    }
  }

  /// Remove a verse from favorites
  static Future<bool> removeFavorite(String verseText) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favorites = await getFavorites();

      if (favorites.contains(verseText)) {
        favorites.remove(verseText);
        await prefs.setStringList(_favoritesKey, favorites);
        print('✅ Removed from favorites');
        return true;
      }
      return false;
    } catch (e) {
      print('❌ Error removing favorite: $e');
      return false;
    }
  }

  /// Toggle favorite status
  static Future<bool> toggleFavorite(String verseText) async {
    final isFav = await isFavorite(verseText);
    if (isFav) {
      await removeFavorite(verseText);
      return false;
    } else {
      await addFavorite(verseText);
      return true;
    }
  }

  /// Clear all favorites
  static Future<void> clearAllFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_favoritesKey);
      print('✅ Cleared all favorites');
    } catch (e) {
      print('❌ Error clearing favorites: $e');
    }
  }

  /// Get favorites count
  static Future<int> getFavoritesCount() async {
    final favorites = await getFavorites();
    return favorites.length;
  }
}
