import 'package:flutter/material.dart';

import 'package:buddy/core/constants/imports.dart';
import 'package:buddy/pages/home/home.dart';
import 'package:buddy/pages/inbox/inbox.dart';
import 'package:buddy/pages/sparkd_lines/sparkd_lines.dart';
import 'package:buddy/pages/start_sparkd/start_sparkd.dart';
import 'package:buddy/widgets/custom_navbar.dart';
import 'package:buddy/widgets/lazy_stackindex.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int currentTab = 0;

  void changeNavIndex(int index) {
    setState(() {
      currentTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LazyIndexedStack(
        index: currentTab,
        children: [
          HomePage(),
          InboxPage(),
          StartSparkdPage(),
          SparkdLinesPage(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: currentTab,
        onTabTapped: changeNavIndex,
      ),
    );
  }
}
