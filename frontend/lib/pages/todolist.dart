import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/-/todo.dart';
import '../constants/colors.dart';
import '../widgets/todo_item.dart';
import 'package:flutter/material.dart';

class MyTodo extends StatefulWidget {
  const MyTodo({super.key});

  @override
  State<MyTodo> createState() => _MyTodoState();
}

class _MyTodoState extends State<MyTodo> {
  List<ToDo> todoList = [];
  List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();

  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _loadToDoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdGrey,
      appBar: _buildAppBar(),
      // drawer: _buildDrawer(),
      body: Stack(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              searchBox(),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 50, bottom: 20),
                      child: const Text(
                        "ALL TO Do",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                    for (ToDo todo in _foundToDo.reversed)
                      TodoItem(
                        todo: todo,
                        onToDoChange: _handleToDoChange,
                        onDeleteItem: _deleteToDoItem,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Row(children: [
              Expanded(
                child: Container(
                  margin:
                      const EdgeInsets.only(bottom: 20, right: 20, left: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                    color: tdbackground,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(255, 0, 0, 0),
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    controller: _todoController,
                    decoration: const InputDecoration(
                        hintText: "add a new todo list",
                        border: InputBorder.none),
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(bottom: 20, right: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      _addToDoItem(_todoController.text);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: tdblue,
                        minimumSize: const Size(60, 60),
                        elevation: 10),
                    child: const Text("+", style: TextStyle(fontSize: 40)),
                  )),
            ]))
      ]),
    );
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _deleteToDoItem(String id) {
    setState(() {
      todoList.removeWhere((item) => item.id == id);
      _saveToDoList();
    });
  }

  void _addToDoItem(String toDo) {
    setState(() {
      todoList.add(ToDo(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          todoText: toDo));
      _saveToDoList();
    });
    _todoController.clear();
  }

  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];
    if (enteredKeyword.isEmpty) {
      results = todoList;
    } else {
      results = todoList
          .where((item) => item.todoText!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundToDo = results;
    });
  }

  void _loadToDoList() async {
    prefs = await SharedPreferences.getInstance();
    String? todoData = prefs.getString('todoList');
    if (todoData != null) {
      List<dynamic> decodedList = jsonDecode(todoData);
      setState(() {
        todoList = decodedList.map((e) => ToDo.fromJson(e)).toList();
        _foundToDo = todoList;
      });
    }
  }

  void _saveToDoList() {
    String encodedList = jsonEncode(todoList);
    prefs.setString('todoList', encodedList);
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdbackground,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset("assets/salad_cat.png"),
            ),
          ),
        ],
      ),
    );
  }

  Widget searchBox() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Material(
          elevation: 5, // Atur ketinggian bayangan (shadow)
          shadowColor: Colors.black45, // Warna bayangan
          borderRadius: BorderRadius.circular(15),
          child: TextField(
            onChanged: (value) => _runFilter(value),
            decoration: InputDecoration(
                filled: true,
                fillColor: tdbackground,
                contentPadding: const EdgeInsets.all(10),
                hintStyle: const TextStyle(color: tdGrey, fontSize: 14),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset("assets/icons/search.png"),
                ),
                suffixIcon: Container(
                    width: 100,
                    child: IntrinsicHeight(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const VerticalDivider(
                          color: Colors.black,
                          thickness: 0.1,
                          indent: 10,
                          endIndent: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Image.asset("assets/icons/filter.png"),
                        )
                      ],
                    ))),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none)),
          ),
        ));
  }

  // Drawer _buildDrawer() {
  //   return Drawer(
  //     child: ListView(
  //       padding: EdgeInsets.zero,
  //       children: <Widget>[
  //         const DrawerHeader(
  //           decoration: BoxDecoration(
  //             color: tdblue,
  //           ),
  //           child: Text(
  //             'Menu',
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontSize: 24,
  //             ),
  //           ),
  //         ),
  //         ListTile(
  //             leading: const Icon(Icons.home),
  //             title: const Text('Home'),
  //             onTap: () {
  //               Navigator.pop(context);
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(builder: (context) => MyHomepage()),
  //               );
  //             }),
  //         ListTile(
  //           leading: const Icon(Icons.add),
  //           title: const Text('Add Collection'),
  //           onTap: () {
  //             Navigator.pop(context);
  //             Navigator.push(context,
  //                 MaterialPageRoute(builder: (context) => const DbTester()));
  //           },
  //         ),
  //         ListTile(
  //           leading: const Icon(Icons.info),
  //           title: const Text('About'),
  //           onTap: () {
  //             Navigator.pop(context);
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
