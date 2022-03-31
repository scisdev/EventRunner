import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_runner/business_logic/cubit/cubit.dart';
import 'package:event_runner/main.dart';
import 'package:event_runner/model/model.dart';
import 'package:event_runner/ui/event_page/view/event_page.dart';
import 'package:event_runner/ui/main/widgets/event_entry/creator_info_cubit.dart';
import 'package:event_runner/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: ThemeFonts.h2,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${event.type}   •   ${event.duration}',
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
    return BlocProvider(
      create: (context) => CICubit(
        RepositoryProvider.of<Database>(context),
        creatorId: event.creatorId,
      ),
      child: BlocBuilder<CICubit, CreatorInfoState>(
        builder: (context, state) {
          if (state is CILoading) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (state is CIFailure) {
            return const SizedBox();
          } else {
            return creatorInfo((state as CISuccess).profile);
          }
        },
      ),
    );
  }

  Widget creatorInfo(Profile profile) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(11),
          ),
          child: SizedBox(
            height: 31,
            width: 31,
            child: CachedNetworkImage(
              imageUrl: profile.avatarUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            profile.displayName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: ThemeFonts.s,
          ),
        ),
      ],
    );
  }

  Widget posterPic() {
    return SizedBox(
      width: double.infinity,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: SizedBox.square(
            dimension: 10,
            child: CachedNetworkImage(
              imageUrl: event.posterUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
