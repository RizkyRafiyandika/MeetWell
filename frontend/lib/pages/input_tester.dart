import 'package:fitness2/database_instace.dart';
import 'package:flutter/material.dart';

class InputDb extends StatefulWidget {
  const InputDb({super.key});

  @override
  State<InputDb> createState() => _InputDbState();
}

class _InputDbState extends State<InputDb> {
  DataBaseInstance databaseInstance = DataBaseInstance();
  TextEditingController nameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  @override
  void initState() {
    databaseInstance.database();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create")),
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.all(8.0)),
          const Text("nama Product"),
          TextField(controller: nameController),
          const SizedBox(
            height: 15,
          ),
          const Text("Category "),
          TextField(controller: categoryController),
          ElevatedButton(
            onPressed: () async {
              await databaseInstance.insert({
                "name": nameController.text,
                "category": categoryController.text,
                "create_at": DateTime.now().toString(),
                "update_at": DateTime.now().toString(),
              });
              Navigator.pop(context);
            },
            child: const Text("Submit"),
          )
        ],
      ),
    );
  }
}
