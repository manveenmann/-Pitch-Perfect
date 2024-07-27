import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:spoco_app/pages/list-my-turf.dart';
import 'package:spoco_app/pages/list-turfs.dart';
import 'package:spoco_app/pages/my-turfs.dart';

import 'package:spoco_app/pages/profile-page.dart';
import 'package:spoco_app/utils/util.dart';

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition();
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  getLocationOfUser() async {
    Position position = await _determinePosition();
    // Current Location of User
    print("Location/Position is: ${position.latitude}, ${position.longitude}");
    Util.geoPoint = GeoPoint(position.latitude, position.longitude);
  }

  List<Widget> widgets = [
    const Text("Home Page"), // 0
     const MyTurfsPage(), // 1
       const ListTurfs(),
    const ListMyTurfs(),
    const Text("Players Page"), // 2
    const ProfilePage() // 3
  ];

  List<BottomNavigationBarItem> navBaritems = [
    const BottomNavigationBarItem(
      backgroundColor: Colors.black,
        icon: Icon(
          Icons.home,
        ),
        label: "Home"),
    const BottomNavigationBarItem(
        icon: Icon(Icons.sports_football), label: "Turfs",),
    const BottomNavigationBarItem(
        icon: Icon(Icons.sports_handball), label: "Players"),
    const BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
  ];

  logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed("/");
  }

  onItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    getLocationOfUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("SPOCO",style: TextStyle(color:Color.fromARGB(255, 58, 243, 33),
      fontSize: 16,backgroundColor: Colors.black),), actions: [
        IconButton(
            onPressed: () {
              logout(context);
            },
            icon: const Icon(Icons.logout))
      ]),
      body: Center(child: widgets[selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        items: navBaritems,
        currentIndex: selectedIndex,
        selectedItemColor:Color.fromARGB(255, 58, 243, 3),
        unselectedItemColor: Colors.white,
        onTap: onItemSelected,
      ),
    );
  }
}