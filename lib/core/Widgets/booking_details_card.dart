
import 'package:flutter/material.dart';
import 'package:buddy_ai_wingman/core/Utils/custom_text_styles.dart';
import 'package:buddy_ai_wingman/core/constants/app_colors.dart';
import '../Utils/assets_util.dart';


class BookingDetailsCard extends StatelessWidget {
  final String bookingNumber;
  final String carName;
  final String startDate;
  final String endDate;
  final String renter;
  const BookingDetailsCard({super.key, required this.bookingNumber, required this.carName, required this.startDate, required this.endDate, required this.renter});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
          color: AppColors.whiteColor,
          border:const Border(
              bottom: BorderSide(
            color: AppColors.fieldBackgroundColor,
            width: 2,
          ),
            left: BorderSide(
              color: AppColors.fieldBackgroundColor,
              width: 2,
            ),
            right: BorderSide(
              color: AppColors.fieldBackgroundColor,
              width: 2,
            ),
            top: BorderSide(
              color: AppColors.fieldBackgroundColor,
              width: 6,
            ),
          ),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  bookingNumber,
                  style: headingTextStyle(),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  carName,
                  style: headingTextStyle(),
                ),
              ],
            ),

            const SizedBox(height: 10,),

            Column(
              children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(startDate, style: bodyTextStyle(size: 10, color: AppColors.grayColor),),
                  Text(endDate, style: bodyTextStyle(size: 10, color: AppColors.grayColor),),
                ],
              ),
                Slider.adaptive(
                  activeColor: AppColors.blackColor,
                  inactiveColor: AppColors.fieldBackgroundColor,
                  allowedInteraction: SliderInteraction.slideOnly,
                    min: 1,
                    max: 3,
                    value: 2, onChanged: (newValue){}
                )
              ],
            ),


            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipOval(
                  child: Image.asset(
                    CustomImages.placeholderAvatar,
                    width: 26,
                    height: 26,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  renter,
                  style: headingTextStyle(size: 12),
                ),
                const Spacer(),
                SizedBox(
                  height: 26,
                  width: 26,
                  child: IconButton.filledTonal(
                      onPressed: () {},
                      style: IconButton.styleFrom(backgroundColor: AppColors.blackColor),
                      icon: const Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: AppColors.whiteColor,
                        size: 12,
                      )),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

