import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Certificate Repository',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Display', // iOS-like font
        scaffoldBackgroundColor: Color(0xFFF0F4F8),
      ),
      home: CertificatesPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CertificatesPage extends StatefulWidget {
  @override
  _CertificatesPageState createState() => _CertificatesPageState();
}

class _CertificatesPageState extends State<CertificatesPage>
    with SingleTickerProviderStateMixin {
  int _selectedTabIndex = 0;
  int _selectedBottomIndex = 1; // Certificates tab selected
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F4F8),
      body: Column(
        children: [
          // Custom App Bar with blue gradient
          Container(
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
                        Text(
                          'Certificates',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'View and manage your received certificates',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.more_horiz,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Statistics Card
          Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFF2196F3).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.bar_chart_rounded,
                        color: Color(0xFF2196F3),
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Certificate Statistics',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E3A47),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.description_outlined,
                        count: '0',
                        label: 'Total',
                        color: Color(0xFF64B5F6),
                        backgroundColor: Color(0xFF64B5F6).withOpacity(0.1),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.check_circle_outline,
                        count: '0',
                        label: 'Issued',
                        color: Color(0xFF2196F3),
                        backgroundColor: Color(0xFF2196F3).withOpacity(0.1),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.schedule_outlined,
                        count: '0',
                        label: 'Pending',
                        color: Color(0xFF0288D1),
                        backgroundColor: Color(0xFF0288D1).withOpacity(0.1),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.error_outline,
                        count: '0',
                        label: 'Expired',
                        color: Color(0xFF1976D2),
                        backgroundColor: Color(0xFF1976D2).withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Tab Bar
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              onTap: (index) {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Color(0xFF2196F3),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: EdgeInsets.all(4),
              labelColor: Colors.white,
              unselectedLabelColor: Color(0xFF8E8E93),
              labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              tabs: [
                Tab(text: 'All'),
                Tab(text: 'Mine'),
                Tab(text: 'Shared'),
              ],
            ),
          ),

          // Content Area
          Expanded(
            child: Container(
              margin: EdgeInsets.all(20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Color(0xFFE3F2FD),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.folder_open_outlined,
                        size: 80,
                        color: Color(0xFF90CAF9),
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'No certificates found',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF8E8E93),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Certificates will appear here once issued',
                      style: TextStyle(fontSize: 16, color: Color(0xFFBDBDBD)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // Enhanced Bottom Navigation Bar
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            color: Colors.white,
            child: BottomNavigationBar(
              currentIndex: _selectedBottomIndex,
              onTap: (index) {
                setState(() {
                  _selectedBottomIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: Color(0xFF4F46E5), // Color for selected items
              unselectedItemColor: Color(
                0xFF94A3B8,
              ), // Color for unselected items
              selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              items: [
                BottomNavigationBarItem(
                  icon: _buildNavIcon(
                    Icons.dashboard_outlined,
                    Icons.dashboard,
                    0,
                  ),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavIcon(
                    Icons.verified_outlined,
                    Icons.verified,
                    1,
                  ),
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
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String count,
    required String label,
    required Color color,
    required Color backgroundColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.1), width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(height: 12),
          Text(
            count,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8E8E93),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavIcon(IconData unselected, IconData selected, int index) {
    bool isSelected = _selectedBottomIndex == index;
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      padding: EdgeInsets.all(isSelected ? 6 : 4),
      decoration: BoxDecoration(
        color: isSelected
            ? Color(0xFF4F46E5).withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(isSelected ? selected : unselected, size: 22),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
