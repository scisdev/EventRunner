import 'package:event_runner/model/model.dart';

abstract class AddEventState {}

class AddEventInit extends AddEventState {}

class AddEventLoading extends AddEventState {}

class AddEventSuccess extends AddEventState {
  final Event createdEvent;

  AddEventSuccess(this.createdEvent);
}

class AddEventFailure extends AddEventState {
  final String description;

  AddEventFailure(this.description);
}
