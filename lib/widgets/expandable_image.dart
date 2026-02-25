import 'package:flutter/material.dart';

class ExpandableImage extends StatelessWidget {
  final String asset;

  const ExpandableImage({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // פתיחת התמונה ב־Dialog עם InteractiveViewer
            showDialog(
              context: context,
              barrierColor: Colors.transparent, // מסיר אפקט אפור
              builder: (context) => Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: EdgeInsets.zero,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: InteractiveViewer(
                    minScale: 1,
                    maxScale: 5,
                    child: Center(
                      child: Image.asset(asset),
                    ),
                  ),
                ),
              ),
            );
          },
          child: Image.asset(
            asset,
            width: 150, // קטן בתצוגה הראשית
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
