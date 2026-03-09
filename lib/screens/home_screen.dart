import 'package:flutter/material.dart';
import 'prayer_screen.dart';
import 'zmanim_screen.dart';

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
    {'file': 'kriat_shma_al_hamita.txt', 'title': 'קריאת שמע על המיטה'},
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {

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

              // חיפוש
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

              Expanded(
                child: ListView(
                  children: [

                    // תפילות
                    ...filteredPrayers.map((prayer) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.menu_book),
                          label: Text(prayer['title']!),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PrayerScreen(
                                  fileName: prayer['file']!,
                                  title: prayer['title']!,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),

                    const SizedBox(height: 20),

                    // זמני היום
                    ElevatedButton.icon(
                      icon: const Icon(Icons.wb_sunny),
                      label: const Text("זמני היום"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ZmanimScreen(),
                          ),
                        );
                      },
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'DEBUG VERSION 1.0.3',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}