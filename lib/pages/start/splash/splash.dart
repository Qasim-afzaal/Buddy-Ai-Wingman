import 'package:buddy_ai_wingman/core/constants/imports.dart';
import 'splash_controller.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SplashController(),
      builder: (controller) {
        return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Image.asset(
                'assets/images/Logi.png', height: 300, width: 300,
                fit: BoxFit
                    .contain, // Ensures the image is contained within its bounds
              ),
            ));
      },
    );
  }
}
