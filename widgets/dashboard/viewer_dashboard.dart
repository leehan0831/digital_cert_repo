import 'package:digital_cert/widgets/recipient/verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_cert/widgets/profile_page.dart';
import 'package:digital_cert/widgets/viewer/verify_certificate.dart';
import 'package:digital_cert/widgets/viewer/certificate_doc.dart';

class ViewerDashboard extends StatefulWidget {
const ViewerDashboard ({super.key});

@override
State<ViewerDashboard> createState() => _ViewerDashboardMainState();
}

class _ViewerDashboardMainState extends State<ViewerDashboard>
with TickerProviderStateMixin {
late TabController tabController;
int _selectedBottomIndex = 0;
String? secureLink;
User? user;
List<DocumentSnapshot> certificates = [];

@override
void initState() {
super.initState();
tabController = TabController(length: 2, vsync: this);
user = FirebaseAuth.instance.currentUser;
fetchCertificates();
}

void onTabChanged(int index) {
fetchCertificates();
}

Future<void> fetchCertificates() async {
final snapshot = await FirebaseFirestore.instance
    .collection('certificates')
    .where('recipientId', isEqualTo: user?.uid)
    .get();

setState(() {
certificates = snapshot.docs;
});
}

int countByStatus(String status) {
return certificates.where((doc) => doc['status'] == status).length;
}

@override
Widget build(BuildContext context) {
return Scaffold(
body: Column(
children: [
_buildHeader(),
_buildStats(),
_buildTabBar(),
Expanded(
child: Container(
margin: EdgeInsets.all(20),
child: certificates.isEmpty
? _buildEmptyState()
    : ListView.builder(
itemCount: certificates.length,
itemBuilder: (context, index) {
final cert = certificates[index];
return Card(
child: ListTile(
title: Text(cert['title'] ?? 'Certificate'),
subtitle: Text("Status: ${cert['status']}"),
trailing: Icon(Icons.chevron_right),
onTap: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (_) => VerificationScreen(),
),
);
},
),
);
},
),
),
),
],
),
bottomNavigationBar: Container(
margin: const EdgeInsets.all(16),
decoration: BoxDecoration(
borderRadius: BorderRadius.circular(20),
boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(0.1),
blurRadius: 15,
offset: const Offset(0, 8),
),
],
),
child: ClipRRect(
borderRadius: BorderRadius.circular(20),
child: BottomNavigationBar(
currentIndex: _selectedBottomIndex,
onTap: (index) {
if (index == 3) {
Navigator.push(
context,
MaterialPageRoute(builder: (_) => ProfilePage()),
);
} else if (index == 1){
Navigator.push(
context,
MaterialPageRoute(builder: (_) => CertificateVerifier()),
);
} else if (index == 2){
Navigator.push(
context,
MaterialPageRoute(builder: (_) => CertificateFoldersList()),
);
} else {
setState(() {
_selectedBottomIndex = index;
});
}
},
type: BottomNavigationBarType.fixed,
backgroundColor: Colors.white,
selectedItemColor: const Color(0xFF4F46E5),
unselectedItemColor: const Color(0xFF94A3B8),
selectedLabelStyle: const TextStyle(
fontWeight: FontWeight.w700,
fontSize: 12,
),
unselectedLabelStyle: const TextStyle(
fontWeight: FontWeight.w500,
fontSize: 12,
),
items: [
BottomNavigationBarItem(
icon: _buildNavIcon(Icons.dashboard_outlined, Icons.dashboard, 0),
label: 'Dashboard',
),
BottomNavigationBarItem(
icon: _buildNavIcon(Icons.verified_outlined, Icons.verified, 1),
label: 'Certificates',
),
BottomNavigationBarItem(
icon: _buildNavIcon(Icons.folder_outlined, Icons.folder, 2),
label: 'Documents',
),
BottomNavigationBarItem(
icon: _buildNavIcon(Icons.person_outline, Icons.person, 3),
label: 'Profile',
),
],
),
),
),
);
}

Widget _buildNavIcon(IconData unselected, IconData selected, int index) {
bool isSelected = _selectedBottomIndex == index;
return AnimatedContainer(
duration: const Duration(milliseconds: 200),
padding: EdgeInsets.all(isSelected ? 6 : 4),
decoration: BoxDecoration(
color: isSelected ? const Color(0xFF4F46E5).withOpacity(0.1) : Colors.transparent,
borderRadius: BorderRadius.circular(8),
),
child: Icon(isSelected ? selected : unselected, size: 22),
);
}

Widget _buildHeader() {
return Container(
decoration: BoxDecoration(
gradient: LinearGradient(
colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
begin: Alignment.topLeft,
end: Alignment.bottomRight,
),
),
child: SafeArea(
bottom: false,
child: Padding(
padding: EdgeInsets.fromLTRB(20, 16, 20, 24),
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text('Certificates',
style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
SizedBox(height: 4),
Text(
'View and manage your received certificates',
style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.9)),
),
],
),
Icon(Icons.more_horiz, color: Colors.white, size: 28),
],
),
),
),
);
}

Widget _buildStats() {
return Container(
margin: EdgeInsets.all(20),
padding: EdgeInsets.all(24),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(20),
boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: Offset(0, 4))],
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(children: [
Icon(Icons.bar_chart_rounded, color: Color(0xFF2196F3)),
SizedBox(width: 8),
Text('Certificate Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
]),
SizedBox(height: 24),
Row(
children: [
Expanded(child: _buildStatCard(Icons.description, '${certificates.length}', 'Total')),
SizedBox(width: 12),
Expanded(child: _buildStatCard(Icons.check_circle_outline, '${countByStatus("issued")}', 'Issued')),
SizedBox(width: 12),
Expanded(child: _buildStatCard(Icons.schedule, '${countByStatus("pending")}', 'Pending')),
SizedBox(width: 12),
Expanded(child: _buildStatCard(Icons.error_outline, '${countByStatus("expired")}', 'Expired')),
],
),
],
),
);
}

Widget _buildTabBar() {
return Container(
margin: EdgeInsets.symmetric(horizontal: 20),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(16),
boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: Offset(0, 2))],
),
child: TabBar(
controller: tabController,
onTap: onTabChanged,
indicator: BoxDecoration(
borderRadius: BorderRadius.circular(12),
color: Color(0xFF2196F3),
),
indicatorPadding: EdgeInsets.all(4),
labelColor: Colors.white,
unselectedLabelColor: Color(0xFF8E8E93),
labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
tabs: [Tab(text: 'All'), Tab(text: 'Shared')],
),
);
}

Widget _buildEmptyState() {
return Center(
child: Column(
children: [
Container(
padding: EdgeInsets.all(8),
decoration: BoxDecoration(color: Color(0xFFE3F2FD), shape: BoxShape.circle),
child: Icon(Icons.folder_open_outlined, size: 80, color: Color(0xFF90CAF9)),
),
SizedBox(height: 24),
Text('No certificates found', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey)),
SizedBox(height: 8),
Text('Certificates will appear here once issued',
style: TextStyle(fontSize: 16, color: Color(0xFFBDBDBD))),
],
),
);
}

Widget _buildStatCard(IconData icon, String count, String label) {
final Color color = Color(0xFF2196F3);
return Container(
padding: EdgeInsets.all(16),
decoration: BoxDecoration(
color: color.withOpacity(0.1),
borderRadius: BorderRadius.circular(16),
),
child: Column(
children: [
Icon(icon, color: color, size: 20),
SizedBox(height: 12),
Text(count, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
SizedBox(height: 4),
Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF8E8E93))),
],
),
);
}

@override
void dispose() {
tabController.dispose();
super.dispose();
}
}
