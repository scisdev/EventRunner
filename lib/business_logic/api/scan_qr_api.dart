import 'package:event_runner/model/model.dart';

import '../business_logic.dart';

abstract class ScanQrApi {
  Future<Result<EntryForEvent>> entryQr(EntryQr qr);
  Future<Result<ExitForEvent>> exitQr(ExitQr qr);
  Future<Result<AchievementWithEvent>> achievement(AchievementQr qr);
  Future<Result<StepWithEvent>> step(StepQr qr);
}

class ScanQrApiDBImpl extends ScanQrApi {
  final Database _db;

  ScanQrApiDBImpl(this._db);

  @override
  Future<Result<AchievementWithEvent>> achievement(AchievementQr qr) async {
    try {
      final achievement = (await _db.achievements.getAll())
          .where(
            (f) => f.id == qr.achId,
          )
          .first;
      final event = (await _db.events.getAll())
          .where(
            (f) => f.id == qr.eventId,
          )
          .first;
      return Result.success(AchievementWithEvent(
        achievement: achievement,
        event: event,
      ));
    } catch (_) {
      return Result.failure('Ошибка');
    }
  }

  @override
  Future<Result<EntryForEvent>> entryQr(EntryQr qr) async {
    try {
      return Result.success(
        EntryForEvent(
          (await _db.events.getAll())
              .where(
                (f) => f.id == qr.eventId,
              )
              .first,
        ),
      );
    } catch (_) {
      return Result.failure('Ошибка');
    }
  }

  @override
  Future<Result<ExitForEvent>> exitQr(ExitQr qr) async {
    try {
      return Result.success(
        ExitForEvent(
          (await _db.events.getAll())
              .where(
                (f) => f.id == qr.eventId,
              )
              .first,
        ),
      );
    } catch (_) {
      return Result.failure('Ошибка');
    }
  }

  @override
  Future<Result<StepWithEvent>> step(StepQr qr) async {
    try {
      final step = (await _db.steps.getAll())
          .where(
            (f) => f.id == qr.stepId,
          )
          .first;
      final event = (await _db.events.getAll())
          .where(
            (f) => f.id == qr.eventId,
          )
          .first;
      return Result.success(StepWithEvent(
        step: step,
        event: event,
      ));
    } catch (_) {
      return Result.failure('Ошибка');
    }
  }
}

class AchievementWithEvent {
  final Achievement achievement;
  final Event event;

  AchievementWithEvent({
    required this.achievement,
    required this.event,
  });
}

class StepWithEvent {
  final EventStep step;
  final Event event;

  StepWithEvent({
    required this.step,
    required this.event,
  });
}

class EntryForEvent {
  final Event event;

  EntryForEvent(this.event);
}

class ExitForEvent {
  final Event event;

  ExitForEvent(this.event);
}
