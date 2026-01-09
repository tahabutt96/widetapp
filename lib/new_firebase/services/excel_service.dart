import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import '../models/verse_model.dart';

class ExcelService {
  static List<VerseModel>? _cachedVerses;
  static List<String>? _cachedCategoryHeaders;
  static Map<String, List<VerseModel>>? _cachedCategoryVerses; // Cache verses by category

  /// Load Excel file from assets and parse all verses
  static Future<List<VerseModel>> loadVersesFromAssets() async {
    // Return cached data if already loaded
    if (_cachedVerses != null) {
      return _cachedVerses!;
    }

    try {
      print('Starting to load Excel file...');

      // Load Excel file from assets
      final ByteData data = await rootBundle.load('assets/test developer.xlsx');
      print('Excel file loaded, size: ${data.lengthInBytes} bytes');

      final bytes = data.buffer.asUint8List();
      final excel = Excel.decodeBytes(bytes);
      print('Excel decoded successfully');

      // Get the first sheet (Sheet1)
      if (excel.tables.isEmpty) {
        print('No tables found in Excel file');
        return [];
      }

      final sheetName = excel.tables.keys.first;
      print('Reading sheet: $sheetName');
      final sheet = excel.tables[sheetName];

      if (sheet == null || sheet.rows.isEmpty) {
        print('Excel sheet is empty or null');
        return [];
      }

      print('Sheet has ${sheet.rows.length} rows');

      // First row contains headers (category names)
      final headerRow = sheet.rows[0];
      final categoryHeaders = <String>[];

      // Skip column A (verse text), get category names from columns B onwards
      for (int i = 1; i < headerRow.length; i++) {
        final cellValue = headerRow[i]?.value?.toString() ?? '';
        if (cellValue.isNotEmpty && cellValue.trim().isNotEmpty) {
          categoryHeaders.add(cellValue.trim());
        }
      }

      _cachedCategoryHeaders = categoryHeaders;
      print('Found ${categoryHeaders.length} categories: $categoryHeaders');

      // Parse all verses (skip header row)
      final verses = <VerseModel>[];
      int parsedCount = 0;
      int consecutiveEmptyRows = 0;
      final maxConsecutiveEmpty = 10; // Stop after 10 consecutive empty rows

      print('Starting to parse verses...');

      for (int rowIndex = 1; rowIndex < sheet.rows.length; rowIndex++) {
        try {
          final row = sheet.rows[rowIndex];

          // Quick check: if row is null or has no cells, skip
          if (row.isEmpty) {
            consecutiveEmptyRows++;
            if (consecutiveEmptyRows >= maxConsecutiveEmpty) {
              print('Stopped parsing after $consecutiveEmptyRows consecutive empty rows at row $rowIndex');
              break;
            }
            continue;
          }

          // Quick check: get first cell value
          final firstCellValue = row[0]?.value;

          // Skip empty rows
          if (firstCellValue == null || firstCellValue.toString().trim().isEmpty) {
            consecutiveEmptyRows++;
            if (consecutiveEmptyRows >= maxConsecutiveEmpty) {
              print('Stopped parsing after $consecutiveEmptyRows consecutive empty rows at row $rowIndex');
              break;
            }
            continue;
          }

          // Reset empty row counter since we found a non-empty row
          consecutiveEmptyRows = 0;

          // Convert row to list of values (only when needed)
          final rowValues = <dynamic>[];
          for (var cell in row) {
            rowValues.add(cell?.value);
          }

          final verse = VerseModel.fromExcelRow(rowValues, categoryHeaders);

          // Only add verses that belong to at least one category
          if (verse.categories.isNotEmpty) {
            verses.add(verse);
            parsedCount++;

            // Log progress every 50 verses
            if (parsedCount % 50 == 0) {
              print('Parsed $parsedCount verses so far...');
            }
          }

        } catch (e) {
          print('Error parsing row $rowIndex: $e');
          // Continue with next row
        }
      }

      _cachedVerses = verses;
      print('Successfully loaded ${verses.length} verses from Excel');
      print('Total verses parsed: $parsedCount');

      return verses;
    } catch (e, stackTrace) {
      print('Error loading Excel file: $e');
      print('Stack trace: $stackTrace');
      rethrow; // Re-throw to let caller handle it
    }
  }

  /// Load verses ONLY for the selected category (much faster!)
  static Future<List<VerseModel>> getVersesByCategory(String categoryName) async {
    try {
      // Initialize cache if needed
      _cachedCategoryVerses ??= {};

      // Check cache first
      if (_cachedCategoryVerses!.containsKey(categoryName)) {
        print('✅ استخدام البيانات المحفوظة للفئة: $categoryName');
        print('📊 عدد الآيات المحفوظة: ${_cachedCategoryVerses![categoryName]!.length}');
        return _cachedCategoryVerses![categoryName]!;
      }

      print('🔍 جاري البحث عن الآيات للفئة: $categoryName');
      print('📥 جاري تحميل ملف Excel...');

      // Load Excel file
      final ByteData data = await rootBundle.load('assets/test developer.xlsx');
      final bytes = data.buffer.asUint8List();
      final excel = Excel.decodeBytes(bytes);

      final sheet = excel.tables[excel.tables.keys.first];
      if (sheet == null || sheet.rows.isEmpty) {
        print('❌ ملف Excel فارغ');
        return [];
      }

      print('📄 تم فتح الملف - عدد الصفوف: ${sheet.rows.length}');

      // Get category headers
      final headerRow = sheet.rows[0];
      final categoryHeaders = <String>[];
      int categoryColumnIndex = -1;

      for (int i = 1; i < headerRow.length; i++) {
        final cellValue = headerRow[i]?.value?.toString()?.trim() ?? '';
        if (cellValue.isNotEmpty) {
          categoryHeaders.add(cellValue);
          // Find the column index for our category
          if (cellValue == categoryName) {
            categoryColumnIndex = i;
            print('✓ تم العثور على الفئة في العمود رقم $i');
          }
        }
      }

      if (categoryColumnIndex == -1) {
        print('❌ الفئة "$categoryName" غير موجودة في الملف');
        print('الفئات المتاحة: $categoryHeaders');
        return [];
      }

      // Parse ONLY verses that belong to this category
      final verses = <VerseModel>[];
      int consecutiveEmptyRows = 0;
      int checkedRows = 0;

      for (int rowIndex = 1; rowIndex < sheet.rows.length; rowIndex++) {
        final row = sheet.rows[rowIndex];

        if (row.isEmpty) {
          consecutiveEmptyRows++;
          if (consecutiveEmptyRows >= 10) {
            print('⏹️ توقف البحث بعد 10 صفوف فارغة متتالية');
            break;
          }
          continue;
        }

        final firstCellValue = row[0]?.value;
        if (firstCellValue == null || firstCellValue.toString().trim().isEmpty) {
          consecutiveEmptyRows++;
          if (consecutiveEmptyRows >= 10) {
            print('⏹️ توقف البحث بعد 10 صفوف فارغة متتالية');
            break;
          }
          continue;
        }

        consecutiveEmptyRows = 0;
        checkedRows++;

        // Quick check: does this verse belong to our category?
        if (categoryColumnIndex < row.length) {
          final categoryCell = row[categoryColumnIndex]?.value;

          // Debug: log first few rows and ALL checkmarks
          if (checkedRows <= 10) {
            print('صف $rowIndex: قيمة الخانة = $categoryCell (نوع: ${categoryCell.runtimeType})');
          }

          // Check if this cell has a TRUE checkmark
          // The Excel library returns BoolCellValue objects
          // We need to check if the value equals true
          bool hasCheckmark = (categoryCell == true ||
                               categoryCell.toString() == 'true' ||
                               categoryCell.toString() == '1');

          if (hasCheckmark) {
            print('✓ وجدت علامة صح في صف $rowIndex!');

            // Convert row to values
            final rowValues = <dynamic>[];
            for (var cell in row) {
              rowValues.add(cell?.value);
            }

            final verse = VerseModel.fromExcelRow(rowValues, categoryHeaders);
            if (verse.categories.contains(categoryName)) {
              verses.add(verse);
              if (verses.length <= 3) {
                print('✓ تم إضافة آية ${verses.length}');
              }
            }
          }
        }
      }

      print('✅ اكتمل البحث: تم فحص $checkedRows صف');
      print('📊 النتيجة: ${verses.length} آية للفئة "$categoryName"');

      // Save to cache for next time
      _cachedCategoryVerses![categoryName] = verses;
      print('💾 تم حفظ البيانات في الذاكرة المؤقتة');

      return verses;

    } catch (e, stackTrace) {
      print('Error loading verses for category: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  /// Get all category headers
  static List<String> getCategoryHeaders() {
    return _cachedCategoryHeaders ?? [];
  }

  /// Clear cache (useful when reloading data)
  static void clearCache() {
    _cachedVerses = null;
    _cachedCategoryHeaders = null;
  }
}
