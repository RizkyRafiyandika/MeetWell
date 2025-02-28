import '../constants/colors.dart';
import '../models/-/todo.dart';
import 'package:flutter/material.dart';

class TodoItem extends StatelessWidget {
  final ToDo todo;
  final onToDoChange;
  final onDeleteItem;
  const TodoItem(
      {super.key,
      required this.todo,
      required this.onToDoChange,
      required this.onDeleteItem});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 20),
        child: ListTile(
          onTap: () {
            onToDoChange(todo);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular((20)),
          ),
          tileColor: const Color.fromARGB(255, 255, 255, 255),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          leading: Icon(
              todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
              color: tdblue),
          title: Text(todo.todoText!,
              style: TextStyle(
                  fontSize: 16,
                  color: tdBlack,
                  decoration: todo.isDone ? TextDecoration.lineThrough : null)),
          trailing: Container(
            padding: EdgeInsets.all(0),
            margin: EdgeInsets.symmetric(vertical: 12),
            height: 35,
            width: 35,
            decoration: BoxDecoration(
                color: tdRed, borderRadius: BorderRadius.circular(5)),
            child: IconButton(
                iconSize: 18,
                onPressed: () {
                  onDeleteItem(todo.id);
                },
                icon: const Icon(Icons.delete)),
          ),
        ));
  }
}
