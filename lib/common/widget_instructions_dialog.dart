import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_widget/home_widget.dart';
import '../utills/colors_resources.dart';

/// Alternative dialog that shows manual instructions instead of triggering native dialog
class WidgetInstructionsDialog extends StatelessWidget {
  const WidgetInstructionsDialog({Key? key}) : super(key: key);

  /// Shows the instructions dialog
  static Future<void> show(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => const WidgetInstructionsDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ColorResources.THEMECOLOR.withAlpha((0.95 * 255).toInt()),
              ColorResources.BOTTOM_BAR_SELECTED.withAlpha((0.95 * 255).toInt()),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: ColorResources.THEMECOLOR.withAlpha((0.3 * 255).toInt()),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: Colors.white,
                      size: 48,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'كيفية إضافة الأداة',
                      style: GoogleFonts.cairo(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Widget Preview
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: FutureBuilder<Map<String, String>>(
                  future: _getWidgetData(),
                  builder: (context, snapshot) {
                    final message = snapshot.data?['message'] ?? 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ';
                    final category = snapshot.data?['category'] ?? 'آية اليوم';

                    return _WidgetPreviewCard(
                      message: message,
                      category: category,
                    );
                  },
                ),
              ),

              SizedBox(height: 20),

              // Instructions
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha((0.15 * 255).toInt()),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'خطوات الإضافة:',
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    _InstructionStep(
                      number: '١',
                      text: 'اضغط مطولاً على الشاشة الرئيسية',
                      icon: Icons.touch_app,
                    ),
                    SizedBox(height: 12),
                    _InstructionStep(
                      number: '٢',
                      text: 'اختر "أدوات" أو "Widgets"',
                      icon: Icons.widgets,
                    ),
                    SizedBox(height: 12),
                    _InstructionStep(
                      number: '٣',
                      text: 'ابحث عن "معنى دنيي" واسحب الأداة',
                      icon: Icons.search,
                    ),
                    SizedBox(height: 12),
                    _InstructionStep(
                      number: '٤',
                      text: 'ضع الأداة في المكان المناسب',
                      icon: Icons.check_circle,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Close Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.white,
                    foregroundColor: ColorResources.THEMECOLOR,
                    elevation: 4,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'فهمت',
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Fetches current widget data from SharedPreferences
  static Future<Map<String, String>> _getWidgetData() async {
    final message = await HomeWidget.getWidgetData<String>('message');
    final category = await HomeWidget.getWidgetData<String>('category');

    return {
      'message': message ?? 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
      'category': category ?? 'آية اليوم',
    };
  }
}

/// Instruction step widget
class _InstructionStep extends StatelessWidget {
  final String number;
  final String text;
  final IconData icon;

  const _InstructionStep({
    required this.number,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ColorResources.THEMECOLOR,
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        Icon(
          icon,
          color: Colors.white.withAlpha((0.9 * 255).toInt()),
          size: 20,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

/// Widget Preview Card - mimics the actual widget appearance
class _WidgetPreviewCard extends StatelessWidget {
  final String message;
  final String category;

  const _WidgetPreviewCard({
    required this.message,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.2 * 255).toInt()),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Icon(
                Icons.auto_stories,
                size: 100,
                color: ColorResources.THEMECOLOR,
              ),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                // Message
                Expanded(
                  child: Center(
                    child: Text(
                      message,
                      style: GoogleFonts.amiriQuran(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: ColorResources.THEMECOLOR,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                // Bottom Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Action Icons
                    Row(
                      children: [
                        _MiniIconButton(icon: Icons.share),
                        SizedBox(width: 6),
                        _MiniIconButton(icon: Icons.favorite_border),
                      ],
                    ),
                    // Category
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: ColorResources.BOTTOM_BAR_SELECTED,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        category,
                        style: GoogleFonts.cairo(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Mini icon button for widget preview
class _MiniIconButton extends StatelessWidget {
  final IconData icon;

  const _MiniIconButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: ColorResources.BOTTOM_BAR_SELECTED,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 14,
        color: Colors.white,
      ),
    );
  }
}
