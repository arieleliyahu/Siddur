import 'package:flutter/material.dart';
import 'prayer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> prayers = const [
    {'file': 'shacharit.txt', 'title': 'שחרית'},
    {'file': 'mincha.txt', 'title': 'מנחה'},
    {'file': 'arvit.txt', 'title': 'ערבית'},
    {'file': 'birkat_hamazon.txt', 'title': 'ברכת המזון'},
    {'file': 'birkat_meaen_3.txt', 'title': 'ברכת מעין שלוש'},
    {'file': 'birkot_hanehenin.txt', 'title': 'ברכות הנהנין'},
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // סינון תפילות לפי חיפוש
    final filteredPrayers = prayers
        .where((p) =>
            p['title']!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('סידור שפתיי תפתח'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // שדה חיפוש
              TextField(
                decoration: const InputDecoration(
                  labelText: 'חפש תפילה',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) {
                  setState(() {
                    searchQuery = val;
                  });
                },
              ),
              const SizedBox(height: 16),

              // רשימת תפילות
              Expanded(
                child: ListView.builder(
                  itemCount: filteredPrayers.length,
                  itemBuilder: (context, index) {
                    final prayer = filteredPrayers[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PrayerScreen(
                              fileName: prayer['file']!,
                              title: prayer['title']!,
                            ),
                          ),
                        ),
                        icon: const Icon(Icons.menu_book),
                        label: Text(prayer['title']!),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),
              const Text(
                'DEBUG VERSION 1.0.2',
                textAlign: TextAlign.center,
		style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
