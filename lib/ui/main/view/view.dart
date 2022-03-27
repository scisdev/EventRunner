import 'package:event_runner/business_logic/cubit/cubit.dart';
import 'package:event_runner/model/model.dart';
import 'package:event_runner/ui/widgets/widgets.dart';
import 'package:event_runner/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/event_entry.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    BlocProvider.of<EventCubit>(context).load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                children: const [
                  SizedBox(height: 26),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: InputField(
                      prefix: Icon(
                        Icons.search,
                      ),
                      hintText: 'Поиск',
                    ),
                  ),
                  SizedBox(height: 24),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Категория',
                        style: ThemeFonts.h2,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  CategoryFilter(),
                  SizedBox(height: 24),
                  CustomDivider(),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Feed(),
                    ),
                  ),
                ],
              ),
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: MainAppBar(),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryFilter extends StatelessWidget {
  const CategoryFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventCubit, EventState>(
      builder: (ctx, state) {
        return SizedBox(
          width: double.infinity,
          height: 48,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            separatorBuilder: (_, __) {
              return const SizedBox(width: 8);
            },
            itemBuilder: (ctx, index) {
              if (index == 0) {
                return item(
                  context,
                  null,
                  state.filterCategory,
                );
              } else {
                return item(
                  context,
                  state.events[index - 1].type,
                  state.filterCategory,
                );
              }
            },
            itemCount: state.events.length + 1,
          ),
        );
      },
    );
  }

  Widget item(BuildContext context, String? text, String? choice) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),
      child: GestureDetector(
        key: ValueKey(text == choice),
        onTap: () {
          BlocProvider.of<EventCubit>(context).selectFilter(text);
        },
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: choice == text ? ThemeColors.primary : ThemeColors.form,
            borderRadius: const BorderRadius.all(Radius.circular(32)),
          ),
          child: Center(
            child: Text(
              text ?? 'Все',
              style: ThemeFonts.h2.copyWith(
                color:
                    choice == text ? Colors.white : ThemeColors.secondaryText,
                fontWeight: choice == text ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Feed extends StatelessWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventCubit, EventState>(builder: (ctx, state) {
      if (state.status == EventStateStatus.loading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state.status == EventStateStatus.error) {
        return const Center(child: Text('error todo'));
      } else {
        if (state.filterCategory == null) {
          return generate(state.events);
        } else {
          return generate(
            state.events
                .where(
                  (e) => e.type == state.filterCategory,
                )
                .toList(),
          );
        }
      }
    });
  }

  Widget generate(List<Event> events) {
    final res = <Widget>[
      const SizedBox(height: 23),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Найдено мероприятий: ${events.length}',
          style: ThemeFonts.h2,
        ),
      ),
      const SizedBox(height: 23),
    ];

    for (int i = 0; i < events.length; i = i + 2) {
      if (i + 1 < events.length) {
        res.add(
          TwoRow(
            one: events[i],
            two: events[i + 1],
          ),
        );
      } else {
        res.add(
          OneRow(
            one: events[i],
          ),
        );
      }
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),
      child: Align(
        key: ValueKey(res.map((e) => e.hashCode.toString()).join()),
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 16, bottom: 120),
          child: Column(children: res),
        ),
      ),
    );
  }
}

class TwoRow extends StatelessWidget {
  final Event one;
  final Event two;

  const TwoRow({
    Key? key,
    required this.one,
    required this.two,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: EventEntry(one)),
        const SizedBox(width: 26),
        Expanded(child: EventEntry(two)),
      ],
    );
  }
}

class OneRow extends StatelessWidget {
  final Event one;

  const OneRow({Key? key, required this.one}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: EventEntry(one)),
        const SizedBox(width: 26),
        const Spacer(),
      ],
    );
  }
}

class MainAppBar extends StatelessWidget {
  const MainAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      height: 120,
      child: Stack(children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            height: 95,
            color: ThemeColors.background,
            alignment: Alignment.topCenter,
            child: Row(children: [
              item('Главная', ThemeDrawable.home),
              item('Создать', ThemeDrawable.edit),
              item('QR-сканнер', null),
              item('События', ThemeDrawable.notifications),
              item('Профиль', ThemeDrawable.profile),
            ]),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: ThemeColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(ThemeDrawable.qrScan),
            ),
          ),
        ),
      ]),
    );
  }

  Widget item(String name, String? iconPath) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: Column(children: [
          const Spacer(),
          if (iconPath != null) SvgPicture.asset(iconPath),
          const Spacer(),
          Text(
            name,
            style: ThemeFonts.s.copyWith(
              color: ThemeColors.secondaryText,
            ),
          ),
        ]),
      ),
    );
  }
}
