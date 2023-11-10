// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

import 'config.dart';

class DashboardPage extends StatefulWidget {
  final token;
  const DashboardPage({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late String? userId;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _desController = TextEditingController();
  bool isNotValidate = false;
  List? item;
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    Map<String, dynamic> jsonDecodeToken = JwtDecoder.decode(widget.token);
    userId = jsonDecodeToken['id'];
    gettodos(userId);

    print(userId);
  }

  createTodo() async {
    if (_titleController.text.isNotEmpty && _desController.text.isNotEmpty) {
      var regBody = {
        "userId": userId,
        "title": _titleController.text.trim(),
        "des": _desController.text.trim()
      };
      var response = await http.post(Uri.parse(storetodo),
          headers: {"content-type": "application/json"},
          body: jsonEncode(regBody));
      print(response.body);

      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse['status']);
      if (jsonResponse['status']) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("sucessful Added data")));
        _titleController.clear();
        _desController.clear();
        Navigator.pop(context);
        gettodos(userId);
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => LoginPage()));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("something wrong")));
      }
    } else {
      setState(() {
        isNotValidate = true;
      });
    }
  }

  gettodos(userId) async {
    var regBody = {
      "userId": userId,
    };
    var response = await http.post(Uri.parse(gettodo),
        headers: {"content-Type": "application/json"},
        body: jsonEncode(regBody));
    print(response.body);

    var jsonResponse = jsonDecode(response.body);
    item = jsonResponse["success"];

    setState(() {});
    print("data aayo:${item}");
  }

  void deleteItem(id) async {
    var regBody = {
      "id": id,
    };
    var response = await http.post(Uri.parse(deletetodo),
        headers: {"content-type": "application/json"},
        body: jsonEncode(regBody));
    print(response.body);

    var jsonResponse = jsonDecode(response.body);

    print(jsonResponse['status']);
    // if (jsonResponse['status']) {}
    if (jsonResponse["status"]) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("sucessful Added data")));

      gettodos(userId);
      print("data aayo:${item}");
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("something wrong")));
    }
    print(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // ignore: unnecessary_null_comparison
        body: item == null
            ? null
            : ListView.builder(
                itemCount: item!.length,
                itemBuilder: (context, int index) {
                  return Slidable(
                    // Specify a key if the Slidable is dismissible.
                    key: const ValueKey(0),

                    // The start action pane is the one at the left or the top side.
                    startActionPane: ActionPane(
                      // A motion is a widget used to control how the pane animates.
                      motion: const ScrollMotion(),

                      // A pane can dismiss the Slidable.
                      dismissible: DismissiblePane(onDismissed: () {}),

                      // All actions are defined in the children parameter.
                      children: [
                        // A SlidableAction can have an icon and/or a label.
                        SlidableAction(
                          onPressed: (BuildContext context) {
                            print("${item![index]["_id"]}");
                            print(item);
                            deleteItem("${item![index]["_id"]}");
                          },
                          backgroundColor: Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),

                    // The end action pane is the one at the right or the bottom side.
                    endActionPane: ActionPane(
                      motion: ScrollMotion(),
                      children: const [
                        SlidableAction(
                          // An action can be bigger than the others.
                          flex: 2,
                          onPressed: doNothing,
                          backgroundColor: Color(0xFF7BC043),
                          foregroundColor: Colors.white,
                          icon: Icons.archive,
                          label: 'Archive',
                        ),
                      ],
                    ),

                    // The child of the Slidable is what the user sees when the
                    // component is not dragged.
                    child: Card(
                        child: ListTile(
                      title: Text(
                        '${item![index]['title']}',
                      ),
                      subtitle: Text(
                        '${item![index]['des']}',
                      ),
                    )),
                  );
                }),
        floatingActionButton: FloatingActionButton(onPressed: () {
          showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return Container(
                    height: 300,
                    color: Colors.amber,
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _titleController,
                            decoration: InputDecoration(
                                errorText: isNotValidate
                                    ? "Enter Proper Detail"
                                    : null,
                                hintText: "Enter title",
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 10))),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _desController,
                            decoration: InputDecoration(
                                errorText: isNotValidate
                                    ? "Enter Proper Detail"
                                    : null,
                                hintText: "Enter Description",
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 10))),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Cancel")),
                            ElevatedButton(
                                onPressed: () {
                                  createTodo();
                                },
                                child: Text("Save"))
                          ],
                        )
                      ],
                    )));
              });
        }));
  }
}

void doNothing(BuildContext context) {}
