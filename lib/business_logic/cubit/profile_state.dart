import 'package:event_runner/model/model.dart';

enum ProfileStateStatus {
  loading,
  error,
  success,
}

class ProfileState {
  final ProfileStateStatus status;
  final Profile? currentUser;

  ProfileState({
    required this.currentUser,
    required this.status,
  });

  ProfileState withStatus(ProfileStateStatus status) {
    return ProfileState(
      status: status,
      currentUser: currentUser,
    );
  }

  ProfileState withUser(Profile? user) {
    return ProfileState(
      status: status,
      currentUser: user,
    );
  }
}
