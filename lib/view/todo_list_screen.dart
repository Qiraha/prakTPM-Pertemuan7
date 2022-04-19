import 'package:dblocal/model/boxes.dart';
import 'package:dblocal/model/todo.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'add_todo_screen.dart';

class TodoListScreen extends StatefulWidget {
  final String item;

  const TodoListScreen({Key? key, required this.item}) : super(key: key);

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
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

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              logindata.setBool('login', true);
              Navigator.pushReplacement(context,
                  new MaterialPageRoute(builder: (context) => MyLoginPage()));
            },
            child: Text("Logout ${username}"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Todo>(HiveBoxex.todo).listenable(),
        builder: (context, Box<Todo> box, _) {
          if (box.values.isEmpty) {
            return Center(
              child: Text('Todo listing is Empty'),
            );
          }
          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              Todo? res = box.getAt(index);
              return Dismissible(
                background: Container(
                  color: Colors.red,
                ),
                key: UniqueKey(),
                onDismissed: (direction) {
                  res!.delete();
                },
                child: ListTile(
                  title: Text(res!.item),
                  subtitle: Text(res!.quantity),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Item',
        child: Icon(Icons.add),
        onPressed: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTodoScreen(),
              ))
        },
      ),
    );
  }
}
