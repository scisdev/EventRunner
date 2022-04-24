import 'package:event_runner/model/model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileApi _api;

  ProfileCubit(this._api, {required Profile profile})
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
            .withInfo((await _api.getProfileInfo(state.currentUser.id!)).data)
            .withStatus(ProfileStateStatus.success),
      );
    } catch (_) {
      emit(state.withStatus(ProfileStateStatus.failure));
    }
  }
}
