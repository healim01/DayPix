import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';
import 'app.dart';

class UserModel {
  final String uid;
  String name;
  final String url;
  final String email;
  UserModel({required this.uid, required this.name, required this.url, required this.email});
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? id = "";
  String? name = "";
  String? email = "";
  String? url = "";

  /* Sign In Email */
  Future<void> signInWithEmail(String email, String password) async {

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // 로그인 성공 후의 추가 작업을 수행하고 페이지 이동 등의 동작을 구현
      final User? user = credential.user;
      print(user.toString());
      setState(() {
        id = user?.uid;
        email = email;
        url = url!= ""? url : "https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-social-media-user-portrait-176256935.jpg";
      });
      print(id);
      print(email);
      print(url);
      print(name);
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
          settings: RouteSettings(
            arguments: UserModel(
              uid: id ?? "",
              name: name ?? "",
              email: email ?? "",
              url: url ?? "",
            ),
          ),
        ),
      );
      print("Login 성공");
      
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('해당 이메일로 등록된 사용자가 없습니다.'),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('잘못된 비밀번호입니다.'),
          ),
        );
      }
    }
    
  }
  /* Sign In google */
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();  
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final UserCredential authResult = await _auth.signInWithCredential(credential);
    final User? user = authResult.user;

    setState(() {
      id = user?.uid;
      name = user?.displayName;
      email = user?.email;
      url = user?.photoURL;
    });

    print(id);
    print(name);
    print(email);
    print(url);

    // 'user' collection에 없는 user면 (uid 같은게 없을 경우) user에 add.
    final userRef = FirebaseFirestore.instance.collection('user');
    final userQuery = await userRef.where('uid', isEqualTo: id).get();

    if (userQuery.docs.isEmpty) {
      await userRef.add({
        "uid": id,
        "name": name,
        "email": email,
        "url": url != "" ? url : "https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-social-media-user-portrait-176256935.jpg",
        "registeredDate": DateTime.now(),
      });
    }
   
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
        settings: RouteSettings(
          arguments: UserModel(
            uid: id ?? "",
            name: name ?? "",
            email: email ?? "",
            url: url ?? "",
          ),
        ),
      ),
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void googleSignOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();

    setState(() {
      id = "";
      name = "";
      email = "";
      url = "";
    });

    print("User Sign Out");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            const SizedBox(height: 100),
            const Text(
              'LOGIN',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0)),
            ),
            SizedBox(height: 35),
            TextField(
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
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: '    Password',
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
                  'LOGIN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  String email = _emailController.text;
                  String password = _passwordController.text;
                  // Perform login logic here
                  try {
                    signInWithEmail(email, password);
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     content: Text('로그인 성공'),
                    //   ),
                    // );
                    
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('해당 이메일로 등록된 사용자가 없습니다.'),
                        ),
                      );
                    } else if (e.code == 'wrong-password') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('잘못된 비밀번호입니다.'),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
            const SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: const Divider(
                      color: Color.fromRGBO(142, 142, 142, 1),
                      height: 1,
                    ),
                  ),
                ),
                const Text(
                  'or',
                  style: TextStyle(
                    color: Color.fromRGBO(142, 142, 142, 1),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: const Divider(
                      color: Color.fromRGBO(142, 142, 142, 1),
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor:Colors.black,
                    fixedSize: const Size(350, 65),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // 버튼을 직사각형으로 설정
                  ),
                ),
              onPressed: () {
                signInWithGoogle();
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Image(
                      image: AssetImage("assets/google_logo.png"),
                      height: 24.0,
                      width: 24,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 24, right: 8),
                      child: Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 120),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children : [
                const Text(
                  'Not a member?',
                    style: TextStyle(
                      color: Color.fromRGBO(142, 142, 142, 1),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                TextButton(
                  child: const Text(
                    'Sign up now',
                    style: TextStyle(
                      color: Color.fromRGBO(142, 142, 142, 1),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: Color.fromRGBO(142, 142, 142, 1), 
                    ),
                  ),
                  onPressed: () {
                    print("signup press");
                    Navigator.pushNamed(context, '/signup');             
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
