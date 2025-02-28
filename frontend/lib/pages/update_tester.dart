import 'package:fitness2/database_instace.dart';
import 'package:fitness2/models/-/product_model.dart';
import 'package:flutter/material.dart';

class UpdateDb extends StatefulWidget {
  final ProductModel? productModel;
  const UpdateDb({super.key, this.productModel});

  @override
  State<UpdateDb> createState() => _UpdateDbState();
}

class _UpdateDbState extends State<UpdateDb> {
  DataBaseInstance databaseInstance = DataBaseInstance();
  TextEditingController nameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  @override
  void initState() {
    databaseInstance.database();
    nameController.text = widget.productModel!.name ?? "";
    categoryController.text = widget.productModel!.category ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit")),
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
              await databaseInstance.update(widget.productModel!.id!, {
                "name": nameController.text,
                "category": categoryController.text,
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
