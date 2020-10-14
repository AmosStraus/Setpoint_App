import 'package:flutter/material.dart';
import 'package:set_point_attender/models/auth.dart';
import 'package:set_point_attender/shared/constants.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.red[200],
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.red[600],
              title: Text("סט פוינט בע\"מ"),
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Header //
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          "lib/assets/setpoint_logo.png",
                          width: 150,
                          height: 150,
                          fit: BoxFit.fitHeight,
                          alignment: Alignment.centerLeft,
                        ),
                        Text(
                          "התחברות \n למערכת",
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  // user name
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 25,
                    ),
                    child: TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: "אימייל"),
                      style: TextStyle(fontSize: 22.0),
                      textDirection: TextDirection.ltr,
                      validator: (val) =>
                          val.isEmpty ? "הכנס כתובת מייל" : null,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                    ),
                    child: TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: "סיסמה"),
                      style: TextStyle(fontSize: 22.0),
                      textDirection: TextDirection.ltr,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                      obscureText: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 100),
                    child: ButtonTheme(
                      height: 80.0,
                      child: RaisedButton(
                        color: Colors.brown[900],
                        child: Text(
                          "התחברות",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() => loading = true);
                            print('$email x $password');
                            dynamic result =
                                await _auth.signInWithEmailAndPassword(
                                    email.trim(), password.trim());
                            if (result == null && this.mounted) {
                              setState(() {
                                error = "שם משתמש או סיסמה לא תקינים";
                                loading = false;
                              });
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  // FOR ERRORS
                  error != ""
                      ? Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            error,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          );
  }
}
