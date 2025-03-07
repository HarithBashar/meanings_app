import 'package:hive/hive.dart';

part 'word_class.g.dart';

@HiveType(typeId: 0)
class Word {
  @HiveField(0)
  String id;
  @HiveField(1)
  String word;
  @HiveField(2)
  String meaning;
  @HiveField(3)
  DateTime timeAdded;
  @HiveField(4)
  String language;

  Word({
    required this.id,
    required this.word,
    required this.meaning,
    required this.timeAdded,
    required this.language,
  });
}
