import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:buddy/core/Widgets/detail_page_tracking_circle.dart';

/// Detail page tracking list widget

class DetailPageTrackingList extends StatelessWidget {
  final int pageNumber;
  const DetailPageTrackingList({super.key, required this.pageNumber});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DetailPageTrackingCircle(
            isActive: pageNumber == 1 ? true : false,
            isCompleted: pageNumber > 1 ? true : false,
            circleText: "1",
            label: "Company\nDetails"),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Divider(
            color: pageNumber > 1 ? Colors.black : null,
          ),
        )),
        DetailPageTrackingCircle(
            isActive: pageNumber == 2 ? true : false,
            isCompleted: pageNumber > 2 ? true : false,
            circleText: "2",
            label: "Banking &\nPayments"),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Divider(
            color: pageNumber > 2 ? Colors.black : null,
          ),
        )),
        DetailPageTrackingCircle(
            isActive: pageNumber == 3 ? true : false,
            isCompleted: pageNumber == 3 ? false : false,
            circleText: "3",
            label: "Know Your\nCompany"),
      ],
    );
  }
}
