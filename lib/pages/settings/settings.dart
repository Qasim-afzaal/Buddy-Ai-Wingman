import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:buddy/core/constants/imports.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(
        title: AppStrings.settings,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SB.h(20),
            _Tile(
              iconPath: Assets.icons.terms.path,
              title: AppStrings.termsConditions,
              onTap: () async {
                const url =
                    'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.iconPath, required this.title, this.onTap});
  final String iconPath, title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Image.asset(
                iconPath,
                width: 28,
                height: 28,
                color: Colors.black,
              ),
              SB.w(10),
              Expanded(
                child: Text(title,
                    style: GoogleFonts.interTight(
                        textStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ))),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: context.primary,
                size: 18,
              )
            ],
          ).paddingAll(15),
        ),
        Divider(
          color: context.primary,
        ),
      ],
    );
  }
}
