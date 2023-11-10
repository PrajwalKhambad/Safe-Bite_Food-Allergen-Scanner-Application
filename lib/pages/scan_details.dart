import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:safe_bite/pages/scan_history.dart';

class ScanDetailsScreen extends StatefulWidget {
  final Scanned scan;
  const ScanDetailsScreen({required this.scan, Key? key}) : super(key: key);

  @override
  State<ScanDetailsScreen> createState() => _ScanDetailsScreenState();
}

class _ScanDetailsScreenState extends State<ScanDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Details"),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Chip(label: Text("Product name: ${widget.scan.nameOfProduct}")),
          Chip(label: Text("Time: ${DateFormat('dd-MM-yyyy\tHH:mm').format(widget.scan.time.toDate())}"),),
          Image.network(widget.scan.scannedImageurl, fit: BoxFit.cover,),
          Chip(label: Text("Predicted Allergies: ${widget.scan.predictedAllergies.join(", ")}"),),
          Chip(label: Text("Is Safe: ${widget.scan.isSafe ? "Yes" : "No"}"),)
        ]),
      ),
    );
  }
}