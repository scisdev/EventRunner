import 'package:event_runner/model/model.dart';

import '../business_logic.dart';

abstract class GetQrApi {
  Future<Result<List<Qr>>> getQrs(Event event);
}

class GetQrApiDBImpl extends GetQrApi {
  final Database _db;

  GetQrApiDBImpl(this._db);

  @override
  Future<Result<List<Qr>>> getQrs(Event event) async {
    try {
      return Result.success(
        (await _db.qrs.getAll()).where((f) => f.eventId == event.id).toList(),
      );
    } catch (_) {
      return Result.failure('Ошибка при получении QR-кодов!');
    }
  }
}
