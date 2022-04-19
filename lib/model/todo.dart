import 'package:hive/hive.dart';
part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject{
  @HiveField(0)
  String? id;
  @HiveField(1)
  final String item;
  @HiveField(2)
  final String quantity;
  Todo({
    required this.item,
    required this.quantity,
  });
}