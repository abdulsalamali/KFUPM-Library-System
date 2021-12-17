// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';

class RPage extends StatelessWidget {
  final String title;
  final String author;
  final String copies;
  final String imageURL;
  RPage(
      {required this.title,
      required this.author,
      required this.copies,
      required this.imageURL});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Image(
          image: NetworkImage(imageURL),
        ),
        Text(author),
        Row(children: [Text(author), Text(copies)]),
        Row(
          children: [
            RaisedButton(
              child: Text(
                "Renew",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              onPressed: () => null,
            ),
            RaisedButton(
              child: Text(
                "Return",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              onPressed: () => null,
            )
          ],
        ),
      ]),
    );
  }
}
