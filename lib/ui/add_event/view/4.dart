import 'package:event_runner/business_logic/business_logic.dart';
import 'package:event_runner/ui/add_event/add_event.dart';
import 'package:event_runner/ui/widgets/widgets.dart';
import 'package:event_runner/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PageFour extends StatefulWidget {
  const PageFour({Key? key}) : super(key: key);

  @override
  _PageFourState createState() => _PageFourState();

  static _PageFourState of(BuildContext context) {
    final res = context.findAncestorStateOfType<_PageFourState>();
    if (res == null) {
      throw ElementNotFoundException();
    }

    return res;
  }
}

class _PageFourState extends State<PageFour> {
  final nameControllers = <TextEditingController>[];
  final descControllers = <TextEditingController>[];

  @override
  void initState() {
    for (final ach in CreateEventLayout.of(context).achs) {
      nameControllers.add(TextEditingController(text: ach.name));
      descControllers.add(TextEditingController(text: ach.desc));
    }
    super.initState();
  }

  @override
  void dispose() {
    for (final c in nameControllers) {
      c.dispose();
    }
    for (final c in descControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Text(
            'Достижения',
            style: ThemeFonts.h2,
          ),
          const SizedBox(height: 24),
          achievements(),
          AddAchievementButton(
            onTap: () {
              setState(() {
                nameControllers.add(TextEditingController());
                descControllers.add(TextEditingController());
                CreateEventLayout.of(context).achs.add(
                      LocalAchievement(
                        name: '',
                        desc: '',
                      ),
                    );
              });
            },
          ),
          const SizedBox(height: 24),
          AccentButton(
            content: const Text('Создать'),
            onTap: () {
              final cel = CreateEventLayout.of(context);
              for (final ach in cel.achs) {
                if (ach.name.isEmpty) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                      'У каждого достижения должно быть указано хотя бы название!',
                    ),
                  ));
                  return;
                }
              }

              BlocProvider.of<AddEventCubit>(context).addEvent(
                cel.createEvent(),
                cel.steps,
                cel.achs,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget achievements() {
    final res = <Widget>[];
    final cel = CreateEventLayout.of(context);

    for (var i = 0; i < cel.achs.length; i++) {
      res.add(Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: AchievementEntry(
          count: i + 1,
          nameController: nameControllers[i],
          descController: descControllers[i],
        ),
      ));
    }

    return Column(children: res);
  }

  void deleteAchAt(int i) {
    setState(() {
      nameControllers.removeAt(i);
      descControllers.removeAt(i);
      CreateEventLayout.of(context).achs.removeAt(i);
    });
  }
}

class AchievementEntry extends StatelessWidget {
  final int count;
  final TextEditingController nameController;
  final TextEditingController descController;

  const AchievementEntry({
    Key? key,
    required this.count,
    required this.nameController,
    required this.descController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        counter(),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            children: [
              InputField(
                controller: nameController,
                hintText: 'Название достижения',
                onChanged: (s) {
                  final cel = CreateEventLayout.of(context);
                  final ach = cel.achs[count - 1];
                  cel.achs[count - 1] = LocalAchievement(
                    name: s,
                    desc: ach.desc,
                  );
                },
              ),
              const SizedBox(height: 10),
              AchievementDescriptionField(
                controller: descController,
                onChanged: (s) {
                  final cel = CreateEventLayout.of(context);
                  final ach = cel.achs[count - 1];
                  cel.achs[count - 1] = LocalAchievement(
                    name: s,
                    desc: ach.desc,
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            PageFour.of(context).deleteAchAt(count - 1);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SvgPicture.asset(
              ThemeDrawable.closeIcon,
            ),
          ),
        ),
      ],
    );
  }

  Widget counter() {
    return Container(
      decoration: const BoxDecoration(
        color: ThemeColors.accentText,
        shape: BoxShape.circle,
      ),
      height: 24,
      width: 24,
      child: Center(
        child: Text(
          count.toString(),
          style: ThemeFonts.s.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class AchievementDescriptionField extends StatelessWidget {
  const AchievementDescriptionField({
    Key? key,
    this.controller,
    this.onChanged,
  }) : super(key: key);

  final TextEditingController? controller;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: getDecoration(),
      style: ThemeFonts.p2.copyWith(
        color: ThemeColors.mainText,
      ),
      onChanged: onChanged,
      minLines: 2,
      maxLines: 6,
    );
  }

  InputDecoration getDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 21,
        vertical: 16,
      ),
      hintText: 'Опишите способ получения достижения',
      errorStyle: const TextStyle(
        fontSize: 0,
      ),
      hintStyle: ThemeFonts.p2.copyWith(
        color: ThemeColors.secondaryText,
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
      alignLabelWithHint: true,
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

class AddAchievementButton extends StatelessWidget {
  final VoidCallback onTap;
  const AddAchievementButton({
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
            'Достижение',
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
