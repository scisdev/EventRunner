class Achievement {
  final int id;
  final int eventId;
  final String name;
  final String desc;
  final List<int> owners;

  Achievement({
    required this.id,
    required this.eventId,
    required this.name,
    required this.desc,
    required this.owners,
  });
}
