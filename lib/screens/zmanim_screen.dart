import 'package:flutter/material.dart';
import '../services/zmanim_service.dart';
import '../services/location_service.dart';

class ZmanimScreen extends StatefulWidget {
  const ZmanimScreen({super.key});

  @override
  State<ZmanimScreen> createState() => _ZmanimScreenState();
}

class _ZmanimScreenState extends State<ZmanimScreen> {
  Future<Map<String, dynamic>>? zmanimFuture;

  @override
  void initState() {
    super.initState();
    loadZmanim();
  }

  Future<void> loadZmanim() async {
    try {
      final position = await LocationService.getLocation();

      setState(() {
        zmanimFuture = ZmanimService.getZmanim(
          latitude: position.latitude,
          longitude: position.longitude,
        );
      });
    } catch (e) {
      debugPrint("Location error: $e");
    }
  }

  String formatTime(String? time) {
    if (time == null) return "--:--";

    final dt = DateTime.parse(time).toLocal();

    return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }

  DateTime? parseTime(String? time) {
    if (time == null) return null;
    return DateTime.parse(time).toLocal();
  }

  Widget zmanCard(String title, String? time, bool highlight) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: highlight ? Colors.orange.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            formatTime(time),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("זמני היום"),
        ),
        body: zmanimFuture == null
            ? const Center(child: CircularProgressIndicator())
            : FutureBuilder(
                future: zmanimFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text("שגיאה בטעינת הזמנים"));
                  }

                  final data = snapshot.data!;
                  final times =
                      Map<String, dynamic>.from(data["times"] ?? {});

                  final now = DateTime.now();

                  final zmanList = [
                    {"title": "עלות השחר", "time": times["alotHaShachar"]},
                    {"title": "נץ החמה", "time": times["sunrise"]},
                    {"title": "סוף זמן ק\"ש גר\"א", "time": times["sofZmanShmaGRA"]},
                    {"title": "סוף זמן ק\"ש מ\"א", "time": times["sofZmanShmaMGA"]},
                    {"title": "חצות היום", "time": times["chatzot"]},
                    {"title": "שקיעה", "time": times["sunset"]},
                  ];

                  // מציאת הזמן הבא
                  int nextIndex = -1;

                  for (int i = 0; i < zmanList.length; i++) {
                    final t = parseTime(zmanList[i]["time"]);
                    if (t != null && t.isAfter(now)) {
                      nextIndex = i;
                      break;
                    }
                  }

                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      const Text(
                        "זמני היום",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      ...List.generate(zmanList.length, (index) {
                        final z = zmanList[index];

                        return zmanCard(
                          z["title"] as String,
                          z["time"] as String?,
                          index == nextIndex,
                        );
                      }),

                      const SizedBox(height: 25),

                      const Divider(),

                      const SizedBox(height: 10),

                      const Text(
                        "זמני שבת",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      zmanCard(
                        "כניסת שבת",
                        times["candleLighting"] ?? times["sunset"],
                        false,
                      ),

                      zmanCard(
                        "צאת שבת",
                        times["tzeit"],
                        false,
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}