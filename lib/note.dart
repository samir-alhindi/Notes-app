import 'package:hive_flutter/adapters.dart';

part 'note.g.dart';

@HiveType(typeId: 0)
class Note extends HiveObject{

  @HiveField(0)
  String title;

  @HiveField(1)
  String body;

  Note({this.title="", this.body=""});
}