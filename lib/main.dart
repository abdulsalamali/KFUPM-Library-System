import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ics324_project/recipe_card.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (false) {
    FirebaseFirestore.instance.settings = Settings(
        host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);
  }
  runApp(const HomePage());
}

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   var _books;

//   void _onPressed() {
//     FirebaseFirestore.instance
//         .collection('Book')
//         .get()
//         .then((QuerySnapshot querySnapshot) {
//       querySnapshot.docs.forEach((doc) {
//         _books.add(doc.data());
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Row(
//             children: [
//               Icon(Icons.restaurant),
//               SizedBox(
//                 width: 10,
//               ),
//               Text("Food Recipe")
//             ],
//           ),
//         ),
//         body: ListView.builder(
//           itemCount: _books.length,
//           itemBuilder: (context, index) {
//             return RecipeCard(
//                 title: _books[index]['title'],
//                 author: _books[index]['author'],
//                 copies: _books[index]['copies'],
//                 imageURL: _books[index]['imageURL']);
//           },
//         ));
//   }
// }

//---------------------------------------------------------------------------------------------
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List _books = [];

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('Book')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _books.add(doc.data());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Icon(Icons.restaurant),
              SizedBox(
                width: 10,
              ),
              Text("Food Recipe")
            ],
          ),
        ),
        body: ListView.builder(
          itemCount: _books.length,
          itemBuilder: (context, index) {
            return RecipeCard(
                title: _books[index]['title'],
                author: _books[index]['author'],
                copies: _books[index]['copies'],
                imageURL: _books[index]['imageURL']);
          },
        ));
  }
}
