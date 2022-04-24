import 'package:event_runner/business_logic/business_logic.dart'
    hide EventState;
import 'package:event_runner/main.dart';
import 'package:event_runner/model/model.dart';
import 'package:event_runner/ui/add_event/view/dialog.dart';
import 'package:event_runner/ui/event_page/view/event_page.dart';
import 'package:event_runner/ui/main/main.dart';
import 'package:event_runner/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '1.dart';
import '2.dart';
import '3.dart';
import '4.dart';

class ElementNotFoundException with Exception {}

class CreateEventPage extends StatelessWidget {
  const CreateEventPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return AddEventCubit(
          AddEventApiDBImpl(
            RepositoryProvider.of<Database>(context),
          ),
        );
      },
      child: const CreateEventLayout(),
    );
  }
}

class CreateEventLayout extends StatefulWidget {
  const CreateEventLayout({Key? key}) : super(key: key);

  @override
  State<CreateEventLayout> createState() => _CreateEventLayoutState();

  static _CreateEventLayoutState of(BuildContext context) {
    final res = context.findAncestorStateOfType<_CreateEventLayoutState>();
    if (res == null) {
      throw ElementNotFoundException();
    }

    return res;
  }
}

class _CreateEventLayoutState extends State<CreateEventLayout>
    with SingleTickerProviderStateMixin {
  late final TabController _c;

  String name = '';
  String description = '';
  String eventDuration = '';
  String eventType = '';
  QrUsage qrUsage = QrUsage.everyStep;
  final List<String> steps = [];
  final List<LocalAchievement> achs = <LocalAchievement>[];

  int _page = 0;

  @override
  void initState() {
    _c = TabController(length: 4, vsync: this);
    _c.addListener(() {
      if (_c.index != _page) {
        setState(() {
          _page = _c.index;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Event createEvent() {
    return Event(
      creatorId: BlocProvider.of<ProfileCubit>(context).state.currentUser.id!,
      name: name,
      desc: description,
      type: eventType,
      duration: eventDuration,
      startTime: DateTime.now().add(const Duration(days: 7)),
      qrUsage: qrUsage,
      posterUrl: '123',
      state: EventState.planned,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AddEventCubit, AddEventState>(
        listener: (ctx, state) {
          if (state is AddEventSuccess) {
            if (state.createdEvent.qrUsage == QrUsage.noQr) {
              MainScreen.of(context).goToMainScreen(true);
              return;
            }

            showDialog(
              context: ctx,
              builder: (ctx) {
                return const AlertDialog(
                  content: EventAddedDialog(),
                  contentPadding: EdgeInsets.all(30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(24),
                    ),
                  ),
                );
              },
            ).then((res) {
              if (res ?? false) {
                MainScreen.of(context).goToProfile();
                Navigator.of(context).push(
                  NavigatorPage(builder: (_) {
                    return EventPage(state.createdEvent, forceGenRqs: true);
                  }),
                );
              } else {
                MainScreen.of(context).goToMainScreen(true);
              }
            });
          } else if (state is AddEventFailure) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                'Ошибка при создании мероприятия! Попытайтесь ещё раз!',
              ),
            ));
          }
        },
        builder: (ctx, state) {
          final main = body();
          if (state is AddEventLoading) {
            return AbsorbPointer(
              absorbing: true,
              child: Stack(
                children: [
                  Opacity(opacity: .5, child: main),
                  const Center(child: CircularProgressIndicator()),
                ],
              ),
            );
          }

          return main;
        },
      ),
    );
  }

  Widget body() {
    return SafeArea(
      child: Column(
        children: [
          AppBar(_page),
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _c,
              children: const [
                PageOne(),
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
    );
  }

  void nextPage() {
    if (_c.index > 2) return;

    _c.animateTo(
      _c.index + 1,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    );
  }

  void prevPage() {
    if (_c.index < 1) return;

    _c.animateTo(
      _c.index - 1,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
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
            Expanded(child: button(context)),
            Expanded(child: counter()),
          ],
        ),
      ),
    );
  }

  Widget button(BuildContext context) {
    return SizedBox.expand(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 450),
        child: GestureDetector(
          key: ValueKey(page == 0),
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (page == 0) {
              MainScreen.of(context).goToMainScreen(false);
            } else {
              CreateEventLayout.of(context).prevPage();
            }
          },
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              page == 0 ? 'Отмена' : 'Назад',
              style: ThemeFonts.h2.copyWith(
                color: ThemeColors.primaryRed,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget counter() {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 450),
            child: SizedBox(
              key: ValueKey(page),
              height: double.infinity,
              child: Center(
                child: Text(
                  '${page + 1}/',
                  style: ThemeFonts.h2,
                ),
              ),
            ),
          ),
          Text(
            '4',
            style: ThemeFonts.h2.copyWith(
              color: ThemeColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class LocalAchievement {
  final String name;
  final String desc;

  LocalAchievement({
    required this.name,
    required this.desc,
  });
}
