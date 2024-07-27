import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spoco_app/model/user_model.dart';
import 'package:spoco_app/utils/util.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;
  bool _isNameFocused = false;

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
    _nameFocusNode.addListener(() {
      setState(() {
        _isNameFocused = _nameFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  register() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      try {
        // 1. Create user in Firebase Authentication Module
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // 2. Get the UID of the newly created user
        String uid = credential.user!.uid;
        Util.UID = uid;

        print("User Created with : Email: $email | Password: $password");
        print("Credential: $credential");
        print("UID: $uid");

        var user = AppUser.getAppUserEmptyObject();
        user.name = name;
        user.email = email;

        Map<String, dynamic> userData = user.toMap();

        // 4. Use Firebase Firestore to create a new Document in the users collection
        FirebaseFirestore.instance.collection("users").doc(uid).set(userData).then((value) {
          Util.user = user;
          Navigator.of(context).pushReplacementNamed("/home");
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    } else {
      print("Missing Details: Name: $name | Email: $email | Password: $password");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/register.png', height: 350, width: 750),
                const SizedBox(height: 12),
                TextField(
                  style: TextStyle(color: Colors.white),
                  controller: _nameController,
                  focusNode: _nameFocusNode,
                  decoration: InputDecoration(
                    prefixIconColor: Colors.white,
                    labelText: "Name",
                    prefixIcon: Icon(Icons.person),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: const Color.fromARGB(255, 58, 243, 33)),
                    ),
                    labelStyle: TextStyle(
                      color: _isNameFocused ? const Color.fromARGB(255, 58, 243, 33) : Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  style: TextStyle(color: Colors.white),
                  controller: _emailController,
                  focusNode: _emailFocusNode,
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
                const SizedBox(height: 12),
                TextField(
                  style: TextStyle(color: Colors.white),
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
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
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: register,
                  child: const Text("SIGN UP"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    textStyle: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/login");
                  },
                  child: const Text(
                    "Existing user? Log in here",
                    style: TextStyle(color: Colors.white),
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

