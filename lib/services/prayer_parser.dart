class PrayerParser {
  static Map<String, dynamic> parse(String text) {
    final lines = text.split('\n');
    List<Map<String, dynamic>> sections = [];

    for (var rawLine in lines) {
      // הסרת BOM אם קיים + trim רגיל
      String line = rawLine.replaceAll('\uFEFF', '').trim();

      print("LINE -> [$line]");
      if (line.isEmpty) continue;

      // תמונה
      if (line.startsWith('[[IMAGE:') && line.endsWith(']]')) {
        final fileName =
            line.replaceAll('[[IMAGE:', '').replaceAll(']]', '').trim();

        sections.add({
          "type": "image",
          "asset": "assets/images/$fileName",
        });
        continue;
      }

      // כותרת עם #
      if (line.startsWith('#')) {
        sections.add({
          "type": "title",
          "text": line.substring(1).trim(),
        });
        continue;
      }

      // כותרת עם @
      if (line.startsWith('@')) {
        sections.add({
          "type": "title",
          "text": line.substring(1).trim(),
        });
        continue;
      }

      // הערה *
      if (line.startsWith('*')) {
        sections.add({
          "type": "note",
          "text": line.substring(1).trim(),
        });
        continue;
      }

      // טקסט בסוגריים בלבד
      if (line.startsWith('(') && line.endsWith(')')) {
        sections.add({
          "type": "brackets",
          "text": line,
        });
        continue;
      }

      // פסקה רגילה
      sections.add({
        "type": "paragraph",
        "text": line,
      });
    }

    return {
      "sections": sections,
    };
  }
}
