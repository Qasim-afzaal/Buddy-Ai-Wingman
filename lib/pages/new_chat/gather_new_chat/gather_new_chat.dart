import 'package:flutter/material.dart';
import 'package:buddy_ai_wingman/core/constants/imports.dart';
import 'package:buddy_ai_wingman/widgets/age_widget.dart';
import 'package:buddy_ai_wingman/widgets/gender_widget.dart';
import 'package:buddy_ai_wingman/widgets/name_widget.dart';
import 'package:buddy_ai_wingman/widgets/objective_widget.dart';
import 'package:buddy_ai_wingman/widgets/personality_widget.dart';

class GatherNewChatInfoPage extends StatefulWidget {
  const GatherNewChatInfoPage({super.key});

  @override
  _GatherNewChatInfoPageState createState() => _GatherNewChatInfoPageState();
}

class _GatherNewChatInfoPageState extends State<GatherNewChatInfoPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 4) {
      setState(() {
        _currentPage++;
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
        _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  Future<bool> _onWillPop() async {
    if (_currentPage == 0) {
      return true;
    } else {
      _previousPage();
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: SimpleAppBar(
          title: "Create Chat",
          onPressed: () {
            if (_currentPage == 0) {
              Navigator.pop(context);
            } else {
              _previousPage();
            }
          },
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SB.h(25),
            NameWidget()
            ],
          ),
        ),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({super.key, this.isCurrentPage = false});

  final bool isCurrentPage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5),
      height: 6,
      width: isCurrentPage ? 18 : 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isCurrentPage ? null : context.primary.withOpacity(0.25),
        gradient: isCurrentPage
            ? LinearGradient(colors: [
                context.primary,
                context.secondary,
              ])
            : null,
      ),
    );
  }
}
