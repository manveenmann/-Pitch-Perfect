import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spoco_app/model/user_model.dart';
import 'package:spoco_app/utils/util.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      setState(() {
        _isEmailFocused = _emailFocusNode.hasFocus;
      });
    });
    _passwordFocusNode.addListener(() {
      setState(() {
        _isPasswordFocused = _passwordFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  login() async {
  String email = _emailController.text.trim();
  String password = _passwordController.text.trim();

  if (email.isNotEmpty && password.isNotEmpty) {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("User signed in with: Email: $email | Password: $password");
      print("Credential: $credential");
      print("UID: ${credential.user!.uid}");

      final docRef = FirebaseFirestore.instance
          .collection("users")
          .doc(credential.user!.uid);
      final doc = await docRef.get();
      
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        Util.user = AppUser.fromMap(data);
        print("User data fetched: $data");
        Navigator.of(context).pushReplacementNamed("/home");
      } else {
        print("Document does not exist.");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else {
        print('FirebaseAuthException: ${e.message}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  } else {
    print("Missing Details: Email: $email | Password: $password");
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/login.png', height: 400, width: 700), // Update the path as needed
                SizedBox(height: 12),
                TextField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIconColor: Colors.white,
                    labelText: 'E-Mail',
                    hintText: 'youremail@gmail.com',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: const Color.fromARGB(255, 58, 243, 33)),
                    ),
                    labelStyle: TextStyle(
                      color: _isEmailFocused ? const Color.fromARGB(255, 58, 243, 33) : Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  style: TextStyle(color: Colors.white),
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIconColor: Colors.white,
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: const Color.fromARGB(255, 58, 243, 33)),
                    ),
                    labelStyle: TextStyle(
                      color: _isPasswordFocused ? const Color.fromARGB(255, 58, 243, 33) : Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: login,
                  child: Text('SIGN IN'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    textStyle: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
