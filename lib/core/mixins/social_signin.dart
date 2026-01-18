import 'dart:io';

import 'package:buddy/core/constants/imports.dart';

/// Mixin for social sign-in functionality
mixin SocialSignIn {
  Widget socialButton(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppButton.borderIcon(
            // onTap: () => loginWithGoogle(),
            icon: Assets.icons.google.svg(),
          ),
          if (Platform.isIOS) ...[
            SB.w(15),
            AppButton.borderIcon(
              // onPressed: _signInWithApple,
              icon: Assets.icons.apple.svg(),
            ),
          ]
        ],
      );
}

