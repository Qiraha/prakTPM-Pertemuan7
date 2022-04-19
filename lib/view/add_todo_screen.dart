import 'package:dblocal/model/boxes.dart';
import 'package:dblocal/model/todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddTodoScreen extends StatefulWidget {
  AddTodoScreen({Key? key}) : super(key: key);

  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  late SharedPreferences logindata;
  late String username;

  @override
  void initState() {
    super.initState();
    initial();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata.getString('username')!;
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  validated() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _onFormSubmit();
      print("Form Validated");
    } else {
      print("Form not validated");
      return;
    }
  }

  late String item;
  late String quantity;

  void _onFormSubmit() {
    Box<Todo> todoBox = Hive.box<Todo>(HiveBoxex.todo);
    todoBox.add(Todo(item: item, quantity: quantity));
    Navigator.of(context).pop();
    print(todoBox);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Todo'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                      autofocus: false,
                      decoration: InputDecoration(labelText: 'Item'),
                      validator: (String? value) {
                        if (value == null || value.trim().length == 0) {
                          return "Required";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        item = value;
                      }),
                  TextFormField(
                      autofocus: false,
                      decoration: InputDecoration(labelText: 'Quantity'),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      // Only numbers can be entered
                      validator: (String? value) {
                        if (value == null || value.trim().length == 0) {
                          return "Required";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        quantity = value;
                      }),
                  ElevatedButton(
                      onPressed: () {
                        validated();
                      },
                      child: Text('Add Item'))
                ],
              ),
            )),
      ),
    );
  }
}
