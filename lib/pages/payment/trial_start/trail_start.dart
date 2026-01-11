import 'package:buddy/core/constants/imports.dart';
import 'package:buddy/pages/home/home.dart';
import 'package:google_fonts/google_fonts.dart';

import 'trail_start_controller.dart';

class TrailStart extends StatelessWidget {
  const TrailStart({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: TrailStartController(),
      builder: (controller) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Theme.of(context).primaryColor.withOpacity(0.05),
                  Theme.of(context).primaryColor.withOpacity(0.1),
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Decorative badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Theme.of(context).primaryColor.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.celebration,
                            size: 18,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Gratis Trial",
                            style: GoogleFonts.interTight(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SB.h(40),
                    // Icon with background
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.rocket_launch_rounded,
                        size: 80,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SB.h(32),
                    // Main heading
                    Text(
                      "Probeer Buddy\n7 dagen gratis.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.interTight(
                        fontWeight: FontWeight.w800,
                        fontSize: 32,
                        height: 1.2,
                        color: Colors.grey.shade900,
                      ),
                    ),
                    SB.h(24),
                    // Feature highlights
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildFeatureItem(
                            context,
                            Icons.check_circle,
                            "Onbeperkte toegang",
                            Colors.green,
                          ),
                          const SizedBox(height: 12),
                          _buildFeatureItem(
                            context,
                            Icons.check_circle,
                            "Alle premium functies",
                            Colors.green,
                          ),
                          const SizedBox(height: 12),
                          _buildFeatureItem(
                            context,
                            Icons.check_circle,
                            "Geen creditcard vereist",
                            Colors.green,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // CTA Button
                    AppButton.primary(
                      title: AppStrings.letsGo,
                      onPressed: () => Get.offAll(() => HomePage()),
                      height: 56,
                    ),
                    SB.h(16),
                    // Small disclaimer
                    Text(
                      "Start je gratis trial en ontdek alle mogelijkheden",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.interTight(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeatureItem(
    BuildContext context,
    IconData icon,
    String text,
    Color color,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: color,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.interTight(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade800,
            ),
          ),
        ),
      ],
    );
  }
}
