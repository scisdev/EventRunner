import 'package:event_runner/model/model.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final Profile profileFromBackend;

  LoginSuccess(this.profileFromBackend);
}

class LoginError extends LoginState {
  final String errorDescription;

  LoginError(this.errorDescription);
}
