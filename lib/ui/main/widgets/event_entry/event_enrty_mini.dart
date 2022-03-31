import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_runner/model/model.dart';
import 'package:event_runner/util/theme.dart';
import 'package:flutter/material.dart';

class EventEntryMini extends StatelessWidget {
  final Event event;

  const EventEntryMini(this.event, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(11),
              ),
              child: CachedNetworkImage(
                imageUrl: event.posterUrl,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                event.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: ThemeFonts.h2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
