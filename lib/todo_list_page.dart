import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'config/app_routes.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final _formKey = GlobalKey<FormState>();
  String title = "";
  String desc = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todos"),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.kAuthenticationPage, (route) => false);
            },
            icon: const FaIcon(FontAwesomeIcons.rightFromBracket),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("MyTodos").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Something went wrong"),
              );
            } else if (snapshot.hasData || snapshot.data != null) {
              return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    QueryDocumentSnapshot<Object?>? documentSnapshot =
                        snapshot.data?.docs[index];
                    return Card(
                      elevation: 4.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text((documentSnapshot != null)
                              ? (documentSnapshot["todoTitle"])
                              : ""),
                          subtitle: Text((documentSnapshot != null)
                              ? (documentSnapshot["todoDesc"])
                              : ""),
                          trailing: InkWell(
                              onTap: () {
                                _removeTodo(documentSnapshot!["todoTitle"]);
                              },
                              child: const Icon(
                                Icons.delete_forever,
                                color: Colors.red,
                              )),
                        ),
                      ),
                    );
                  });
            } else {
              return Container();
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                title: const Text("Add Todo"),
                content: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          decoration:
                              const InputDecoration(label: Text("Title")),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter a valid title!';
                            }
                            title = value;
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(label: Text("Description")),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter a valid title!';
                            }
                            desc = value;
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              child: const Text("Add"),
                              onPressed: () {
                                _createTodo();
                              },
                            ),
                            ElevatedButton(
                              child: const Text("Cancel"),
                              onPressed: () =>
                                  Navigator.of(context, rootNavigator: true)
                                      .pop(),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _createTodo() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(title);
    Map<String, String> todoList = {"todoTitle": title, "todoDesc": desc};
    try {
      await documentReference.set(todoList);
      Navigator.of(context, rootNavigator: true).pop();
    } catch (e) {}
  }

  void _removeTodo(String mTitle) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(mTitle);
    try {
      await documentReference.delete();
    } catch (e) {}
  }
}
