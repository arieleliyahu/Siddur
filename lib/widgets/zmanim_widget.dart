import 'package:flutter/material.dart';
import '../services/zmanim_service.dart';

class ZmanimWidget extends StatefulWidget {
  const ZmanimWidget({super.key});

  @override
  State<ZmanimWidget> createState() => _ZmanimWidgetState();
}

class _ZmanimWidgetState extends State<ZmanimWidget> {

  late Future<Map<String, dynamic>> zmanimFuture;

  @override
  void initState() {
    super.initState();

    // חריש
    zmanimFuture = ZmanimService.getZmanim(
      latitude: 32.466,
      longitude: 35.043,
    );
  }

  String formatTime(String time) {
    final dt = DateTime.parse(time).toLocal();
    return "${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}";
  }

  Widget zmanRow(String title, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(formatTime(time), style: const TextStyle(fontSize: 18)),
          Text(title, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: zmanimFuture,
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("שגיאה בטעינת זמני היום"));
        }

        final data = snapshot.data!;
        final times = data["times"];

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [

            zmanRow("עלות השחר", times["alotHaShachar"]),
            zmanRow("נץ החמה", times["sunrise"]),
            zmanRow("סוף זמן ק\"ש גר\"א", times["sofZmanShmaGRA"]),
            zmanRow("סוף זמן ק\"ש מ\"א", times["sofZmanShmaMGA"]),
            zmanRow("חצות היום", times["chatzot"]),
            zmanRow("שקיעה", times["sunset"]),

          ],
        );
      },
    );
  }
}