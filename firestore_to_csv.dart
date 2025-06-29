import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<void> exportCertificatesAsCSV() async {
  final querySnapshot =
      await FirebaseFirestore.instance.collection('certificates').get();

  final rows = <List<String>>[];
  rows.add([
    'Recipient',
    'Organization',
    'Purpose',
    'Issue Date',
    'Expiry Date',
    'Issued By',
  ]);

  for (var doc in querySnapshot.docs) {
    final data = doc.data();
    rows.add([
      data['recipient'] ?? '',
      data['organization'] ?? '',
      data['purpose'] ?? '',
      data['issue_date'] ?? '',
      data['expiry_date'] ?? '',
      data['issued_by'] ?? '',
    ]);
  }

  final csv = const ListToCsvConverter().convert(rows);
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/certificates.csv');
  await file.writeAsString(csv);

  await Share.shareXFiles([XFile(file.path)], text: 'Certificate CSV Export');
}
