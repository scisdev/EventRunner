import 'package:event_runner/model/model.dart';
import 'package:event_runner/ui/main/widgets/widgets.dart';
import 'package:flutter/material.dart';

class EventFeedGeneration {
  static List<Widget> generate(List<Event> events) {
    final res = <Widget>[];
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

    return res;
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
