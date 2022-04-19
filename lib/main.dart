import 'package:dblocal/view/todo_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/boxes.dart';
import 'model/todo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //----------Uncomment when debugging on phone------------------
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  //------------------------------------------------------------

  Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  await Hive.openBox<Todo>(HiveBoxex.todo);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static final String title = 'Shopping List';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: MyLoginPage(),
    );
  }
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({Key? key}) : super(key: key);

  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final username_controller = TextEditingController();
  final password_controller = TextEditingController();

  late SharedPreferences logindata;
  late bool newuser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping List"),
      ),
      body: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Login",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: username_controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  obscureText: true,
                  controller: password_controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              RaisedButton(
                textColor: Colors.white,
                color: Colors.blue,
                onPressed: () {
                  String username = username_controller.text;
                  String password = password_controller.text;
                  if (username != '' && password != '') {
                    print('Successfull');
                    logindata.setBool('login', false);
                    logindata.setString('username', username);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => TodoListScreen(item: 'My Shopping List')));
                  }
                },
                child: Text("Log-In"),
              ),
            ]),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    check_if_already_login();
  }

  void check_if_already_login() async {
    logindata = await SharedPreferences.getInstance();
    newuser = (logindata.getBool('login') ?? true);
    print(newuser);
    if (newuser == false) {
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) =>TodoListScreen(item: 'My Shopping List')));
    }
  }

  void dispose() {
// Clean up the controller when the widget is disposed.
    username_controller.dispose();
    password_controller.dispose();
    super.dispose();
  }
}
