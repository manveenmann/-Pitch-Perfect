import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spoco_app/utils/util.dart';

class Turf {
  // Attributes
  String name;
  String description;
  String addressLine;
  String city;
  String state;
  String country;
  GeoPoint location;
  List<String> photos;
  int rent;
  String condition;
  int capacity;
  String visibility;
  String uid;
  DateTime createdOn;

  // Constructor
  Turf({
    required this.name,
    required this.description,
    required this.addressLine,
    required this.city,
    required this.state,
    required this.country,
    required this.location,
    required this.photos,
    required this.rent,
    required this.condition,
    required this.capacity,
    required this.visibility,
    required this.uid,
    required this.createdOn,
  });

  // Convert Turf object to Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'addressLine': addressLine,
      'city': city,
      'state': state,
      'country': country,
      'location': location,
      'photos': photos,
      'rent': rent,
      'condition': condition,
      'capacity': capacity,
      'visibility': visibility,
      'uid': uid,
      'createdOn': createdOn,
    };
  }

  // Create Turf object from Map
  static Turf fromMap(Map<String, dynamic> map) {
    return Turf(
      name: map['name'],
      description: map['description'],
      addressLine: map['addressLine'],
      city: map['city'],
      state: map['state'],
      country: map['country'],
      location:
          map['location'], // Assuming GeoPoint is directly stored in Firestore
      photos: List<String>.from(map['photos']),
      rent: map['rent'],
      condition: map['condition'],
      capacity: map['capacity'],
      visibility: map['visibility'],
      uid: map['uid'],
      createdOn: (map['createdOn'] as Timestamp)
          .toDate(), // Convert Timestamp to DateTime
    );
  }

  static Turf getEmptyObject() {
    return Turf(
      name: "",
      description: "",
      addressLine: "",
      city: "",
      state: "",
      country: "",
      location: Util.geoPoint,
      photos: [],
      rent: 0,
      condition: "Select Condition",
      capacity: 0,
      visibility: "Select Visibility",
      uid: Util.UID,
      createdOn: DateTime.now(),
    );
  }
}