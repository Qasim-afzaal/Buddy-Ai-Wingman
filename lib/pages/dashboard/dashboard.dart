import 'package:buddy_ai_wingman/pages/sparkd_lines/sparkd_lines.dart';
import 'package:buddy_ai_wingman/pages/start_sparkd/start_sparkd.dart';
import 'package:flutter/material.dart';
import 'package:buddy_ai_wingman/core/constants/imports.dart';
import 'package:buddy_ai_wingman/pages/home/home.dart';
import 'package:buddy_ai_wingman/pages/inbox/inbox.dart';

import 'package:buddy_ai_wingman/widgets/custom_navbar.dart';
import 'package:buddy_ai_wingman/widgets/lazy_stackindex.dart';

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
          Startbuddy_ai_wingmanPage(),
          buddy_ai_wingmanLinesPage(),
         
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: currentTab,
        onTabTapped: changeNavIndex,
      ),
    );
  }
}
