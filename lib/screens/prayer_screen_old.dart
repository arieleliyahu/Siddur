import 'package:flutter/material.dart';
import '../services/prayer_repository.dart'; 
import '../supabase/supabase_client.dart';

class PrayerScreen extends StatefulWidget {
  final String fileName;
  final String title;

  const PrayerScreen({
    super.key,
    required this.fileName,
    required this.title,
  });

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  double fontSize = 22;
  late final PrayerRepository repo;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    repo = PrayerRepository(SupabaseManager.client);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // פונקציה לפרש את הסימון [[IMAGE:filename]]
  TextSpan parsePrayerText(String text) {
    final List<InlineSpan> children = [];

    final regex = RegExp(r'\[\[IMAGE:(.*?)\]\]');
    int lastIndex = 0;

    for (final match in regex.allMatches(text)) {
      // טקסט לפני התמונה
      if (match.start > lastIndex) {
        children.add(TextSpan(
          text: text.substring(lastIndex, match.start),
          style: TextStyle(fontSize: fontSize, height: 1.5, color: Colors.black),
        ));
      }

      final fileName = match.group(1)!.trim();
      children.add(WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Center(
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => Dialog(
                  child: InteractiveViewer(
                    child: Image.asset('assets/images/$fileName'),
                  ),
                ),
              );
            },
            child: Image.asset(
              'assets/images/$fileName',
              height: 150,
            ),
          ),
        ),
      ));

      lastIndex = match.end;
    }

    // טקסט אחרי התמונה
    if (lastIndex < text.length) {
      children.add(TextSpan(
        text: text.substring(lastIndex),
        style: TextStyle(fontSize: fontSize, height: 1.5, color: Colors.black),
      ));
    }

    return TextSpan(children: children);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
              onPressed: () => setState(() => fontSize += 2),
              icon: const Icon(Icons.add),
              tooltip: 'הגדל טקסט',
            ),
            IconButton(
              onPressed: () => setState(() {
                if (fontSize > 12) fontSize -= 2;
              }),
              icon: const Icon(Icons.remove),
              tooltip: 'הקטן טקסט',
            ),
          ],
        ),
        body: FutureBuilder<String>(
          future: repo.loadPrayer(widget.fileName),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snap.hasError) {
              return Center(
                child: Text(
                  'שגיאה בטעינה:\n${snap.error}',
                  textAlign: TextAlign.center,
                ),
              );
            }

            final text = snap.data ?? '';

            return Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                child: RichText(
                  text: parsePrayerText(text),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
