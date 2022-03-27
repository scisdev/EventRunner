import 'package:event_runner/util/theme.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String? hintText;
  final Widget? prefix;
  final Widget? postfix;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final bool obscureText;

  const InputField({
    Key? key,
    this.hintText,
    this.prefix,
    this.postfix,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: TextField(
        controller: controller,
        decoration: getDecoration(),
        obscureText: obscureText,
        style: ThemeFonts.p2.copyWith(
          color: ThemeColors.mainText,
          leadingDistribution: TextLeadingDistribution.even,
        ),
      ),
    );
  }

  InputDecoration getDecoration() {
    return InputDecoration(
      errorStyle: const TextStyle(
        fontSize: 0,
      ),
      contentPadding: postfix == null
          ? const EdgeInsets.symmetric(
              horizontal: 21,
            )
          : const EdgeInsets.only(right: 21),
      hintText: hintText,
      suffixIcon: postfix,
      prefixIcon: prefix,
      hintStyle: ThemeFonts.p2.copyWith(
        color: ThemeColors.secondaryText,
        leadingDistribution: TextLeadingDistribution.even,
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(32),
        ),
        borderSide: BorderSide(
          width: 1,
          color: ThemeColors.outline,
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(32),
        ),
        borderSide: BorderSide(
          width: 1,
          color: ThemeColors.outline,
        ),
      ),
      disabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(32),
        ),
        borderSide: BorderSide(
          width: 1,
          color: ThemeColors.outline,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(32),
        ),
        borderSide: BorderSide(
          width: 1,
          color: ThemeColors.outline,
        ),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(32),
        ),
        borderSide: BorderSide(
          width: 1,
          color: ThemeColors.primaryRed,
        ),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(32),
        ),
        borderSide: BorderSide(
          width: 1,
          color: ThemeColors.primaryRed,
        ),
      ),
    );
  }
}
