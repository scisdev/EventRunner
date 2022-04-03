abstract class Persistable {
  final int id;

  Persistable(this.id);

  Map<String, dynamic> toJson();

  Persistable withId(int id);
}
