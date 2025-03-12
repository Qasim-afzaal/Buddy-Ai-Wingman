import 'package:buddy_ai_wingman/core/components/sb.dart';
import 'package:buddy_ai_wingman/core/constants/app_colors.dart';
import 'package:buddy_ai_wingman/core/constants/imports.dart';
import 'package:buddy_ai_wingman/core/extensions/build_context_extension.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.title,
    this.controller,
    this.isPasswordField = false,
    this.readOnly = false,
    this.enabled = true,
    this.keyboardType,
    this.hintTextColor,
    this.textColor,
    this.suffixIcon,
    this.onSuffixTap,
    this.textAlign,
    this.textFieldBorder,
    this.onChange,
    this.textCapitalization = TextCapitalization.words,
    this.fillColor,
    this.showShadow = true,
    this.showBorder = false,
    this.maxLines = 1,
    this.minLines,
    this.prefixIcon,
    this.onTap,
    this.isRequiredField = false,
    this.hintText,
    this.textInputAction,
    this.maxLength,
  });

  final String? title, hintText;
  final TextEditingController? controller;
  final bool isPasswordField;
  final bool readOnly;
  final bool enabled;
  final TextInputType? keyboardType;
  final Color? textColor, fillColor;
  final Color? hintTextColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onSuffixTap, onTap;
  final TextAlign? textAlign;
  final InputBorder? textFieldBorder;
  final Function(String value)? onChange;
  final TextCapitalization? textCapitalization;
  final bool showShadow, showBorder;
  final int maxLines;
  final int? minLines;
  final bool isRequiredField;
  final TextInputAction? textInputAction;
  final int? maxLength;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title ?? '',
                  style: context.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: context.primary,
                  ),
                ),
                if (widget.isRequiredField)
                  const Padding(
                    padding: EdgeInsets.only(left: 3),
                    child: Icon(
                      Icons.star,
                      color: Colors.red,
                      size: 9,
                    ),
                  ),
              ],
            ),
          ),
        TextFormField(
          onTap: widget.onTap,
          // style: context.bodyLarge?.copyWith(
          //   color: context.primary,
          // ),
          style: GoogleFonts.interTight(
              textStyle: const TextStyle(
            color: AppColors.blackColor,
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.w500,
          )),
          maxLength: widget.maxLength,
          obscuringCharacter: '*',
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          controller: widget.controller,
          onChanged: widget.onChange,
          textInputAction: widget.textInputAction ?? TextInputAction.next,
          textCapitalization:
              widget.textCapitalization ?? TextCapitalization.none,
          textAlign: widget.textAlign ?? TextAlign.start,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          obscureText:
              widget.isPasswordField ? _hidePassword : widget.isPasswordField,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.isPasswordField
                ? _hidePasswordIcon()
                : widget.suffixIcon,
            hintText: widget.hintText,
            fillColor: widget.fillColor ?? Colors.grey[100],
            filled: true,
            counterText: "",
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            errorBorder: _border(context.error),
            focusedErrorBorder: _border(context.primary),
            enabledBorder: _border(AppColors.textFieldBorderColor),
            disabledBorder: _border(context.grey),
            focusedBorder: _border(context.primary),
            border: _border(context.primary),
          ),
        ),
        SB.h(15),
      ],
    );
  }

  void _toggleHidePassword() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }

  Widget _hidePasswordIcon() {
    return IconButton(
      onPressed: _toggleHidePassword,
      icon: Icon(
        _hidePassword ? Icons.visibility_off : Icons.visibility,
        color: Colors.grey,
      ),
    );
  }
}

InputBorder _border(Color borderColor) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: borderColor),
  );
}
