import 'package:event_runner/main.dart';
import 'package:event_runner/model/model.dart';
import 'package:event_runner/ui/event_page/view/event_page.dart';
import 'package:event_runner/util/theme.dart';
import 'package:flutter/material.dart';

class EventEntry extends StatelessWidget {
  final Event event;

  const EventEntry(this.event, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.of(context).push(
            NavigatorPage(builder: (_) {
              return EventPage(event);
            }),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            profile(),
            const SizedBox(height: 16),
            posterPic(),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                event.name,
                style: ThemeFonts.h2,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${event.type} • ${event.duration}',
                style: ThemeFonts.s.copyWith(
                  color: ThemeColors.secondaryText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profile() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(11),
          ),
          child: SizedBox(
            height: 31,
            width: 31,
            child: Image.network(
              event.creator.avatarUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            event.creator.displayName,
            style: ThemeFonts.s,
          ),
        ),
      ],
    );
  }

  Widget profilePic() {
    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(11),
      ),
      child: SizedBox(
        height: 31,
        width: 31,
        child: Image.network(
          event.creator.avatarUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget posterPic() {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      child: Image.network(
        event.posterUrl,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
