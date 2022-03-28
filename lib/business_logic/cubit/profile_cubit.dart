import 'package:event_runner/business_logic/cubit/profile_state.dart';
import 'package:event_runner/business_logic/storage.dart';
import 'package:event_runner/model/model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit()
      : super(ProfileState(
          currentUser: null,
        ));

  void onUserLoggedIn(Profile profile) {
    emit(state.withUser(profile));
    LocalUser.persistLocalProfile(profile);
  }
}
