import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:safe_bite/pages/scan_details.dart';
import 'package:safe_bite/themes.dart';

class Scanned {
  String nameOfProduct;
  String scannedImageurl;
  List predictedAllergies;
  bool isSafe;
  Timestamp time;

  Scanned({
    required this.nameOfProduct,
    required this.scannedImageurl,
    required this.predictedAllergies,
    required this.isSafe,
    required this.time,
  });
}

class ScanHistory extends StatefulWidget {
  const ScanHistory({super.key});

  @override
  State<ScanHistory> createState() => _ScanHistoryState();
}

class _ScanHistoryState extends State<ScanHistory> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String _email = "";
  List<Scanned> scanHistory = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserScanHistory();
  }

  Future<void> getUserScanHistory() async {
    final user = _auth.currentUser;

    if (user != null) {
      setState(() {
        _email = user.email!;
      });
      final querySnapshot = await _firestore
          .collection('scans')
          .doc(_email)
          .collection('scansOfthatUser')
          .get();

      scanHistory = querySnapshot.docs.map((document) {
        Map<String, dynamic> data = document.data();

        return Scanned(
          nameOfProduct: data['nameOfProduct'],
          scannedImageurl: data['scannedImageurl'],
          predictedAllergies: data['predictedAllergies'],
          isSafe: data['isSafe'],
          time: data['timestamp'],
        );
      }).toList();

      scanHistory.sort((a, b) => b.time.compareTo(a.time));
    }

    setState(() {
      scanHistory;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Previous Scans",
          style: customTextStyle_appbar,
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : scanHistory.isEmpty
              ? const Center(
                  child: Text("No scan history available"),
                )
              : ListView.builder(
                  itemCount: scanHistory.length,
                  itemBuilder: (context, index) {
                    Scanned scan = scanHistory[index];
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Card(
                            color: customBackgroundColor,
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              leading: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF749BC2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                    DateFormat('HH:mm\ndd-MM-yyyy')
                                        .format(scan.time.toDate()),
                                    style: customTextStyle_normal.copyWith(
                                        fontSize: 13,
                                        color: customBackgroundColor)),
                              ),
                              title: Text(scan.nameOfProduct,
                                  style: customTextStyle_normal.copyWith(
                                      fontSize: 18, color: Colors.black)),
                              subtitle: Text(
                                  'Predicted Allergies: ${scan.predictedAllergies.join(", ")}',
                                  style: customTextStyle_normal.copyWith(
                                      fontSize: 14, color: Colors.grey)),
                              trailing: Icon(
                                scan.isSafe
                                    ? Icons.check_box
                                    : Icons.warning_amber_rounded,
                                color: scan.isSafe ? Colors.green : Colors.red,
                                size: 34,
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return ScanDetailsScreen(scan: scan);
                                }));
                              },
                            ),
                          ),
                          const Divider(
                            color: Colors.grey,
                            thickness: 0.7,
                          )
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
