import 'package:event_runner/model/model.dart';

class ProfileInfo {
  final List<Event> createdEvents;
  final List<Event> attendedEvents;

  ProfileInfo({
    required this.createdEvents,
    required this.attendedEvents,
  });
}

class ProfileState {
  final Profile currentUser;
  final ProfileInfo? profileInfo;

  ProfileState({
    required this.currentUser,
    required this.profileInfo,
  });

  ProfileState withInfo(ProfileInfo? info) {
    return ProfileState(currentUser: currentUser, profileInfo: info);
  }
}
