import 'package:event_runner/model/model.dart';

import '../business_logic.dart';

abstract class GenQrApi {
  Future<Result<List<Qr>>> genQrs(Event event);
}

class GenQrApiDBImpl extends GenQrApi {
  final Database _db;

  GenQrApiDBImpl(this._db);

  @override
  Future<Result<List<Qr>>> genQrs(Event event) async {
    try {
      await _db.qrs.deleteByIds(
        (await _db.qrs.getAll())
            .where((qr) => qr.eventId == event.id)
            .map((e) => e.id!)
            .toList(),
      );

      if (event.qrUsage == QrUsage.noQr) {
        return Result.success([]);
      } else if (event.qrUsage == QrUsage.achievements) {
        return Result.success(
          await _db.qrs.persistBatch(
            (await _db.achievements.getAll())
                .where((a) => a.eventId == event.id)
                .map((a) {
              return AchievementQr(achId: a.id!, eventId: a.eventId);
            }).toList(),
          ),
        );
      } else if (event.qrUsage == QrUsage.everyStep) {
        return Result.success(
          await _db.qrs.persistBatch(
            (await _db.steps.getAll())
                .where((s) => s.eventId == event.id)
                .map((s) {
              return StepQr(stepId: s.id!, eventId: s.eventId);
            }).toList(),
          ),
        );
      } else if (event.qrUsage == QrUsage.onlyIn) {
        return Result.success([
          await _db.qrs.persistNew(
            EntryQr(eventId: event.id!),
          )
        ]);
      } else {
        return Result.success(await _db.qrs.persistBatch([
          EntryQr(eventId: event.id!),
          ExitQr(eventId: event.id!),
        ]));
      }
    } catch (_) {
      return Result.failure('Ошибка при генерации QR-кодов!');
    }
  }
}
