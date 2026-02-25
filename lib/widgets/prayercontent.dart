import 'package:flutter/material.dart';
import 'expandable_image.dart';

class PrayerContent extends StatelessWidget {
  final List<dynamic> sections;
  final double baseFontSize;

  const PrayerContent({
    super.key,
    required this.sections,
    this.baseFontSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sections.length,
      itemBuilder: (context, index) {
        final section = sections[index];
        final type = section["type"];

        switch (type) {
          case "image":
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: ExpandableImage(asset: section["asset"]),
            );

          case "title":
            return _buildText(
              section["text"],
              fontSize: baseFontSize + 6,
              fontWeight: FontWeight.bold,
            );

          case "note":
            return _buildText(
              section["text"],
              fontSize: baseFontSize - 4,
              color: Colors.grey[600],
            );

          case "brackets":
            return _buildText(
              section["text"],
              fontSize: baseFontSize - 2,
              fontStyle: FontStyle.italic,
            );

          case "small":
            return _buildText(
              section["text"],
              fontSize: baseFontSize - 6,
              color: Colors.black54,
            );

          case "paragraph":
          default:
            return _buildText(
              section["text"],
              fontSize: baseFontSize,
            );
        }
      },
    );
  }

  Widget _buildText(
    String text, {
    required double fontSize,
    FontWeight fontWeight = FontWeight.normal,
    FontStyle fontStyle = FontStyle.normal,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Text(
        text,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          color: color ?? Colors.black,
        ),
      ),
    );
  }
}
