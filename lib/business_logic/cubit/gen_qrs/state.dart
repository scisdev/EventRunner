import 'package:event_runner/model/model.dart';

abstract class GenQrState {}

class GenQrInit extends GenQrState {}

class GenQrLoading extends GenQrState {}

class GenQrSuccess extends GenQrState {
  final List<Qr> qrs;

  GenQrSuccess(this.qrs);
}

class GenQrFailure extends GenQrState {
  final String description;

  GenQrFailure(this.description);
}
