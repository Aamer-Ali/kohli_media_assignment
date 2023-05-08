import 'dart:convert';

Todo todoFromJson(String str) => Todo.fromJson(json.decode(str));

String todoToJson(Todo data) => json.encode(data.toJson());

class Todo {
  String todoTitle;
  String todoDesc;

  Todo({
    required this.todoTitle,
    required this.todoDesc,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    todoTitle: json["todoTitle"],
    todoDesc: json["todoDesc"],
  );

  Map<String, dynamic> toJson() => {
    "todoTitle": todoTitle,
    "todoDesc": todoDesc,
  };
}
