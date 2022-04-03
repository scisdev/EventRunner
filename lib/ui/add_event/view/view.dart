import 'package:event_runner/ui/main/main.dart';
import 'package:event_runner/ui/widgets/buttons.dart';
import 'package:event_runner/ui/widgets/input_field.dart';
import 'package:event_runner/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreateEventLayout extends StatefulWidget {
  const CreateEventLayout({Key? key}) : super(key: key);

  @override
  State<CreateEventLayout> createState() => _CreateEventLayoutState();
}

class _CreateEventLayoutState extends State<CreateEventLayout>
    with SingleTickerProviderStateMixin {
  late final TabController c;

  int page = 0;

  @override
  void initState() {
    c = TabController(length: 4, vsync: this);
    c.addListener(() {
      if (c.index != page) {
        setState(() {
          page = c.index;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppBar(page),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: c,
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: PageOne(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: PageTwo(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: PageThree(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: PageFour(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppBar extends StatelessWidget {
  final int page;

  const AppBar(this.page, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 24, left: 24),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: Row(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                MainScreen.of(context).selectScreen(0);
              },
              child: SizedBox(
                height: double.infinity,
                child: Center(
                  child: Text(
                    'Отмена',
                    style: ThemeFonts.h2.copyWith(
                      color: ThemeColors.primaryRed,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              height: double.infinity,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${page + 1}/',
                    style: ThemeFonts.h2,
                  ),
                  Text(
                    '4',
                    style: ThemeFonts.h2.copyWith(
                      color: ThemeColors.secondaryText,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PageOne extends StatefulWidget {
  const PageOne({Key? key}) : super(key: key);

  @override
  State<PageOne> createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  double sliderValue = 3;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
          const InputField(
            hintText: 'Введите название мероприятия',
          ),
          const SizedBox(height: 24),
          const Text('Описание', style: ThemeFonts.h2),
          const SizedBox(height: 10),
          const EventDescriptionInputField(),
          const SizedBox(height: 24),
          const Text('Время проведения (в минутах)', style: ThemeFonts.h2),
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
          Slider(
            value: sliderValue,
            onChanged: (s) {
              setState(() {
                sliderValue = s;
              });
            },
            min: 0,
            max: 6,
            divisions: 6,
            activeColor: ThemeColors.primary,
          ),
          const SizedBox(height: 50),
          AccentButton(
            content: const Text('Далее'),
            onTap: () {},
          ),
          const SizedBox(height: 150),
        ],
      ),
    );
  }
}

class PageTwo extends StatefulWidget {
  const PageTwo({Key? key}) : super(key: key);

  @override
  _PageTwoState createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(child: Text('Two')),
    );
  }
}

class PageThree extends StatefulWidget {
  const PageThree({Key? key}) : super(key: key);

  @override
  _PageThreeState createState() => _PageThreeState();
}

class _PageThreeState extends State<PageThree> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(child: Text("Three")),
    );
  }
}

class PageFour extends StatefulWidget {
  const PageFour({Key? key}) : super(key: key);

  @override
  _PageFourState createState() => _PageFourState();
}

class _PageFourState extends State<PageFour> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(child: Text("Four")),
    );
  }
}

class EventDescriptionInputField extends StatelessWidget {
  const EventDescriptionInputField({
    Key? key,
    this.controller,
  }) : super(key: key);

  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: getDecoration(),
      style: ThemeFonts.s.copyWith(
        color: ThemeColors.mainText,
        leadingDistribution: TextLeadingDistribution.even,
      ),
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
      ),
      hintStyle: ThemeFonts.s.copyWith(
        color: ThemeColors.secondaryText,
        leadingDistribution: TextLeadingDistribution.even,
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
