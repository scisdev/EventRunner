import 'package:event_runner/business_logic/cubit/cubit.dart';
import 'package:event_runner/model/model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final Database _db;

  ProfileCubit(this._db, {required Profile profile})
      : super(ProfileState(
            currentUser: profile,
            profileInfo: null,
            status: ProfileStateStatus.init));

  void loadInfo({bool reload = false}) async {
    if (state.status.isLoading) return;
    if (!reload && state.profileInfo != null) return;

    emit(state.withStatus(ProfileStateStatus.loading));

    try {
      emit(
        state
            .withInfo(ProfileInfo(
              attendedEvents: await _db.events.getByIds(
                (await _db.attendeeXevent.getAll())
                    .where((e) => e.profileId == state.currentUser.id)
                    .map((e) => e.eventId)
                    .toList(),
              ),
              createdEvents: (await _db.events.getAll())
                  .where((e) => e.creatorId == state.currentUser.id)
                  .toList(),
              achievements: await _db.achievements.getByIds(
                (await _db.achievementXowner.getAll())
                    .where((e) => e.ownerId == state.currentUser.id)
                    .map((e) => e.achId)
                    .toList(),
              ),
            ))
            .withStatus(
              ProfileStateStatus.success,
            ),
      );
    } catch (_) {
      emit(state.withStatus(ProfileStateStatus.failure));
    }
  }
}
