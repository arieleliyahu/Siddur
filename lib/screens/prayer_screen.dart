import 'package:flutter/material.dart';
import '../services/prayer_repository.dart';
import '../supabase/supabase_client.dart';
import '../parser/prayer_parser.dart';
import '../widgets/PrayerContent.dart';

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
  List<dynamic> sections = [];

  @override
  void initState() {
    super.initState();
    repo = PrayerRepository(SupabaseManager.client);
    _scrollController = ScrollController();
    _loadPrayer();
  }

  Future<void> _loadPrayer() async {
    try {
      final text = await repo.loadPrayer(widget.fileName);
      final parsed = PrayerParser.parse(text);
      setState(() => sections = parsed["sections"]);
      print(sections); // DEBUG
    } catch (e) {
      print("Error loading prayer: $e");
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (sections.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () => setState(() => fontSize += 2),
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () => setState(() {
              if (fontSize > 12) fontSize -= 2;
            }),
            icon: const Icon(Icons.remove),
          ),
        ],
      ),
      body: PrayerContent(
        sections: sections,
        baseFontSize: fontSize,
      ),
    );
  }
}
