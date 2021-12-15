import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ics324_project/BookCard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (false) {
    FirebaseFirestore.instance.settings = Settings(
        host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          primaryColor: Colors.amberAccent,
          textTheme: TextTheme(
            bodyText2: TextStyle(color: Colors.white),
          ),
        ),
        home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isFirstTime = false;
  List<DocumentSnapshot> datas = <DocumentSnapshot>[];

  getData() async {
    if (!isFirstTime) {
      QuerySnapshot snap =
          await FirebaseFirestore.instance.collection("Book").get();
      isFirstTime = true;
      setState(() {
        datas.addAll(snap.docs);
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              FloatingActionButton(
                onPressed: getData,
                tooltip: 'Increment',
                child: Icon(Icons.add),
              ),
              Icon(Icons.book),
              SizedBox(
                width: 10,
              ),
              Text("LYBSIS")
            ],
          ),
        ),
        body: !isFirstTime
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: datas.length,
                itemBuilder: (context, index) {
                  return BookCard(
                      title: datas[index]['title'],
                      author: datas[index]['author'],
                      copies: datas[index]['copies'],
                      imageURL: datas[index]['imageURL']);
                },
              ));
  }
}
