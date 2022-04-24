import 'package:event_runner/business_logic/api/gen_qr_api.dart';
import 'package:event_runner/model/model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'state.dart';

class GenQrCubit extends Cubit<GenQrState> {
  final GenQrApi _api;
  GenQrCubit(this._api) : super(GenQrInit());

  void gen({required Event forEvent}) async {
    if (state is GenQrLoading) return;
    emit(GenQrLoading());

    final res = await _api.genQrs(forEvent);

    emit(
      res.success ? GenQrSuccess(res.data) : GenQrFailure(res.error),
    );
  }
}
