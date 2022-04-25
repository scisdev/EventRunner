import 'package:event_runner/model/model.dart';

abstract class ScanQrState {}

class ScanQrInit extends ScanQrState {}

class ScanQrLoading extends ScanQrState {}

class ScanQrSuccess extends ScanQrState {
  final dynamic res;

  ScanQrSuccess(this.res);
}

class ScanQrFailure extends ScanQrState {
  final String description;

  ScanQrFailure(this.description);
}
