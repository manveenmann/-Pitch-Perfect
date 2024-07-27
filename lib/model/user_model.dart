/*
  User Data:
  
  name, phone, email,
  sport (choice/text),
  addressLine,
  location (latitude and longitude),
  country, state, city,
  role Player: 1       (drop down)
        Coach: 2
        Ground/Turf Owner: 3
  dob
  age
  Highest Level Played (zonal, district, state, national, international) (Optional) (drop down)
  Representing any Club (Yes/No) boolean
  Club Name (text) (Optional)
  School/College/Organization 
  username,
  profileImage (url)


*/

/// Developer: Ishant (@ishantk)
/// Email: ishant@auribises.com
/// Organization: Auribises Technologies
/// Department: Software R&D
/// CreatedOn: 9th July, 2024

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spoco_app/utils/util.dart';


class AppUser {
  // Attributes
  String name; // textfield
  String phone; // textfield
  String email; // textfield
  String gender; // Radio Button to choose from male or female
  String sports; // dropdown to choose from cricket, soccer, badminton
  String addressLine; // textfield
  String city; // textfield
  String state; // textfield
  String country; // textfield
  GeoPoint location; // latitude and longitude -> Pick from Location API
  String role; // dropdown to choose from player, coach, turfOwner
  String
      highestPlayedLevel; // dropdown to choose from zonal, district, state, state
  DateTime dateOfBirth; // date picker dialog
  int age; // compute automatically from date picker dialog
  bool representClub; // textfield
  String clubName; // textfield
  String schoolCollegeOrgName; // textfield
  String username; // textfield
  String imageURL; // Image Picker -> Circle Avatar at top
  DateTime createdOn; // DateTime.now()

  // Constructor
  AppUser({
    required this.name,
    required this.phone,
    required this.email,
    required this.gender,
    required this.sports,
    required this.addressLine,
    required this.city,
    required this.state,
    required this.country,
    required this.location,
    required this.role,
    required this.highestPlayedLevel,
    required this.dateOfBirth,
    required this.age,
    required this.representClub,
    required this.clubName,
    required this.schoolCollegeOrgName,
    required this.username,
    required this.imageURL,
    required this.createdOn,
  });

  static AppUser getAppUserEmptyObject() {
    return AppUser(
      name: "",
      phone: "",
      email: "",
      gender: "",
      sports: "Select Sports",
      addressLine: "",
      city: "",
      state: "",
      country: "",
      location: Util.geoPoint,
      role: "Select Role",
      highestPlayedLevel: "Select Highest Played Level",
      dateOfBirth: DateTime.now(),
      age: 0,
      representClub: false,
      clubName: "",
      schoolCollegeOrgName: "",
      username: "",
      imageURL: "",
      createdOn: DateTime.now(),
    );
  }

  // toMap function
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'sports': sports,
      'addressLine': addressLine,
      'city': city,
      'state': state,
      'country': country,
      'location': location,
      'role': role,
      'highestPlayedLevel': highestPlayedLevel,
      'dateOfBirth': dateOfBirth,
      'age': age,
      'representClub': representClub,
      'clubName': clubName,
      'schoolCollegeOrgName': schoolCollegeOrgName,
      'username': username,
      'imageURL': imageURL,
      'createdOn': createdOn,
    };
  }

  // fromMap function
  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      name: map['name'] ?? "",
      phone: map['phone'] ?? "",
      email: map['email'] ?? "",
      gender: map['gender'] ?? "",
      sports: map['sports'] ?? "",
      addressLine: map['addressLine'] ?? "",
      city: map['city'] ?? "",
      state: map['state'] ?? "",
      country: map['country'] ?? "",
      location: map['location'],
      role: map['role'] ?? "",
      highestPlayedLevel: map['highestPlayedLevel'] ?? "",
      dateOfBirth: (map['dateOfBirth'] as Timestamp).toDate(),
      age: map['age'],
      representClub: map['representClub'] ?? "",
      clubName: map['clubName'] ?? "",
      schoolCollegeOrgName: map['schoolCollegeOrgName'] ?? "",
      username: map['username'] ?? "",
      imageURL: map['imageURL'] ?? "",
      createdOn: (map['createdOn'] as Timestamp).toDate(),
    );
  }
}