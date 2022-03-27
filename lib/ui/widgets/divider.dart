import 'package:event_runner/util/theme.dart';
import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 8,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: ThemeColors.form,
        ),
      ),
    );
  }
}
