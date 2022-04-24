import 'package:event_runner/ui/widgets/widgets.dart';
import 'package:event_runner/util/theme.dart';
import 'package:flutter/material.dart';

import 'view.dart';

class PageThree extends StatefulWidget {
  const PageThree({Key? key}) : super(key: key);

  @override
  _PageThreeState createState() => _PageThreeState();
}

class _PageThreeState extends State<PageThree> {
  List<TextEditingController> controllers = <TextEditingController>[];

  @override
  void initState() {
    for (final s in CreateEventLayout.of(context).steps) {
      controllers.add(TextEditingController(text: s));
    }

    super.initState();
  }

  @override
  void dispose() {
    for (final tec in controllers) {
      tec.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Text(
            'Шаги',
            style: ThemeFonts.h2,
          ),
          const SizedBox(height: 12),
          steps(),
          const SizedBox(height: 24),
          AddStepButton(
            onTap: () {
              setState(() {
                CreateEventLayout.of(context).steps.add('');
                controllers.add(TextEditingController());
              });
            },
          ),
          const SizedBox(height: 48),
          AccentButton(
            content: const Text('Далее'),
            onTap: () {
              final cel = CreateEventLayout.of(context);

              for (final step in cel.steps) {
                if (step.isEmpty) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                      'Все шаги мероприятия должны иметь какое-нибудь название!',
                    ),
                  ));
                  return;
                }
              }

              CreateEventLayout.of(context).nextPage();
            },
          ),
          const SizedBox(height: 150),
        ],
      ),
    );
  }

  Widget steps() {
    final res = <Widget>[];

    for (var i = 0; i < controllers.length; i++) {
      res.add(
        StepEntry(
          position: i,
          controller: controllers[i],
          onDeleteTap: () {
            setState(() {
              CreateEventLayout.of(context).steps.removeAt(i);
              controllers.removeAt(i);
            });
          },
        ),
      );
    }

    return Column(
      children: res,
    );
  }
}

class StepEntry extends StatelessWidget {
  final int position;
  final VoidCallback onDeleteTap;
  final TextEditingController controller;

  const StepEntry({
    Key? key,
    required this.position,
    required this.onDeleteTap,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      height: 56,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onDeleteTap,
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.only(right: 8),
              height: double.infinity,
              child: const Icon(
                Icons.close,
                color: ThemeColors.secondaryText,
              ),
            ),
          ),
          Expanded(
            child: InputField(
              hintText: 'Опишите шаг',
              controller: controller,
              onChanged: (s) {
                CreateEventLayout.of(context).steps[position] = s;
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AddStepButton extends StatelessWidget {
  final VoidCallback onTap;
  const AddStepButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AccentButton(
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.add,
            color: ThemeColors.accentText,
          ),
          Text(
            'Шаг',
            style: ThemeFonts.p2.copyWith(
              color: ThemeColors.accentText,
            ),
          ),
        ],
      ),
      color: ThemeColors.background,
      borderColor: ThemeColors.outline,
      onTap: onTap,
    );
  }
}
