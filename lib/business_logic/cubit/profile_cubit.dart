import 'package:event_runner/business_logic/cubit/cubit.dart';
import 'package:event_runner/model/model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final Database _db;

  ProfileCubit(this._db, {required Profile profile})
      : super(ProfileState(
            currentUser: profile,
            profileInfo: null,
            status: ProfileStateStatus.done));

  void loadInfo({bool reload = false}) async {
    if (state.status.isLoading) return;
    if (!reload && state.profileInfo != null) return;

    try {
      await Future.delayed(Duration(seconds: 2));
      final events = await _db.getEvents();

      emit(
        state.withInfo(
          ProfileInfo(
            attendedEvents: events
                .where((e) => e.attendeeIds.contains(state.currentUser.id))
                .toList(growable: false),
            createdEvents: events
                .where((e) => e.creatorId == state.currentUser.id)
                .toList(growable: false),
            achievements: [], //todo
          ),
        ),
      );
    } catch (_) {}
  }
}
