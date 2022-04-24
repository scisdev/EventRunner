import 'package:event_runner/model/model.dart';

import '../business_logic.dart';

abstract class GetEventsApi {
  Future<Result<List<Event>>> getEvents();
}

class GetEventsApiDBImpl extends GetEventsApi {
  final Database _db;

  GetEventsApiDBImpl(this._db);

  @override
  Future<Result<List<Event>>> getEvents() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      return Result.success(await _db.events.getAll());
    } catch (_) {
      return Result.failure('Ошибка при получении списка мероприятий');
    }
  }
}
