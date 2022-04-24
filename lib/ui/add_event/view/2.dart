import 'package:event_runner/model/model.dart';
import 'package:event_runner/ui/widgets/widgets.dart';
import 'package:event_runner/util/theme.dart';
import 'package:flutter/material.dart';

import 'view.dart';

class PageTwo extends StatefulWidget {
  const PageTwo({Key? key}) : super(key: key);

  @override
  _PageTwoState createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
  final validationKey = GlobalKey<FormState>();
  late final TextEditingController typeController;

  QrUsage _usage = QrUsage.everyStep;

  @override
  void initState() {
    final cel = CreateEventLayout.of(context);
    _usage = cel.qrUsage;
    typeController = TextEditingController(text: cel.eventType);
    super.initState();
  }

  @override
  void dispose() {
    typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: validationKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Тип мероприятия',
              style: ThemeFonts.h2,
            ),
            const SizedBox(height: 10),
            InputField(
              hintText: 'Введите тип мероприятия',
              validator: (s) {
                if (s == null) return '';
                return s.isEmpty ? '' : null;
              },
              onChanged: (s) {
                CreateEventLayout.of(context).eventType = s;
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Способ использования QR-кода',
              style: ThemeFonts.h2,
            ),
            const SizedBox(height: 10),
            ChoiceButton(
              text: 'Для каждого шага',
              onTap: () {
                setState(() {
                  _usage = QrUsage.everyStep;
                  CreateEventLayout.of(context).qrUsage = _usage;
                });
              },
              selected: _usage == QrUsage.everyStep,
            ),
            const SizedBox(height: 10),
            ChoiceButton(
              text: 'При входе на мероприятие',
              onTap: () {
                setState(() {
                  _usage = QrUsage.onlyIn;
                  CreateEventLayout.of(context).qrUsage = _usage;
                });
              },
              selected: _usage == QrUsage.onlyIn,
            ),
            const SizedBox(height: 10),
            ChoiceButton(
              text: 'При входе и выходе с мероприятия',
              onTap: () {
                setState(() {
                  _usage = QrUsage.inAndOut;
                  CreateEventLayout.of(context).qrUsage = _usage;
                });
              },
              selected: _usage == QrUsage.inAndOut,
            ),
            const SizedBox(height: 10),
            ChoiceButton(
              text: 'Только для достижений',
              onTap: () {
                setState(() {
                  _usage = QrUsage.achievements;
                  CreateEventLayout.of(context).qrUsage = _usage;
                });
              },
              selected: _usage == QrUsage.achievements,
            ),
            const SizedBox(height: 10),
            ChoiceButton(
              text: 'Без QR-кодов',
              onTap: () {
                setState(() {
                  _usage = QrUsage.noQr;
                  CreateEventLayout.of(context).qrUsage = _usage;
                });
              },
              selected: _usage == QrUsage.noQr,
            ),
            const SizedBox(height: 48),
            AccentButton(
              content: const Text('Далее'),
              onTap: () {
                final valid = validationKey.currentState?.validate() ?? false;
                if (!valid) return;
                CreateEventLayout.of(context).nextPage();
              },
            ),
            const SizedBox(height: 150),
          ],
        ),
      ),
    );
  }
}

class ChoiceButton extends StatelessWidget {
  final bool selected;
  final String text;
  final VoidCallback onTap;

  const ChoiceButton({
    Key? key,
    required this.selected,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 450),
          child: GestureDetector(
            key: ValueKey(selected),
            onTap: onTap,
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(32),
                ),
                color: selected ? ThemeColors.primary : ThemeColors.background,
                border: Border.all(
                  color: selected ? ThemeColors.primary : ThemeColors.outline,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  text,
                  style: selected
                      ? ThemeFonts.h3.copyWith(color: Colors.white)
                      : ThemeFonts.h3
                          .copyWith(color: ThemeColors.secondaryText),
                ),
              ),
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
