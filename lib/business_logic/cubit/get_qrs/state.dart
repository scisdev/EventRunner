import 'package:event_runner/model/model.dart';

abstract class GetQrState {}

class GetQrInit extends GetQrState {}

class GetQrLoading extends GetQrState {}

class GetQrSuccess extends GetQrState {
  final List<Qr> qrs;

  GetQrSuccess(this.qrs);
}

class GetQrFailure extends GetQrState {
  final String description;

  GetQrFailure(this.description);
}
