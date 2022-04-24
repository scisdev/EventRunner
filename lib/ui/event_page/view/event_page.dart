import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_runner/business_logic/business_logic.dart';
import 'package:event_runner/model/model.dart';
import 'package:event_runner/ui/widgets/widgets.dart';
import 'package:event_runner/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
        child: Column(
          children: [
            TopBar(event.name),
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
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            EventDescription(event),
            const SizedBox(height: 32),
            const CustomDivider(),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Сгенерированные QR-коды',
                  style: ThemeFonts.h2,
                ),
              ),
            ),
            const CustomDivider(),
            MultiBlocProvider(
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
              child: QrArea(event, forceGenQrs: forceGenRqs),
            ),
          ],
        ),
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
  final String title;

  const TopBar(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
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
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 85,
              ),
              child: Text(
                title,
                style: ThemeFonts.h1,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
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
    if (widget.forceGenQrs || widget.event.qrUsage != QrUsage.noQr) {
      BlocProvider.of<GenQrCubit>(context).gen(forEvent: widget.event);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenQrCubit, GenQrState>(builder: (ctx, state) {
      throw UnimplementedError();
    });
  }
}
