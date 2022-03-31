import 'package:event_runner/business_logic/cubit/cubit.dart';
import 'package:event_runner/model/model.dart' hide EventState;
import 'package:event_runner/ui/main/view/widgets/event_feed_generation.dart';
import 'package:event_runner/ui/widgets/widgets.dart';
import 'package:event_runner/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    final b = BlocProvider.of<EventCubit>(context);
    if (b.state.events.isEmpty) {
      b.load();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
      final events = state.events;
      if (events.isNotEmpty) {
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
      } else {
        if (state.status == EventStateStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == EventStateStatus.error) {
          return const Center(child: Text('error todo'));
        } else {
          return const SizedBox();
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
      ...EventFeedGeneration.generate(events),
    ];

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
