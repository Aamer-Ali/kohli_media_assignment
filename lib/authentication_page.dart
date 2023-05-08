import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kohli_media_assignment/config/app_routes.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final _formKey = GlobalKey<FormState>();
  bool showSignupForm = false;
  var email = "";
  var password = "";
  var confirmPassword = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              showSignupForm
                  ? const Text(
                      "Register",
                      style: TextStyle(
                          fontSize: 45.0, fontWeight: FontWeight.bold),
                    )
                  : const Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 45.0, fontWeight: FontWeight.bold),
                    ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                decoration: const InputDecoration(label: Text("Email")),
                validator: (value) {
                  if (value!.isEmpty ||
                      !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                    return 'Enter a valid email!';
                  }
                  email = value;
                  return null;
                },
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(label: Text("Password")),
                validator: (value) {
                  if (value!.isEmpty || value!.length < 6) {
                    return 'Password must contains at least 6 character';
                  }
                  password = value;
                  return null;
                },
              ),
              const SizedBox(
                height: 25,
              ),
              Visibility(
                visible: showSignupForm,
                child: TextFormField(
                  obscureText: true,
                  decoration:
                      const InputDecoration(label: Text("Confirm Password")),
                  validator: (value) {
                    if (value != password) {
                      return 'Password did not match';
                    }
                    confirmPassword = value!;
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              showSignupForm
                  ? ElevatedButton(
                      child: const Text("Register"),
                      onPressed: () => _registerNewUser(),
                    )
                  : ElevatedButton(
                      child: const Text("Login"),
                      onPressed: () => _loginUser(),
                    ),
              showSignupForm
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account!",
                          style: TextStyle(fontSize: 15.0),
                        ),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                showSignupForm = !showSignupForm;
                              });
                            },
                            child: const Text("Login"))
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account!",
                          style: TextStyle(fontSize: 15.0),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              showSignupForm = !showSignupForm;
                            });
                          },
                          child: const Text("Register"),
                        )
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void _registerNewUser() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    Navigator.of(context).pushReplacementNamed(AppRoutes.kTodoListPage);
  }

  void _loginUser() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    try {
      var userCredentials = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.of(context).pushReplacementNamed(AppRoutes.kTodoListPage);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        //Todo : Show Error For User Not Found
      } else if (e.code == 'wrong-password') {
        //Todo : Show Error For Wrong Password
      }
    }
  }
}

