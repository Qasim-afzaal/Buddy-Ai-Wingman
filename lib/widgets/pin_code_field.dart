import 'package:flutter/material.dart';

import 'package:pin_code_fields/pin_code_fields.dart';

class PinCodeInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onCompleted;
  final Function(String) onChanged;
  final bool isotpvarified;
  final bool isFieldValueComplete;
  final bool isotpcorrect;

  const PinCodeInputWidget({
    Key? key,
    required this.controller,
    required this.onCompleted,
    required this.onChanged,
    required this.isotpvarified,
    required this.isFieldValueComplete,
    required this.isotpcorrect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 15, 32, 10),
      child: PinCodeTextField(
        controller: controller,
        appContext: context,
        pastedTextStyle: TextStyle(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
        length: 4,
        obscureText: false,
        textStyle: TextStyle(color: theme.colorScheme.shadow),
        animationType: AnimationType.fade,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderWidth: 1,
          disabledColor: theme.colorScheme.outline,
          inactiveColor: theme.colorScheme.outline,
          activeColor: isotpcorrect ? theme.colorScheme.scrim : Colors.red,
          fieldHeight: 50,
          fieldWidth: 45,
          activeFillColor: theme.colorScheme.primary,
        ),
        cursorColor: theme.colorScheme.shadow,
        animationDuration: const Duration(milliseconds: 300),
        keyboardType: TextInputType.number,
        onCompleted: onCompleted,
        onChanged: onChanged,
        beforeTextPaste: (text) {
          return true;
        },
      ),
    );
  }
}
