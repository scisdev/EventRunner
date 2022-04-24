import 'package:event_runner/ui/add_event/add_event.dart';
import 'package:event_runner/ui/widgets/widgets.dart';
import 'package:event_runner/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PageOne extends StatefulWidget {
  const PageOne({Key? key}) : super(key: key);

  @override
  State<PageOne> createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  final validationKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController descController;

  double sliderValue = 3;

  @override
  void initState() {
    final cel = CreateEventLayout.of(context);
    nameController = TextEditingController(text: cel.name);
    descController = TextEditingController(text: cel.description);
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: validationKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 180,
                    child: SvgPicture.asset(
                      ThemeDrawable.addPhoto,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Название мероприятия',
                    style: ThemeFonts.h2.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  InputField(
                    validator: (s) {
                      if (s == null) return '';
                      return s.isEmpty ? '' : null;
                    },
                    hintText: 'Введите название мероприятия',
                    onChanged: (s) {
                      CreateEventLayout.of(context).name = s;
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Описание',
                    style: ThemeFonts.h2,
                  ),
                  const SizedBox(height: 10),
                  const EventDescriptionInputField(),
                  const SizedBox(height: 24),
                  const Text(
                    'Время проведения (в минутах)',
                    style: ThemeFonts.h2,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        '<10',
                        style: ThemeFonts.h3.copyWith(
                          color: ThemeColors.primary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '30',
                        style: ThemeFonts.h3.copyWith(
                          color: ThemeColors.primary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '>60',
                        style: ThemeFonts.h3.copyWith(
                          color: ThemeColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Slider(
            value: sliderValue,
            onChanged: (s) {
              setState(() {
                CreateEventLayout.of(context).eventDuration =
                    eventDurationFromIntValue(s.toInt());
                sliderValue = s;
              });
            },
            min: 0,
            max: 6,
            divisions: 6,
            activeColor: ThemeColors.primary,
          ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: AccentButton(
              content: const Text('Далее'),
              onTap: () {
                final v = validationKey.currentState?.validate() ?? false;
                if (!v) return;

                CreateEventLayout.of(context).nextPage();
              },
            ),
          ),
          const SizedBox(height: 150),
        ],
      ),
    );
  }

  String eventDurationFromIntValue(int value) {
    if (value == 0) {
      return '< 10 минут';
    } else if (value == 1) {
      return '~ 15 минут';
    } else if (value == 2) {
      return '~ 25 минут';
    } else if (value == 3) {
      return '~ 30 минут';
    } else if (value == 4) {
      return '~ 45 минут';
    } else if (value == 5) {
      return '~ 60 минут';
    } else if (value == 6) {
      return '> 60 минут';
    }

    throw UnimplementedError();
  }
}

class EventDescriptionInputField extends StatelessWidget {
  const EventDescriptionInputField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (s) {
        CreateEventLayout.of(context).description = s;
      },
      validator: (s) {
        if (s == null) return '';
        return s.isEmpty ? '' : null;
      },
      decoration: getDecoration(),
      style: ThemeFonts.s.copyWith(
        color: ThemeColors.mainText,
      ),
      textCapitalization: TextCapitalization.sentences,
      minLines: 4,
      maxLines: 8,
    );
  }

  InputDecoration getDecoration() {
    return InputDecoration(
      hintText: 'Расскажите подробнее о мероприятии, '
          'времени и месте проведения',
      errorStyle: const TextStyle(
        fontSize: 0,
        height: 0,
      ),
      hintStyle: ThemeFonts.s.copyWith(
        color: ThemeColors.secondaryText,
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        borderSide: BorderSide(
          width: 1,
          color: ThemeColors.outline,
        ),
      ),
      alignLabelWithHint: true,
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        borderSide: BorderSide(
          width: 1,
          color: ThemeColors.outline,
        ),
      ),
      disabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        borderSide: BorderSide(
          width: 1,
          color: ThemeColors.outline,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        borderSide: BorderSide(
          width: 1,
          color: ThemeColors.outline,
        ),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        borderSide: BorderSide(
          width: 1,
          color: ThemeColors.primaryRed,
        ),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        borderSide: BorderSide(
          width: 1,
          color: ThemeColors.primaryRed,
        ),
      ),
    );
  }
}
