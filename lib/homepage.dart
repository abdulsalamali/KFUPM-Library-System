import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ics324_project/BookCard.dart';
import 'package:ics324_project/BookDetails.dart';
import 'package:ics324_project/main.dart';
import 'Book.dart';
import 'BookDetails.dart';
import 'main.dart';

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  var controller1 = new TextEditingController();
  var controller2 = new TextEditingController();
  bool isFirstTime = false;
  List<DocumentSnapshot> datas = <DocumentSnapshot>[];
  //---------------------------------------------------------------------------

  dynamic myHandler() {
    var text = 'k';
    var text1 = 'k';
    for (var i = 0; i < datas.length; i++) {
      if (controller1.text == datas[i]['SSN'] ||
          controller2.text == datas[i]['Password']) {
        text = datas[i]['SSN'];
        text1 = datas[i]['Password'];
      }
    }
    if (controller1.text == text && controller2.text == text1) {
      return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const HomePage(),
              settings: RouteSettings(
                  // passes an argument to change the route dynamically.
                  arguments: text)));
    } else {
      return showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Wrong Credentials'),
                content: const Text('Please try again'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ));
    }
  }

  getData() async {
    if (!isFirstTime) {
      QuerySnapshot snap =
          await FirebaseFirestore.instance.collection("User").get();
      isFirstTime = true;
      setState(() {
        datas.addAll(snap.docs);
      });
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        primaryColor: Colors.amberAccent,
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.white),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Home page'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 50, right: 50, top: 75),
              child: TextField(
                controller: controller1,
                decoration: InputDecoration(
                    hintText: 'Enter ID',
                    hintStyle: TextStyle(color: Colors.black)),
                style: TextStyle(color: Colors.black, fontSize: 16.0),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(left: 50, right: 50),
              child: TextField(
                obscureText: true,
                controller: controller2,
                decoration: InputDecoration(
                    hintText: 'Enter password',
                    hintStyle: TextStyle(color: Colors.black)),
                style: TextStyle(color: Colors.black, fontSize: 16.0),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                myHandler();
              },
              child: Text('Log in'),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ))),
            ),
          ],
        ),
      ),
    );
  }
}
