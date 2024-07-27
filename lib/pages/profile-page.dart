import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:spoco_app/model/user_model.dart';
import 'package:spoco_app/utils/util.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AppUser user = AppUser.getAppUserEmptyObject();
  // AppUser user = Util.user!;

  final formKey = GlobalKey<FormState>();

  pickDateOfBirth() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime(2024),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        user.dateOfBirth = date;
        user.age = DateTime.now().year - date.year;
        print("User Age is: ${user.age}");
      });
    }
  }

  saveUserInFirebaseFirestore() {
    formKey.currentState!.save();
    print("User Data: ${user.toMap().toString()}");

    if (Util.UID != null && Util.UID.isNotEmpty) {
      try {
        FirebaseFirestore.instance
            .collection("users")
            .doc(Util.UID)
            .set(user.toMap())
            .then((value) {
          print("User Data: ${user.toMap().toString()} Saved in Firestore");
          // Optionally show a SnackBar or Toast
        });
      } catch (e) {
        print("Exception while saving user profile");
        print(e);
        // Optionally show a SnackBar or AlertDialog to inform the user of the error
      }
    } else {
      print("Error: Util.UID is null or empty.");
      // Handle the case where UID is null or empty
      // For example, show a SnackBar or AlertDialog to inform the user
    }
  }


Future<void> pickupProfileImage() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null) {
    File file = File(result.files.single.path!);
    print("File Path: ${file.path}");
    String fileName = result.files.single.name;

    final storageRef = FirebaseStorage.instance.ref();
    final profilePageRef = storageRef.child("profile-pics/${Util.UID}.png");

    try {
      // Upload file to Firebase Storage
      await profilePageRef.putFile(file);

      // Get the download URL of the uploaded profile image
      String downloadURL = await profilePageRef.getDownloadURL();

      print("Profile Image URL: $downloadURL");

      // Save the updated user data in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(Util.UID)
          .update({'profile_image_url': downloadURL});

      // Optionally, you can call any other function here if needed
      // saveUserInFirebaseFirestore();
    } catch (e) {
      print("Error uploading profile image: $e");
      // Optionally show a SnackBar or AlertDialog to inform the user of the error
    }
  } else {
    print("No file selected");
    // Optionally show a SnackBar or AlertDialog to inform the user
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
              key: formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: pickupProfileImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: user.imageURL.isEmpty
                          ? const NetworkImage(
                              "https://firebasestorage.googleapis.com/v0/b/spoco-app-9ad0a.appspot.com/o/toge.jfif?alt=media&token=217d112f-165b-40b5-82f3-a59bfd848360",
                            )
                          : NetworkImage(
                              user.imageURL,
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(

                     style:TextStyle(color: Colors.white),
                    decoration:
                     
                        const InputDecoration(labelText: "Enter Your Name",
                        prefixIcon: const Icon(Icons.person),
                        prefixIconColor: Colors.white,
                       labelStyle: TextStyle(
                    color:   const Color.fromARGB(255, 58, 243, 33) ,
                  ),
                        focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: const Color.fromARGB(255, 58, 243, 33)),
                  ),
                  
                        ),
                        
                    onSaved: (value) {
                      user.name = value!;
                    },
                  ),
                  TextFormField(
                      style:TextStyle(color: Colors.white),
                    decoration:
                        const InputDecoration(

                            prefixIconColor: Colors.white,
                            prefixIcon: Icon(Icons.add_ic_call),
                          labelText: "Enter Your Phone",
                           labelStyle: TextStyle(
                    color:   const Color.fromARGB(255, 58, 243, 33) ,
                  ),     focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: const Color.fromARGB(255, 58, 243, 33)),
                  ),
                        ),
                    initialValue: user.phone.isNotEmpty ? user.phone : "",
                    onSaved: (value) {
                      user.phone = value!;
                    },
                  ),


                  TextFormField(
                       style:TextStyle(color: Colors.white),
                    decoration:
                        const InputDecoration(labelText: "Enter Your Email",
                           prefixIconColor: Colors.white,
                            prefixIcon: Icon(Icons.mail),
                             labelStyle: TextStyle(
                    color:   const Color.fromARGB(255, 58, 243, 33) ,
                  ),     focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: const Color.fromARGB(255, 58, 243, 33)),
                  ),),
                    onSaved: (value) {
                      user.email = value!;
                    },
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Text("Select Gender:",style:TextStyle(color: Colors.white)),
                      ListTile(
                        title: const Text("Male",style: TextStyle(color:Color.fromARGB(255, 58, 243, 33),
                        fontWeight: FontWeight.bold,
                        fontSize: 16 ),),
                        leading: Radio<String>(
                          value: "Male",
                          groupValue: user.gender,
                          onChanged: (value) {
                            setState(() {
                              user.gender = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text("Female",style:TextStyle(color:Color.fromARGB(255, 58, 243, 33),
                        fontWeight: FontWeight.bold,
                        fontSize: 16 ),),
                        leading: Radio<String>(
                          value: "Female",
                          groupValue: user.gender,
                          onChanged: (value) {
                            setState(() {
                              user.gender = value!;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  DropdownButtonFormField<String>(
                    value: user.sports,
                    items: ["Select Sports", "Cricket", "Badminton", "Soccer",]
                        .map((element) {
                      return DropdownMenuItem<String>(
                          value: element, child: Text(element,style:TextStyle( backgroundColor:Colors.black,color:Color.fromARGB(255, 58, 243, 33))));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        user.sports = value!;
                      });
                    },
                  ),


                  
                  TextFormField(
                    style:TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        labelText: "Enter Your Address Line",
                         prefixIconColor: Colors.white,
                            prefixIcon: Icon(Icons.home),
                             labelStyle: TextStyle(
                    color:   const Color.fromARGB(255, 58, 243, 33) ,
                  ),     focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: const Color.fromARGB(255, 58, 243, 33)),
                  ),),
                    onSaved: (value) {
                      user.addressLine = value!;
                    },
                  ),
                  TextFormField(
                    style:TextStyle(color: Colors.white),
                    decoration:
                        const InputDecoration(labelText: "Enter Your City",
                        prefixIconColor: Colors.white,
                            prefixIcon: Icon(Icons.home_filled),
                             labelStyle: TextStyle(
                    color:   const Color.fromARGB(255, 58, 243, 33) ,
                  ),     focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: const Color.fromARGB(255, 58, 243, 33)),
                  ),
                        ),
                    onSaved: (value) {
                      user.city = value!;
                    },
                  ),
                  TextFormField(
                    style:TextStyle(color: Colors.white),
                    decoration:
                        const InputDecoration(labelText: "Enter Your State",
                         prefixIconColor: Colors.white,
                            prefixIcon: Icon(Icons.home_filled),
                             labelStyle: TextStyle(
                    color:   const Color.fromARGB(255, 58, 243, 33) ,
                  ),     focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: const Color.fromARGB(255, 58, 243, 33)),
                  ),
                        ),
                    onSaved: (value) {
                      user.state = value!;
                    },
                  ),
                  TextFormField(
                    style:TextStyle(color: Colors.white),
                    decoration:
                        const InputDecoration(labelText: "Enter Your Country",
                         prefixIconColor: Colors.white,
                            prefixIcon: Icon(Icons.home_filled),
                             labelStyle: TextStyle(
                    color:   const Color.fromARGB(255, 58, 243, 33) ,
                  ),     focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: const Color.fromARGB(255, 58, 243, 33)),
                  ),),
                    onSaved: (value) {
                      user.country = value!;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: user.role,
                    items: ["Select Role", "Player", "Coach", "TurfOwner"]
                        .map((element) {
                      return DropdownMenuItem<String>(
                          value: element, child: Text(element,style:TextStyle( backgroundColor:Colors.black,color:Color.fromARGB(255, 58, 243, 33))),);
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        user.role = value!;
                      });
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: user.highestPlayedLevel,
                    items: [
                      "Select Highest Played Level",
                      "Zonal",
                      "District",
                      "State"
                    ].map((element) {
                      return DropdownMenuItem<String>(
                          value: element, child: Text(element,style:TextStyle( backgroundColor:Colors.black,color:Color.fromARGB(255, 58, 243, 33))),);
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        user.highestPlayedLevel = value!;
                      });
                    },
                  ),
                  ListTile(
                    title: (Text(
                        "Date of Birth: ${user.dateOfBirth.day}/${user.dateOfBirth.month}/${user.dateOfBirth.year}",
                        style: TextStyle(color:Color.fromARGB(255, 58, 243, 33)))),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: pickDateOfBirth,
                  ),

                  SwitchListTile(
                    title: const Text("Have you Represented a Club ?",
                    style: TextStyle(color: Color.fromARGB(255, 58, 243, 33)),),
                    value: user.representClub,
                    onChanged: (value) {
                      setState(() {
                        user.representClub = value;
                      });
                    },
                  ),


                  TextFormField(
                     style:TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        labelText: "Enter Your Club Name",
                         prefixIconColor: Colors.white,
                            prefixIcon: Icon(Icons.home_filled),
                             labelStyle: TextStyle(
                    color:   const Color.fromARGB(255, 58, 243, 33) ,
                  ),     focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: const Color.fromARGB(255, 58, 243, 33)),
                  ),),
                    onSaved: (value) {
                      user.clubName = value!;
                    },
                  ),
                  TextFormField(
                       style:TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        labelText: "Enter Your School/College/Organization",
                
                         prefixIconColor: Colors.white,
                            prefixIcon: Icon(Icons.home_filled),
                             labelStyle: TextStyle(
                    color:   const Color.fromARGB(255, 58, 243, 33) ,
                  ),     focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: const Color.fromARGB(255, 58, 243, 33)),
                  ),),
                    onSaved: (value) {
                      user.schoolCollegeOrgName = value!;
                    },
                  ),
                  TextFormField(
                       style:TextStyle(color: Colors.white),
                    decoration:
                        const InputDecoration(labelText: "Enter Your Username",
                        
                         prefixIconColor: Colors.white,
                            prefixIcon: Icon(Icons.home_filled),
                             labelStyle: TextStyle(
                    color:   const Color.fromARGB(255, 58, 243, 33) ,
                  ),     focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: const Color.fromARGB(255, 58, 243, 33)),
                  ),),
                    onSaved: (value) {
                      // write the firebase query to check if the same username exists
                      user.username = value!;
                    },
                  ),
                  Padding(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton(
                      
                          onPressed: saveUserInFirebaseFirestore,
                          child: const Text("Save Profile",
                          style: TextStyle(color: Colors.black),)))
                ],
              )),
        ),
      ),
    );
  }
}

// 1. Explore SnackBar and show a message when profile is saved
// 2. Find the Bug, which is making data loss in scroll adjust the file upload code according to my code