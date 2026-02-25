class PrayerParser {
  static Map<String, dynamic> parse(String text) {
    final lines = text.split('\n');
    List<Map<String, dynamic>> sections = [];

    for (var rawLine in lines) {
      String line = rawLine.replaceAll('\uFEFF', '').trim();
      if (line.isEmpty) continue;

      // תמונות
      if (line.startsWith('[[IMAGE:') && line.endsWith(']]')) {
        final fileName =
            line.replaceAll('[[IMAGE:', '').replaceAll(']]', '').trim();
        sections.add({
          "type": "image",
          "asset": "assets/images/$fileName",
        });
        continue;
      }

      // כותרות גדולות
      if (line.startsWith('#') || line.startsWith('@')) {
        sections.add({
          "type": "title",
          "text": line.substring(1).trim(),
        });
        continue;
      }

      // הערה קטנה
      if (line.startsWith('*')) {
        sections.add({
          "type": "note",
          "text": line.substring(1).trim(),
        });
        continue;
      }

      // טקסט בסוגריים
      if (line.startsWith('(') && line.endsWith(')')) {
        sections.add({
          "type": "brackets",
          "text": line,
        });
        continue;
      }

      // טקסט קטן inline «…»
      if (line.contains('«') && line.contains('»')) {
        List<Map<String, dynamic>> parsedLine = [];
        int start = 0;
        final regex = RegExp(r'«(.*?)»');
        for (final match in regex.allMatches(line)) {
          if (match.start > start) {
            parsedLine.add({
              "type": "paragraph",
              "text": line.substring(start, match.start),
            });
          }
          parsedLine.add({
            "type": "small",
            "text": match.group(1)!,
          });
          start = match.end;
        }
        if (start < line.length) {
          parsedLine.add({
            "type": "paragraph",
            "text": line.substring(start),
          });
        }
        sections.addAll(parsedLine);
        continue;
      }

      // פסקה רגילה
      sections.add({
        "type": "paragraph",
        "text": line,
      });
    }

    return {"sections": sections};
  }
}
