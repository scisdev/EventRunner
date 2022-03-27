import 'package:event_runner/main.dart';
import 'package:event_runner/ui/widgets/buttons.dart';
import 'package:event_runner/util/theme.dart';
import 'package:flutter/material.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Image.asset(
              ThemeDrawable.onBoard,
              fit: BoxFit.fitWidth,
              gaplessPlayback: true,
            ),
            const SizedBox(height: 38),
            const Text(
              'Начни создавать',
              style: ThemeFonts.h1,
            ),
            const SizedBox(height: 16),
            const Text(
              'Ищи и создавай\nмероприятия вместе с нами!',
              style: ThemeFonts.p1,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: AccentButton(
                content: const Text('Начать'),
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    NavigatorPage(
                      builder: (ctx) {
                        return const InitialScreen();
                      },
                    ),
                  );
                },
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
