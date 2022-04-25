import '../business_logic.dart';

abstract class ProfileApi {
  Future<Result<ProfileInfo>> getProfileInfo(int id);
}

class ProfileApiDBImpl extends ProfileApi {
  final Database _db;

  ProfileApiDBImpl(this._db);

  @override
  Future<Result<ProfileInfo>> getProfileInfo(int id) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return Result.success(ProfileInfo(
        attendedEvents: await _db.events.getByIds(
          (await _db.attendeeXevent.getAll())
              .where((e) => e.profileId == id)
              .map((e) => e.eventId)
              .toList(),
        ),
        createdEvents: (await _db.events.getAll())
            .where((e) => e.creatorId == id)
            .toList(),
        achievements: await _db.achievements.getByIds(
          (await _db.achievementXowner.getAll())
              .where((e) => e.ownerId == id)
              .map((e) => e.achId)
              .toList(),
        ),
      ));
    } catch (_) {
      return Result.failure('Ошибка при получении информации о профиле');
    }
  }
}
