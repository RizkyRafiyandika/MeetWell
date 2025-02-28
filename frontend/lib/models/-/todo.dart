class ToDo {
  String? id;
  String? todoText;
  bool isDone;

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
  });

  // Convert a ToDo object into a Map
  Map<String, dynamic> toJson() => {
        'id': id,
        'todoText': todoText,
        'isDone': isDone,
      };

  // Convert a Map into a ToDo object
  factory ToDo.fromJson(Map<String, dynamic> json) => ToDo(
        id: json['id'],
        todoText: json['todoText'],
        isDone: json['isDone'],
      );

//   static List<ToDo> todoList() {
//     return [
//       ToDo(id: '01', todoText: 'Morning exercise', isDone: true),
//       ToDo(id: '02', todoText: 'Morning Star', isDone: true),
//       ToDo(
//         id: '03',
//         todoText: 'Morning wood',
//       ),
//       ToDo(
//         id: '04',
//         todoText: 'Morning Eat',
//       ),
//       ToDo(
//         id: '05',
//         todoText: 'Morning Good',
//       ),
//     ];
//   }
}
