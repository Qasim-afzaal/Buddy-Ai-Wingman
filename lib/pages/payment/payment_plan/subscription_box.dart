import 'package:google_fonts/google_fonts.dart';
import 'package:buddy_ai_wingman/core/constants/app_colors.dart';
import 'package:buddy_ai_wingman/core/constants/imports.dart';

class SubscriptionBox extends StatelessWidget {
  final String plan;
  final String price;
  final String description;
  final bool isSelected;
  final VoidCallback onSelect;

  const SubscriptionBox({
    required this.plan,
    required this.price,
    required this.description,
    required this.isSelected,
    required this.onSelect,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        height: 130,
        width: MediaQuery.of(context).size.width / 2 - 20,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : AppColors.textFieldBorderColor,
          border: Border.all(color: isSelected ? Colors.black : Colors.grey),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              price,
              style: GoogleFonts.interTight(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: GoogleFonts.interTight(
                textStyle: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white70 : Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
