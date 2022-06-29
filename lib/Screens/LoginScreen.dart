import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jtest/Screens/RegisterScreen.dart';

import 'HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();

  //bool isChecked = false; // check the password is visible or not

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  //firebase
  final _auth  = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {

    //email field
    final emailFiled = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value){
        if (value!.isEmpty){
          return ("Enter your  email");
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

    final passwordFiled = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      // hide password
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter valid password");
        }
        return null;
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      // pasword eka pena eka nathi karanna

      decoration: const InputDecoration(
        filled: true,
        fillColor: Colors.white,
        icon: Icon(Icons.vpn_key),
        border: OutlineInputBorder(),
        hintText: 'Password',
        labelText: 'Password',
      ),
    );


    final loginButton = Material(
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
          /*Navigator.pushReplacement(
            context , MaterialPageRoute(builder: (context) => Homepage()));*/
          signIn(emailController.text, passwordController.text);
        },
        child: Text(
          "Login",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold
          ),
        ),
      ),
    );




    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.blueGrey,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 45), emailFiled,
                    SizedBox(height: 25), passwordFiled,
                    SizedBox(height: 35), loginButton,
                    //SizedBox(height: 35),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Don't have an account? "),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context  , MaterialPageRoute(
                                builder: (context) =>
                                    Registerscreen()));
                          },
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                          ),
                        )
                        /*GestureDetector(onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUp())

                          );
                        },
                          child: Text("signup",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),*/
                      ],
                    )
                  ],

                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  //login
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth.signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
        Fluttertoast.showToast(msg: "Login Successful"),
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Homepage())),
      }).catchError((error) {
        Fluttertoast.showToast(msg: error!.message);
      });
    }
  }
}
