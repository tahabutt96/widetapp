import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_widget/home_widget.dart';
import '../utills/colors_resources.dart';

class WidgetPinPreviewDialog extends StatelessWidget {
  static const platform = MethodChannel('samples.flutter.dev/pinWidget');

  const WidgetPinPreviewDialog({Key? key}) : super(key: key);

  /// Shows the custom preview dialog
  static Future<void> show(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => const WidgetPinPreviewDialog(),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    Icons.widgets_rounded,
                    color: Colors.white,
                    size: 48,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'إضافة أداة الشاشة',
                    style: GoogleFonts.cairo(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'اعرض آياتك المفضلة على شاشتك الرئيسية',
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: Colors.white.withAlpha((0.9 * 255).toInt()),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Widget Preview
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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

            SizedBox(height: 10),

            // Info Section
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha((0.15 * 255).toInt()),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _InfoRow(
                    icon: Icons.auto_awesome,
                    text: 'تحديث تلقائي للآيات',
                  ),
                  SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.touch_app,
                    text: 'اضغط للانتقال للتطبيق',
                  ),
                  SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.favorite_border,
                    text: 'أضف للمفضلة مباشرة',
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Action Buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.white.withAlpha((0.2 * 255).toInt()),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.white.withAlpha((0.3 * 255).toInt())),
                        ),
                      ),
                      child: Text(
                        'إلغاء',
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  // Add Widget Button
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () => _pinWidget(context),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.white,
                        foregroundColor: ColorResources.THEMECOLOR,
                        elevation: 4,
                        shadowColor: Colors.black.withAlpha((0.3 * 255).toInt()),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_circle_outline, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'إضافة الأداة',
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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

  /// Calls the native code to pin the widget
  /// This will show a confirmation message instead of the native dialog
  static Future<void> _pinWidget(BuildContext context) async {
    try {
      Navigator.of(context).pop(); // Close custom dialog first

      // Call native method to prepare widget data
      final result = await platform.invokeMethod('pinWidget');

      // Show success message - the native dialog will appear automatically
      // We can't skip it, but we've already shown our beautiful preview
      if (context.mounted && result == 'requested') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'قم بتأكيد الإضافة في النافذة التالية',
              style: GoogleFonts.cairo(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            backgroundColor: ColorResources.THEMECOLOR,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.all(16),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'خطأ: $e',
              style: GoogleFonts.cairo(),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
      height: 200,
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
                size: 120,
                color: ColorResources.THEMECOLOR,
              ),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Message
                Expanded(
                  child: Center(
                    child: Text(
                      message,
                      style: GoogleFonts.amiriQuran(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: ColorResources.THEMECOLOR,
                        height: 1.8,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 5,
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
                        SizedBox(width: 8),
                        _MiniIconButton(icon: Icons.favorite_border),
                      ],
                    ),
                    // Category
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: ColorResources.BOTTOM_BAR_SELECTED,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        category,
                        style: GoogleFonts.cairo(
                          fontSize: 12,
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
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: ColorResources.BOTTOM_BAR_SELECTED,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 16,
        color: Colors.white,
      ),
    );
  }
}

/// Info row with icon and text
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.white.withAlpha((0.9 * 255).toInt()),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.cairo(
              fontSize: 13,
              color: Colors.white.withAlpha((0.9 * 255).toInt()),
            ),
          ),
        ),
      ],
    );
  }
}
