import 'dart:convert';

import 'package:event_runner/business_logic/cubit/profile_state.dart';
import 'package:event_runner/model/model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit()
      : super(ProfileState(
          currentUser: null,
          status: ProfileStateStatus.loading,
        )) {
    Future(init);
  }

  void init() async {
    final sp = await SharedPreferences.getInstance();

    if (sp.getString('profile') == null) {
      emit(state.withStatus(
        ProfileStateStatus.success,
      ));
    } else {
      emit(state
          .withUser(
            Profile.fromJson(
              jsonDecode(sp.getString('profile')!),
            ),
          )
          .withStatus(
            ProfileStateStatus.success,
          ));
    }
  }

  void onUserLoggedIn(Profile profile) {
    _persistProfileLocally(profile);

    emit(
      state.withUser(profile).withStatus(
            ProfileStateStatus.success,
          ),
    );
  }

  void _persistProfileLocally(Profile profile) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString('profile', jsonEncode(profile.toJson()));
  }
}
