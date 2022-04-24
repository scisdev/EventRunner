import 'package:event_runner/model/model.dart';
import 'package:event_runner/ui/add_event/add_event.dart';

import '../business_logic.dart';

abstract class AddEventApi {
  Future<Result<Event>> addEvent(
    Event event,
    List<String> steps,
    List<LocalAchievement> achievements,
  );
}

class AddEventApiDBImpl extends AddEventApi {
  final Database _db;

  AddEventApiDBImpl(this._db);

  @override
  Future<Result<Event>> addEvent(
    Event event,
    List<String> steps,
    List<LocalAchievement> achievements,
  ) async {
    try {
      final createdEvent = await _db.events.persistNew(event);
      await _addSteps(steps, createdEvent.id!);
      await _addAchievements(achievements, createdEvent.id!);
      await _generateQrs(createdEvent);

      return Result.success(createdEvent);
    } catch (_) {
      return Result.failure('Ошибка при добавлении мероприятия!');
    }
  }

  Future<Result<List<EventStep>>> _addSteps(
    List<String> steps,
    int eventId,
  ) async {
    try {
      return Result.success(await _db.steps.persistBatch(steps.map((e) {
        return EventStep(eventId: eventId, name: e);
      }).toList()));
    } catch (_) {
      rethrow;
    }
  }

  Future<Result<List<Achievement>>> _addAchievements(
    List<LocalAchievement> achievements,
    int eventId,
  ) async {
    try {
      return Result.success(await _db.achievements.persistBatch(
        achievements.map((e) {
          return Achievement(
            eventId: eventId,
            name: e.name,
            desc: e.desc,
          );
        }).toList(),
      ));
    } catch (_) {
      rethrow;
    }
  }

  Future<Result<List<Qr>>> _generateQrs(Event createdEvent) async {
    try {
      if (createdEvent.qrUsage == QrUsage.noQr) {
        return Result.success([]);
      } else if (createdEvent.qrUsage == QrUsage.achievements) {
        return Result.success(
          await _db.qrs.persistBatch(
            (await _db.achievements.getAll())
                .where((a) => a.eventId == createdEvent.id)
                .map((a) {
              return AchievementQr(achId: a.id!, eventId: a.eventId);
            }).toList(),
          ),
        );
      } else if (createdEvent.qrUsage == QrUsage.everyStep) {
        return Result.success(
          await _db.qrs.persistBatch(
            (await _db.steps.getAll())
                .where((s) => s.eventId == createdEvent.id)
                .map((s) {
              return StepQr(stepId: s.id!, eventId: s.eventId);
            }).toList(),
          ),
        );
      } else if (createdEvent.qrUsage == QrUsage.onlyIn) {
        return Result.success([
          await _db.qrs.persistNew(
            EntryQr(eventId: createdEvent.id!),
          )
        ]);
      } else {
        return Result.success(await _db.qrs.persistBatch([
          EntryQr(eventId: createdEvent.id!),
          ExitQr(eventId: createdEvent.id!),
        ]));
      }
    } catch (_) {
      rethrow;
    }
  }
}
