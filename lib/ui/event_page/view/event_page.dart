import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_runner/business_logic/business_logic.dart';
import 'package:event_runner/business_logic/cubit/event_info/cubit.dart';
import 'package:event_runner/main.dart';
import 'package:event_runner/model/model.dart';
import 'package:event_runner/ui/event_page/view/event_page_details.dart';
import 'package:event_runner/ui/widgets/widgets.dart';
import 'package:event_runner/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_flutter/qr_flutter.dart';

class EventPage extends StatelessWidget {
  final Event event;
  final bool forceGenRqs;

  const EventPage(
    this.event, {
    Key? key,
    this.forceGenRqs = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => GenQrCubit(GenQrApiDBImpl(
                RepositoryProvider.of<Database>(context),
              )),
            ),
            BlocProvider(
              create: (_) => GetQrCubit(GetQrApiDBImpl(
                RepositoryProvider.of<Database>(context),
              )),
            ),
          ],
          child: CustomScrollView(
            slivers: [
              SliverStickyHeader(
                header: TopBar(event, includeActions: true),
                sliver: constantPart(context),
              ),
              qrs(),
            ],
          ),
        ),
      ),
    );
  }

  Widget constantPart(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        const SizedBox(height: 32),
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 2 / 3,
            height: MediaQuery.of(context).size.width * 2 / 3,
            child: ClipPath(
              clipper: const ShapeBorderClipper(
                shape: CircleBorder(),
              ),
              child: CachedNetworkImage(
                imageUrl: event.posterUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        EventDescription(event),
        const SizedBox(height: 32),
        const CustomDivider(),
      ]),
    );
  }

  Widget qrs() {
    return SliverStickyHeader(
      header: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: ThemeColors.background,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Сгенерированные QR-коды',
                style: ThemeFonts.h2,
              ),
            ),
          ),
        ],
      ),
      sliver: QrArea(
        event,
        forceGenQrs: forceGenRqs,
      ),
    );
  }
}

class EventDescription extends StatelessWidget {
  final Event event;

  const EventDescription(this.event, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '${event.type} • ${event.duration}',
                style: ThemeFonts.s.copyWith(
                  color: ThemeColors.secondaryText,
                ),
              ),
              const Spacer(),
              Text(
                event.qrUsage.toDisplayString,
                style: ThemeFonts.s.copyWith(
                  color: ThemeColors.secondaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            event.desc,
            textAlign: TextAlign.center,
            style: ThemeFonts.s.copyWith(fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  final Event event;
  final bool includeActions;

  const TopBar(
    this.event, {
    Key? key,
    this.includeActions = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: ThemeColors.background,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: SvgPicture.asset(
                  ThemeDrawable.chevronLeft,
                ),
              ),
            ),
          ),
          if (includeActions)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ActionsArea(event),
              ),
            ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 85,
              ),
              child: Text(
                event.name,
                style: ThemeFonts.h1,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ActionsArea extends StatefulWidget {
  final Event event;
  const ActionsArea(this.event, {Key? key}) : super(key: key);

  @override
  _ActionsAreaState createState() => _ActionsAreaState();
}

class _ActionsAreaState extends State<ActionsArea> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () {
        Navigator.of(context).push(
          NavigatorPage(builder: (_) {
            return BlocProvider(
              create: (_) {
                return EventInfoCubit(
                  EventInfoApiDBImpl(
                    RepositoryProvider.of<Database>(context),
                  ),
                  event: widget.event,
                )..getAttendants();
              },
              child: EventPageDetails(widget.event),
            );
          }),
        );
      },
    );
  }
}

class QrArea extends StatefulWidget {
  final Event event;
  final bool forceGenQrs;

  const QrArea(
    this.event, {
    Key? key,
    this.forceGenQrs = false,
  }) : super(key: key);

  @override
  _QrAreaState createState() => _QrAreaState();
}

class _QrAreaState extends State<QrArea> {
  @override
  void initState() {
    BlocProvider.of<GetQrCubit>(context).getQrs(widget.event);
    if (widget.forceGenQrs && widget.event.qrUsage != QrUsage.noQr) {
      BlocProvider.of<GenQrCubit>(context).gen(forEvent: widget.event);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetQrCubit, GetQrState>(builder: (ctx, state) {
      if (state is GetQrLoading || state is GetQrInit) {
        return padded(
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else if (state is GetQrFailure) {
        return padded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Ошибка при получении QR-кодов'),
              const SizedBox(height: 24),
              AccentButton(
                content: const Text('Повторить попытку'),
                onTap: () {},
              ),
            ],
          ),
        );
      } else {
        if (widget.event.qrUsage == QrUsage.noQr) {
          return padded(
            child: Center(
              child: Text(
                'Для этого мероприятия не требуются QR-коды',
                textAlign: TextAlign.center,
                style: ThemeFonts.p2.copyWith(
                  color: ThemeColors.secondaryText,
                ),
              ),
            ),
          );
        } else {
          if ((state as GetQrSuccess).qrs.isEmpty) {
            return padded(child: GenQrArea(widget.event));
          } else {
            return SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  mainAxisSpacing: 24,
                ),
                delegate: SliverChildBuilderDelegate(
                  (ctx, index) {
                    return QrEntry(qr: state.qrs[index]);
                  },
                  childCount: state.qrs.length,
                ),
              ),
            );
          }
        }
      }
    });
  }

  Widget padded({required Widget child}) {
    return SliverPadding(
      padding: const EdgeInsets.all(40),
      sliver: SliverToBoxAdapter(child: child),
    );
  }
}

class GenQrArea extends StatelessWidget {
  final Event event;
  const GenQrArea(this.event, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GenQrCubit, GenQrState>(
      listener: (ctx, state) {
        if (state is GenQrSuccess) {
          BlocProvider.of<GetQrCubit>(context).getQrs(event);
        }
      },
      builder: (ctx, state) {
        if (state is GenQrInit) {
          return Column(
            children: [
              const Text('QR-коды ещё не сгенерированы'),
              const SizedBox(height: 24),
              AccentButton(
                content: const Text('Сгенерировать'),
                onTap: () {
                  BlocProvider.of<GenQrCubit>(context).gen(forEvent: event);
                },
              ),
            ],
          );
        } else if (state is GenQrLoading) {
          return const Padding(
            padding: EdgeInsets.all(40),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is GenQrFailure) {
          return Column(
            children: [
              const Text('Ошибка при генерации QR кодов'),
              const SizedBox(height: 24),
              AccentButton(
                content: const Text('Ещё раз!'),
                onTap: () {
                  BlocProvider.of<GenQrCubit>(context).gen(forEvent: event);
                },
              ),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class ActualQrList extends StatelessWidget {
  final List<Qr> qrs;

  const ActualQrList({Key? key, required this.qrs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class QrEntry extends StatelessWidget {
  final Qr qr;
  const QrEntry({Key? key, required this.qr}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: ThemeFonts.p2.copyWith(
              color: ThemeColors.secondaryText,
            ),
          ),
          Expanded(
            child: QrImage(
              data: jsonEncode(qr.toJson()),
              padding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }

  String get text {
    final qr = this.qr;
    if (qr is EntryQr) {
      return 'Вход';
    } else if (qr is ExitQr) {
      return 'Выход';
    } else if (qr is StepQr) {
      return 'Шаг todo';
    } else if (qr is AchievementQr) {
      return 'Достижение todo';
    } else {
      throw UnimplementedError();
    }
  }
}
