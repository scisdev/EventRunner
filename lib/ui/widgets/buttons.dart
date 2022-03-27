import 'package:flutter/material.dart';

import '../../util/theme.dart';

class AccentButton extends StatelessWidget {
  final Widget content;
  final Color? color;
  final Color? borderColor;
  final VoidCallback? onTap;

  const AccentButton({
    Key? key,
    required this.content,
    this.color,
    this.borderColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color ?? ThemeColors.primary,
          borderRadius: const BorderRadius.all(
            Radius.circular(32),
          ),
          border: getBorder(),
        ),
        height: 56,
        width: double.infinity,
        child: Center(
          child: DefaultTextStyle(
            style: ThemeFonts.h3,
            child: content,
          ),
        ),
      ),
    );
  }

  Border? getBorder() {
    final borderColor = this.borderColor;
    if (borderColor == null) {
      return null;
    }

    return Border.all(
      color: borderColor,
      width: 1,
    );
  }
}
