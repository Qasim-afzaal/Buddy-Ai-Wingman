import 'package:flutter/material.dart';

import 'package:buddy/core/constants/imports.dart';
import 'package:buddy/pages/home/home.dart';
import 'package:buddy/pages/inbox/inbox.dart';
import 'package:buddy/pages/sparkd_lines/sparkd_lines.dart';
import 'package:buddy/pages/start_sparkd/start_sparkd.dart';
import 'package:buddy/widgets/custom_navbar.dart';
import 'package:buddy/widgets/lazy_stackindex.dart';

/// Main dashboard page that contains the bottom navigation bar and manages
/// navigation between different app sections: Home, Inbox, Start Sparkd, and Sparkd Lines.
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentTabIndex = 0;

  void _onTabChanged(int index) {
    setState(() {
      _currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LazyIndexedStack(
        index: _currentTabIndex,
        children: const [
          HomePage(),
          InboxPage(),
          StartSparkdPage(),
          SparkdLinesPage(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _currentTabIndex,
        onTabTapped: _onTabChanged,
      ),
    );
  }
}
