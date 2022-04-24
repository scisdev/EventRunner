import 'package:event_runner/ui/widgets/buttons.dart';
import 'package:event_runner/util/theme.dart';
import 'package:flutter/material.dart';

class EventAddedDialog extends StatelessWidget {
  const EventAddedDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          ThemeDrawable.happyFace,
          width: 160,
        ),
        const SizedBox(height: 16),
        const Text(
          'Событие создано',
          style: ThemeFonts.h1,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        const Text(
          'Теперь вы можете сгенерировать '
          'все необходимые QR-коды '
          'или продолжить позже в профиле',
          style: ThemeFonts.p2,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: AccentButton(
            content: const Text('Сгенерировать'),
            onTap: () {
              Navigator.pop(context, true);
            },
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: AccentButton(
            content: const Text('На главную'),
            onTap: () {
              Navigator.pop(context, false);
            },
          ),
        ),
      ],
    );
  }
}
