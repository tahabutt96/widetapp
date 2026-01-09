import 'package:appwidgetflutter/common/backgorund_image.dart';
import 'package:appwidgetflutter/new_firebase/models/verse_model.dart';
import 'package:appwidgetflutter/new_firebase/services/excel_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utills/colors_resources.dart';

class VersesByCategoryScreen extends StatefulWidget {
  final String categoryName;
  final List<VerseModel>? preloadedVerses;

  const VersesByCategoryScreen({
    Key? key,
    required this.categoryName,
    this.preloadedVerses,
  }) : super(key: key);

  @override
  State<VersesByCategoryScreen> createState() => _VersesByCategoryScreenState();
}

class _VersesByCategoryScreenState extends State<VersesByCategoryScreen> {
  List<VerseModel> verses = [];
  bool isLoading = true;
  int currentVerseIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadVerses();
  }

  Future<void> _loadVerses() async {
    // If verses are already preloaded, use them immediately
    if (widget.preloadedVerses != null) {
      print('✅ استخدام الآيات المحملة مسبقاً');
      setState(() {
        verses = widget.preloadedVerses!;
        isLoading = false;
        currentVerseIndex = 0;
      });

      // Update widget with first verse if available
      if (verses.isNotEmpty) {
        await _updateWidget(verses[0]);
      }
      return;
    }

    // Otherwise, load from Excel
    setState(() {
      isLoading = true;
    });

    try {
      print('Loading verses for category: ${widget.categoryName}');
      final filteredVerses = await ExcelService.getVersesByCategory(widget.categoryName);
      print('Found ${filteredVerses.length} verses');

      setState(() {
        verses = filteredVerses;
        isLoading = false;
        currentVerseIndex = 0;
      });

      // Update widget with first verse if available
      if (verses.isNotEmpty) {
        await _updateWidget(verses[0]);
      }
    } catch (e) {
      print('Error loading verses: $e');
      print('Stack trace: ${StackTrace.current}');
      setState(() {
        isLoading = false;
      });

      // Show error to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ أثناء تحميل الآيات: $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _updateWidget(VerseModel verse) async {
    await HomeWidget.saveWidgetData<String>('message', verse.verse);
    await HomeWidget.saveWidgetData<String>('category', widget.categoryName);
    await HomeWidget.updateWidget(
      name: 'AppWidgetProvider',
      iOSName: 'AppWidgetProvider',
    );

    // Save to SharedPreferences
    final sp = await SharedPreferences.getInstance();
    await sp.setString('CompletAyat', verse.verse);
    await sp.setString('Category', widget.categoryName);
  }

  void _nextVerse() {
    if (currentVerseIndex < verses.length - 1) {
      setState(() {
        currentVerseIndex++;
      });
      _updateWidget(verses[currentVerseIndex]);
    }
  }

  void _previousVerse() {
    if (currentVerseIndex > 0) {
      setState(() {
        currentVerseIndex--;
      });
      _updateWidget(verses[currentVerseIndex]);
    }
  }

  void _selectVerse(int index) {
    setState(() {
      currentVerseIndex = index;
    });
    _updateWidget(verses[index]);
    Navigator.pop(context); // Close the list dialog
  }

  void _showVersesList() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorResources.THEMECOLOR,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    'جميع الآيات (${verses.length})',
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 48),
                ],
              ),
            ),
            // Verses List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: verses.length,
                itemBuilder: (context, index) {
                  final verse = verses[index];
                  final isSelected = index == currentVerseIndex;

                  return InkWell(
                    onTap: () => _selectVerse(index),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 12),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? ColorResources.THEMECOLOR.withAlpha((0.1 * 255).toInt())
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? ColorResources.THEMECOLOR
                              : Colors.grey.withAlpha((0.3 * 255).toInt()),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Surah name
                          Text(
                            verse.surah,
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: ColorResources.THEMECOLOR,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          SizedBox(height: 8),
                          // Verse text (truncated)
                          Text(
                            verse.verse,
                            style: GoogleFonts.amiriQuran(
                              fontSize: 16,
                              color: ColorResources.BOTTOM_BAR_SELECTED,
                              height: 1.8,
                            ),
                            textAlign: TextAlign.right,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.THEMECOLOR,
      appBar: AppBar(
        backgroundColor: ColorResources.THEMECOLOR,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.categoryName,
          style: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.list, color: Colors.white),
            onPressed: verses.isNotEmpty ? _showVersesList : null,
          ),
        ],
      ),
      body: BackgroundImage(
        child: SafeArea(
          child: Column(
            children: [
              // Content
              Expanded(
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: ColorResources.THEMECOLOR,
                          ),
                        )
                      : verses.isEmpty
                          ? Center(
                              child: Text(
                                'لا توجد آيات لهذه الفئة',
                                style: GoogleFonts.cairo(
                                  fontSize: 18,
                                  color: ColorResources.BOTTOM_BAR_SELECTED,
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                // Verse counter
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  child: Text(
                                    'الآية ${currentVerseIndex + 1} من ${verses.length}',
                                    style: GoogleFonts.cairo(
                                      fontSize: 16,
                                      color: ColorResources.BOTTOM_BAR_SELECTED,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
          
                                // Verse display
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.all(20),
                                    padding: EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withAlpha((0.1 * 255).toInt()),
                                          blurRadius: 10,
                                          offset: Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          // Surah name
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: ColorResources.THEMECOLOR.withAlpha((0.1 * 255).toInt()),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              verses[currentVerseIndex].surah,
                                              style: GoogleFonts.cairo(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: ColorResources.THEMECOLOR,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(height: 24),
                                          // Verse text
                                          Text(
                                            verses[currentVerseIndex].verse,
                                            style: GoogleFonts.amiriQuran(
                                              fontSize: 22,
                                              color: ColorResources.BOTTOM_BAR_SELECTED,
                                              height: 2.0,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            textAlign: TextAlign.right,
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
          
                                // Navigation buttons
                                Container(
                                  padding: EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Next button
                                      ElevatedButton.icon(
                                        onPressed: currentVerseIndex < verses.length - 1 ? _nextVerse : null,
                                        icon: Icon(Icons.arrow_back),
                                        label: Text(
                                          'التالي',
                                          style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w600),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: ColorResources.THEMECOLOR,
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          disabledBackgroundColor: Colors.grey.withAlpha((0.3 * 255).toInt()),
                                        ),
                                      ),
          
                                      // Previous button
                                      ElevatedButton.icon(
                                        onPressed: currentVerseIndex > 0 ? _previousVerse : null,
                                        icon: Icon(Icons.arrow_forward),
                                        label: Text(
                                          'السابق',
                                          style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w600),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: ColorResources.THEMECOLOR,
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          disabledBackgroundColor: Colors.grey.withAlpha((0.3 * 255).toInt()),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
