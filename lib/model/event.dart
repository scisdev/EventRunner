import 'package:event_runner/model/model.dart';

class Event {
  final int id;
  final Profile creator;
  final String name;
  final String desc;
  final String type;
  final DateTime startTime;
  final String duration;
  final String posterUrl;
  final QrUsage qrUsage;

  Event({
    required this.id,
    required this.creator,
    required this.name,
    required this.desc,
    required this.type,
    required this.startTime,
    required this.duration,
    required this.posterUrl,
    required this.qrUsage,
  });
}
