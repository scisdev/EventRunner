import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_runner/business_logic/business_logic.dart';
import 'package:event_runner/model/model.dart';
import 'package:event_runner/ui/widgets/widgets.dart';
import 'package:event_runner/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'event_page.dart';

class EventPageDetails extends StatelessWidget {
  final Event event;
  const EventPageDetails(this.event, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          TopBar(event),
          const SizedBox(height: 12),
          attendants(context),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 12,
              ),
              child: actions(context),
            ),
          ),
        ]),
      ),
    );
  }

  Widget attendants(BuildContext context) {
    return BlocBuilder<EventInfoCubit, EventInfo>(
      builder: (ctx, state) {
        if (state is EventInfoInit || state is EventInfoLoading) {
          return const Padding(
            padding: EdgeInsets.all(40),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is EventInfoFailure) {
          return Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                const Text('Ошибка при получении данных'),
                const SizedBox(height: 24),
                AccentButton(
                  content: const Text('Ещё раз'),
                  onTap: () {
                    BlocProvider.of<EventInfoCubit>(context).getAttendants();
                  },
                ),
              ],
            ),
          );
        } else {
          final at = (state as EventInfoSuccess).attendants;
          if (at.isEmpty) {
            return const Center(
              child: Text(
                'Пока что участников нет',
                style: ThemeFonts.p2,
              ),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Участники: ${at.length}',
                    style: ThemeFonts.h2,
                  ),
                ),
                const SizedBox(height: 12),
                const CustomDivider(),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(
                    child: Center(
                      child: AttendantEntry(at[0]),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Center(
                      child: at.length > 1 ? AttendantEntry(at[1]) : null,
                    ),
                  ),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(
                    child: Center(
                      child: at.length > 2 ? AttendantEntry(at[2]) : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Center(
                      child: at.length > 3 ? AttendantEntry(at[3]) : null,
                    ),
                  ),
                ]),
                if (at.length > 4)
                  AccentButton(
                    content: const Text('Посмотреть всех'),
                    onTap: () {},
                  ),
                const SizedBox(height: 12),
                const CustomDivider(),
              ],
            );
          }
        }
      },
    );
  }

  Widget actions(BuildContext context) {
    final p = BlocProvider.of<ProfileCubit>(context);
    if (event.creatorId == p.state.currentUser.id) {
      return Column(
        children: [
          AccentButton(
            content: const Text('Редактировать мероприятие'),
            onTap: () {},
          ),
          const SizedBox(height: 12),
          AccentButton(
            content: const Text('Закрыть мероприятие'),
            onTap: () {},
          ),
          const SizedBox(height: 12),
          AccentButton(
            content: const Text('Посмотреть статистику'),
            onTap: () {},
          ),
          const SizedBox(height: 12),
          AccentButton(
            content: const Text('Перегенерировать QR-коды'),
            onTap: () {},
          ),
        ],
      );
    } else {
      return BlocBuilder<EventInfoCubit, EventInfo>(
        builder: (ctx, state) {
          if (state is EventInfoInit || state is EventInfoLoading) {
            return const Padding(
              padding: EdgeInsets.all(40),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is EventInfoSuccess) {
            return Column(
              children: [
                AccentButton(
                  content: Text(
                    state.attendants
                            .where(
                              (f) => f.id == p.state.currentUser.id,
                            )
                            .toList()
                            .isEmpty
                        ? 'Я пойду'
                        : 'Я не пойду',
                  ),
                  onTap: () {},
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
}

class AttendantEntry extends StatelessWidget {
  final Profile profile;
  const AttendantEntry(this.profile, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
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
        Text(
          profile.displayName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: ThemeFonts.s,
        ),
      ],
    );
  }
}
