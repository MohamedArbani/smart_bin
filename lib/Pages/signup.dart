import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartbins/commons/common.dart';
import 'package:smartbins/db/auth.dart';
import 'package:smartbins/db/users.dart';
import 'package:smartbins/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:smartbins/commons/loading.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  UserServices _userServices = UserServices();
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  TextEditingController _email = TextEditingController();
  TextEditingController _mobile = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _name = TextEditingController();
  bool hidePass = true;
  Auth auth = Auth();
  bool _loading = false;

  void _onLoading() {
    setState(() {
      _loading = true;
    });
  }

  void _signup() async {
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = UserProvider();
    var main_body = SafeArea(
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[350],
                    blurRadius: 20.0, // has the effect of softening the shadow
                  )
                ],
              ),
              child: Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            alignment: Alignment.topCenter,
                            child: Image.asset(
                              'images/logo.jpg',
                              width: 200.0,
                            )),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey.withOpacity(0.2),
                          elevation: 0.0,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: ListTile(
                              title: TextFormField(
                                controller: _name,
                                decoration: InputDecoration(
                                    hintText: "Full name",
                                    icon: Icon(Icons.person_outline),
                                    border: InputBorder.none),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "The name field cannot be empty";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey.withOpacity(0.2),
                          elevation: 0.0,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: ListTile(
                              title: TextFormField(
                                controller: _email,
                                decoration: InputDecoration(
                                    hintText: "Email",
                                    icon: Icon(Icons.alternate_email),
                                    border: InputBorder.none),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    Pattern pattern =
                                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                    RegExp regex = new RegExp(pattern);
                                    if (!regex.hasMatch(value))
                                      return 'Please make sure your email address is valid';
                                    else
                                      return null;
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey.withOpacity(0.2),
                          elevation: 0.0,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: ListTile(
                              title: TextFormField(
                                controller: _mobile,
                                decoration: InputDecoration(
                                    hintText: "Mobile Number",
                                    icon: Icon(Icons.phone),
                                    border: InputBorder.none),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "The name field cannot be empty";
                                  }else if (value.length < 10) {
                                    return "The mobile number has to be of 10 digits ";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey.withOpacity(0.2),
                          elevation: 0.0,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: ListTile(
                              title: TextFormField(
                                controller: _password,
                                obscureText: hidePass,
                                decoration: InputDecoration(
                                    hintText: "Password",
                                    icon: Icon(Icons.lock_outline),
                                    border: InputBorder.none),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "The password field cannot be empty";
                                  } else if (value.length < 6) {
                                    return "the password has to be at least 6 characters long";
                                  }
                                  return null;
                                },
                              ),
                              trailing: IconButton(
                                  icon: Icon(Icons.remove_red_eye),
                                  onPressed: () {
                                    setState(() {
                                      hidePass = false;
                                    });
                                  }),
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                        child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.black,
                            elevation: 0.0,
                            child: MaterialButton(
                              onPressed: () async {
                                _onLoading();
                                if (_formKey.currentState.validate()) {
                                  if (await user.signUp(_name.text, _email.text, _mobile.text,
                                          _password.text) ==
                                      true) {
                                    _signup();
                                    _key.currentState.showSnackBar(SnackBar(
                                        content:
                                            Text("Signed up successfully")));
//                                        return;
                                  } else if (!await user.signUp(_name.text,
                                      _email.text,_mobile.text, _password.text)) {
                                    _signup();
                                    _key.currentState.showSnackBar(SnackBar(
                                        content: Text("Sign up failed")));
//                                        return;
                                  }
                                }
                              },
                              minWidth: MediaQuery.of(context).size.width,
                              child: Text(
                                "Sign up",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                            )),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "I already have an account",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ))),

//                      Padding(
//                        padding: const EdgeInsets.all(16.0),
//                        child: Row(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[

//                            Padding(
//                              padding: const EdgeInsets.all(8.0),
//                              child: Text("Or sign up with", style: TextStyle(fontSize: 18,color: Colors.grey),),
//                            ),
//                            Padding(
//                              padding:
//                              const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
//                              child: Material(
//                                  child: MaterialButton(
//                                      onPressed: () async {
////                                        FirebaseUser user = await auth
////                                            .googleSignIn();
////                                        if (user == null) {
////                                          _userServices.createUser({
////                                            "name": user.displayName,
////                                            "photo": user.photoUrl,
////                                            "email": user.email,
////                                            "userId": user.uid
////                                          });
////                                        }
//
////                                        Navigator.pushReplacement(
////                                            context, MaterialPageRoute(builder: (context) => HomePage()));
//                                      },
//                                      child: Image.asset("images/g.png", width: 30,)
//                                  )),
//                            ),

//                          ],
//                        ),
//                      ),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
    return Scaffold(key: _key, body: _loading ? Loading() : main_body);
  }
}


