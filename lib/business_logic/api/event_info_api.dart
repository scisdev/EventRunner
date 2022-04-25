import 'package:event_runner/model/model.dart';

import '../business_logic.dart';

abstract class EventInfoApi {
  Future<Result<List<Profile>>> getAttendants(Event event);
}

class EventInfoApiDBImpl extends EventInfoApi {
  final Database _db;

  EventInfoApiDBImpl(this._db);

  @override
  Future<Result<List<Profile>>> getAttendants(Event event) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      return Result.success(
        await _db.profiles.getByIds(
          (await _db.attendeeXevent.getAll())
              .where((f) => f.eventId == event.id)
              .map((e) => e.profileId)
              .toList(),
        ),
      );
    } catch (_) {
      return Result.failure('Ошибка при получении данных о мероприятии');
    }
  }
}
