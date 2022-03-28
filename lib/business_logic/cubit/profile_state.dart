import 'package:event_runner/model/model.dart';

class ProfileState {
  final Profile? currentUser;

  ProfileState({
    required this.currentUser,
  });

  ProfileState withUser(Profile? user) {
    return ProfileState(
      currentUser: user,
    );
  }
}
