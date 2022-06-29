import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Searchpage extends StatefulWidget {
  const Searchpage({Key? key}) : super(key: key);

  @override
  _SearchpageState createState() => _SearchpageState();
}

class _SearchpageState extends State<Searchpage> {
  int x = 0;
  User? user = FirebaseAuth.instance.currentUser;
  GuestBookMessage loggedInUser = GuestBookMessage();

  @override
  void initState() {
    super.initState();
    //getloca();
    FirebaseFirestore.instance
        .collection("favourite")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = GuestBookMessage.fromMap(value.data());
      setState(() {});
    });
  }
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.blue),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ),
    body: ListView(
    children: <Widget>[
      GuestBook(
        addMessage: (message) =>
            addMessageToGuestBook(message, user, x), messages: [],
      ),
      SizedBox(
        height: 10,
      ),
      Text("${loggedInUser.message}",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      )

    ],
    ),
        ),
    );
  }
}

class GuestBook extends StatefulWidget {
  const GuestBook({required this.addMessage, required this.messages});
  final FutureOr<void> Function(String message) addMessage;
  final List<GuestBookMessage> messages;
  @override
  _GuestBookState createState() => _GuestBookState();
}
class _GuestBookState extends State<GuestBook> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_GuestBookState');
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Leave a message',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your message to continue';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 8),
            MaterialButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await widget.addMessage(_controller.text);
                  _controller.clear();
                }
              },
              child: Row(
                children: const [
                  Icon(Icons.send),
                  SizedBox(width: 4),
                  Text('SEND'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

addMessageToGuestBook(String message, User? user , int x) async {
  x+=1;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  GuestBookMessage guestBookMessage = GuestBookMessage();
  //write data to firestore
  guestBookMessage.name = user!.email;
  guestBookMessage.uid = user.uid;
  guestBookMessage.message = message;
  await firebaseFirestore
      .collection('favourite')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .set({ (x).toString() : guestBookMessage.toMap()
  },SetOptions(merge: true)).then((value)
  { });
}
class GuestBookMessage {
  String? name;
  String? message;
  String? uid;
  GuestBookMessage({ this.uid, this.name, this.message});
  factory GuestBookMessage.fromMap(map) {
    return GuestBookMessage(
      //get data from the firebase
      uid: map['userId'],
      message: map['text'],
      name: map['name'],
    );
  }
  Map<String, dynamic> toMap() {
    //send data
    return {
      'text': message,
      'name': FirebaseAuth.instance.currentUser!.email,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    };
  }
}
