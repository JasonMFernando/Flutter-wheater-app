import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../model/user_model.dart';
import 'HomeScreen.dart';

class Registerscreen extends StatefulWidget {
  const Registerscreen({Key? key}) : super(key: key);

  @override
  _RegisterscreenState createState() => _RegisterscreenState();
}

class _RegisterscreenState extends State<Registerscreen> {
  //firebase auth
  final _auth = FirebaseAuth.instance;


  //form key
  final _formkey = GlobalKey<FormState>();

  final fNameController = new TextEditingController();
  final lNameController = new TextEditingController();
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();
  final confirmPasswordController = new TextEditingController();



  @override
  Widget build(BuildContext context) {

    //email field
    final Firstnamefield = TextFormField(
      autofocus: false,
      controller: fNameController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Incorrect input");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter valid name");
        }
        return null;
      },
      onSaved: (value) {
        fNameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        filled: true,
        fillColor: Colors.white,
        icon: Icon(Icons.account_circle),
        border: OutlineInputBorder(),
        hintText: 'First name',
        labelText: 'First name',
      ),
    );

    final Lastnamefield = TextFormField(
      autofocus: false,
      controller: lNameController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Incorrect input");
        }
        return null;
      },
      onSaved: (value) {
        lNameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        filled: true,
        fillColor: Colors.white,
        icon: Icon(Icons.account_circle),
        border: OutlineInputBorder(),
        hintText: 'Last name',
        labelText: 'Last name',
      ),
    );

    final  emailformfield= TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value){
        if (value!.isEmpty){
          return ("Enter email");
        }
        //reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9._]+.[a-z]").hasMatch(value)){
          return("Please Enter a valid Email");
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        filled: true,
        fillColor: Colors.white,
        icon: Icon(Icons.email),
        border: OutlineInputBorder(),
        hintText: 'Email',
        labelText: 'Email',
      ),
    );

    final  passwordformfield = TextFormField(
    autofocus: false,
    controller: passwordController,
    obscureText: true,  //hides the password
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Wrong Input");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter valid password");
        }
        return null;
      },
    onSaved: (value) {
    passwordController.text = value!;
    },
    textInputAction: TextInputAction.next,
    decoration: const InputDecoration(
    filled: true,
    fillColor: Colors.white,
    icon: Icon(Icons.vpn_key),
    border: OutlineInputBorder(),
    hintText: 'Password',
    labelText: 'Password',
    ),
    );

    final  confirmpassformfield= TextFormField(
    autofocus: false,
    controller: confirmPasswordController,
    obscureText: true,
      validator: (value) {
        if (confirmPasswordController.text != passwordController.text) {
          return ("wrong password");
        }
        return null;
      },
    onSaved: (value) {
    confirmPasswordController.text = value!;
    },
    textInputAction: TextInputAction.done,
    decoration: const InputDecoration(
    filled: true,
    fillColor: Colors.white,
    icon: Icon(Icons.vpn_key),
    border: OutlineInputBorder(),
    hintText: 'Confirm Password',
    labelText: 'Confirm Password',
    ),
    );

    //signup button
    final signupbutton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(38),
      color: Colors.blue,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery
            .of(context)
            .size
            .width,
        onPressed: () {
          signUp(emailController.text, passwordController.text);
        },
        child: Text(
          "Sign up",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.blueAccent,
     appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.blueGrey,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 45), Firstnamefield,
                    SizedBox(height: 20), Lastnamefield,
                    SizedBox(height: 20), emailformfield,
                    SizedBox(height: 20), passwordformfield,
                    SizedBox(height: 20), confirmpassformfield,
                    SizedBox(height: 20), signupbutton,
                    SizedBox(height: 15),
                  ],

                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  void signUp(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password)
          .then((value) =>
      {
        sendDetailsToFirestore()
      }).catchError((error) {
        Fluttertoast.showToast(msg: error!.message);
      });
    }
  }

  sendDetailsToFirestore() async {
    //calling out firestore
    //calling out user model
    //sending these values
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    Usermodel userAuth = Usermodel();
    //write data to firestore
    userAuth.email = user!.email;
    userAuth.uid = user.uid;
    userAuth.fname = fNameController.text;
    userAuth.lname = lNameController.text;
    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userAuth.toMap());
    Fluttertoast.showToast(msg: "Account created successfully");
    Navigator.pushReplacement(
        (context),
        MaterialPageRoute(builder: (context) => Homepage()),
        result: (route) => false
    );
  }
}
