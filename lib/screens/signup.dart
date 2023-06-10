import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _emailController = TextEditingController();

  String? name = "";
  String? email = "";
  String? url = "";

  // 이메일/비밀번호로 Firebase에 회원가입
  Future<bool> signUpWithEmail(
      String name, String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text)
          .then((value) {
        if (value.user!.email == null) {
        } else {
          Navigator.pop(context);
        }
        return value;
      });
      String uid = userCredential.user!.uid;
      FirebaseAuth.instance.currentUser?.sendEmailVerification();
      await FirebaseFirestore.instance.collection('user').add({
        "uid": uid,
        "name": name,
        "email": email,
        "url": url != ""
            ? url
            : "https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-social-media-user-portrait-176256935.jpg",
        "registeredDate": DateTime.now(),
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The password provided is too weak'),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The account already exists for that email'),
          ),
        );
      } else {
        print(e.code);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please retry ; ${e.code}"),
          ),
        );
      }
    } catch (e) {
      print('끝');
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              const SizedBox(height: 100),
              const Center(
                child: Text(
                  'SIGN UP',
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
              const SizedBox(height: 35),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: '    Name',
                  filled: true,
                  fillColor: Color.fromARGB(255, 237, 237, 237),
                  prefixIcon: Icon(
                    Icons.person,
                    size: 24,
                    color: Color.fromARGB(255, 104, 104, 104),
                  ),
                  border: InputBorder.none,
                  prefix: SizedBox(width: 15.0),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: '    Email',
                  filled: true,
                  fillColor: Color.fromARGB(255, 237, 237, 237),
                  prefixIcon: Icon(
                    Icons.mail,
                    size: 24,
                    color: Color.fromARGB(255, 104, 104, 104),
                  ),
                  border: InputBorder.none,
                  prefix: SizedBox(width: 15.0),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a email address.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: '    Create Password',
                  filled: true,
                  fillColor: Color.fromARGB(255, 237, 237, 237),
                  prefixIcon: Icon(
                    Icons.lock,
                    size: 24,
                    color: Color.fromARGB(255, 104, 104, 104),
                  ),
                  border: InputBorder.none,
                  prefix: SizedBox(width: 15.0),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmpasswordController,
                decoration: const InputDecoration(
                  labelText: '    Confirm Password',
                  filled: true,
                  fillColor: Color.fromARGB(255, 237, 237, 237),
                  prefixIcon: Icon(
                    Icons.lock,
                    size: 24,
                    color: Color.fromARGB(255, 104, 104, 104),
                  ),
                  border: InputBorder.none,
                  prefix: SizedBox(width: 15.0),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password.';
                  }
                  if (value != _passwordController.text) {
                    return 'Confirm Password doesn\'t match Password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 35),
              Container(
                width: 350,
                height: 65,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton(
                  child: const Text(
                    'SIGN UP',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    String name = _usernameController.text;
                    String email = _emailController.text;
                    String password = _passwordController.text;

                    // Perform login logic here
                    if (_formKey.currentState!.validate()) {
                      // 폼이 유효한 경우 로그인 페이지로 이동
                      signUpWithEmail(name, email, password);
                    } else {
                      print("비밀번호 다름");
                    }
                  },
                ),
              ),
              const SizedBox(height: 150),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account?',
                    style: TextStyle(
                      color: Color.fromRGBO(142, 142, 142, 1),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Color.fromRGBO(142, 142, 142, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Color.fromRGBO(142, 142, 142, 1),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/login', (route) => false);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
