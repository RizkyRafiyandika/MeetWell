import 'package:fitness2/database_instace.dart';
import 'package:fitness2/models/-/product_model.dart';
import 'package:fitness2/pages/input_tester.dart';
import 'package:fitness2/pages/update_tester.dart';
import 'package:flutter/material.dart';

class DbTester extends StatefulWidget {
  const DbTester({super.key});

  @override
  State<DbTester> createState() => _DbTesterState();
}

class _DbTesterState extends State<DbTester> {
  DataBaseInstance databaseInstance = DataBaseInstance();

  Future _refresh() async {
    setState(() {});
  }

  @override
  void initState() {
    databaseInstance.database();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("helo database"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (builder) {
                    return InputDb();
                  }),
                ).then((value) {
                  setState(() {});
                });
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<ProductModel>>(
            future: databaseInstance.all(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data![index].name ?? ""),
                        subtitle: Text(snapshot.data![index].category ?? ""),
                        trailing: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (builder) {
                                  return UpdateDb(
                                      productModel: snapshot.data![index]);
                                }),
                              ).then((value) {
                                setState(() {});
                              });
                            },
                            icon: const Icon(Icons.edit)),
                      );
                    });
              } else {
                return const Center(
                    child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 60, 255, 0)));
              }
            }),
      ),
    );
  }
}
