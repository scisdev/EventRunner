import 'dart:convert';

import 'package:event_runner/business_logic/api/scan_qr_api.dart';
import 'package:event_runner/business_logic/business_logic.dart';
import 'package:event_runner/model/model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'state.dart';

class QrScanCubit extends Cubit<ScanQrState> {
  final ScanQrApi _api;

  QrScanCubit(this._api) : super(ScanQrInit());

  void scan(String s) async {
    if (state is ScanQrLoading) return;
    emit(ScanQrLoading());

    try {
      final qr = Qr.fromJson(jsonDecode(s));
      final Result res;
      if (qr is StepQr) {
        res = await _api.step(qr);
      } else if (qr is AchievementQr) {
        res = await _api.achievement(qr);
      } else if (qr is EntryQr) {
        res = await _api.entryQr(qr);
      } else if (qr is ExitQr) {
        res = await _api.exitQr(qr);
      } else {
        throw UnimplementedError();
      }

      if (res.success) {
        emit(ScanQrSuccess(res.data));
      } else {
        emit(ScanQrFailure('Ошибка при извлечении данных!'));
      }
    } catch (_) {
      emit(ScanQrFailure('Неправильный тип QR-кода!'));
    }
  }
}
