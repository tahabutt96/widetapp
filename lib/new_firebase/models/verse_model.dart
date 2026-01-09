class VerseModel {
  final String surah; // Surah name (from column A)
  final String verse; // Verse text (from column A)
  final List<String> categories; // List of categories this verse belongs to

  VerseModel({
    required this.surah,
    required this.verse,
    required this.categories,
  });

  factory VerseModel.fromExcelRow(List<dynamic> row, List<String> categoryHeaders) {
    try {
      // Row structure based on Excel file:
      // Column 0: Verse text (آية)
      // Column 1 onwards: Category checkmarks

      if (row.isEmpty) {
        return VerseModel(
          surah: 'القرآن الكريم',
          verse: 'آية',
          categories: [],
        );
      }

      String verse = row[0]?.toString() ?? '';
      String surah = 'القرآن الكريم'; // Default surah name

      // Try to extract surah name if it's in the verse text
      if (verse.contains('\n')) {
        try {
          final lines = verse.split('\n');
          if (lines.length >= 2) {
            // First line might be surah name
            final firstLine = lines[0].trim();
            if (firstLine.length < 50 && firstLine.isNotEmpty) {
              surah = firstLine;
              verse = lines.sublist(1).join(' ').trim();
            }
          }
        } catch (e) {
          // If splitting fails, keep original verse
          print('Error splitting verse text: $e');
        }
      }

      // If verse is still empty, set a default
      if (verse.trim().isEmpty) {
        verse = row[0]?.toString() ?? 'آية';
      }

      // Find which categories this verse belongs to (columns with checkmarks/TRUE)
      List<String> verseCategories = [];

      // Start from column 1 (skip verse text column)
      for (int i = 1; i < row.length; i++) {
        try {
          // Make sure we don't exceed category headers length
          int categoryIndex = i - 1;
          if (categoryIndex >= 0 && categoryIndex < categoryHeaders.length) {
            final cellValue = row[i];

            // Check if cell has TRUE, checkmark, or any truthy value
            if (cellValue != null) {
              String cellStr = cellValue.toString().toLowerCase().trim();
              if (cellValue == true ||
                  cellStr == 'true' ||
                  cellStr == '1' ||
                  cellStr == 'yes') {
                verseCategories.add(categoryHeaders[categoryIndex]);
              }
            }
          }
        } catch (e) {
          // Skip this cell if there's an error
          continue;
        }
      }

      return VerseModel(
        surah: surah.isNotEmpty ? surah : 'القرآن الكريم',
        verse: verse.isNotEmpty ? verse : 'آية',
        categories: verseCategories,
      );
    } catch (e) {
      print('Critical error in fromExcelRow: $e');
      // Return a default verse model
      return VerseModel(
        surah: 'القرآن الكريم',
        verse: 'آية',
        categories: [],
      );
    }
  }

  @override
  String toString() {
    return 'VerseModel(surah: $surah, categories: $categories)';
  }
}
