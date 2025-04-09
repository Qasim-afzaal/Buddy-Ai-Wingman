import 'package:flutter/material.dart';
import 'package:buddy_ai_wingman/core/constants/imports.dart';
// import 'package:sparkd/widgets/name_widget.dart';
import 'package:buddy_ai_wingman/core/constants/imports.dart';
import 'package:buddy_ai_wingman/pages/new_chat/gather_new_chat/gather_new_chat_info_controller.dart';
import 'package:buddy_ai_wingman/routes/app_pages.dart';

class NewGatherChatPage extends StatefulWidget {
  // Change class name here
  NewGatherChatPage({super.key}); // Change constructor name here

  @override
  _NewGatherChatPageState createState() =>
      _NewGatherChatPageState(); // Change state class name here
}

class _NewGatherChatPageState extends State<NewGatherChatPage> {
  // Change state class name here
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
            children: [SB.h(25), NameWidget2()],
          ),
        ),
      ),
    );
  }
}

class NameWidget2 extends StatelessWidget {
  // You can initialize the controller here or use a service to retrieve it
  // final GatherNewChatInfoController controller = GatherNewChatInfoController();

  NameWidget2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.allSet,
          style: context.headlineMedium?.copyWith(
            color: context.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SB.h(10),
        Text(
          AppStrings.allSetDescription,
          textAlign: TextAlign.center,
          style: context.bodyLarge
              ?.copyWith(fontWeight: FontWeight.w400, height: 1),
        ),
        SB.h(40),
        CustomTextField(
          // controller: controller.nameController,
          title: AppStrings.name,
        ),
        SB.h(25),
        AppButton.primary(
          title: AppStrings.getMySparkd,
          onPressed: () {
            Get.toNamed(Routes.NEW2);
          },
        )
      ],
    ).paddingAll(context.paddingDefault);
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
