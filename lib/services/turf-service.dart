import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spoco_app/model/turf.dart';

class TurfService {
  CollectionReference? turfCollection;

  TurfService() {
    turfCollection = FirebaseFirestore.instance.collection("turfs");
  }

  // Add a Turf to Firestore
  Future<String> addTurf(Turf turf) async {
    try {
      await turfCollection!.add(turf.toMap());
      print('[TurfService] Turf Created');
    } catch (e) {
      print('[TurfService] Error adding turf: $e');
    }

    return "Turf Added Successfully";
  }

  // Update a Turf in Firestore
  updateTurf(Turf turf, String docId) async {
    try {
      await turfCollection!.doc(docId).update(turf.toMap());
      print('Turf Updated with ID: $docId');
    } catch (e) {
      print('Error updating turf: $e');
    }
  }

  // Delete a Turf from Firestore
  deleteTurf(String docId) async {
    try {
      await turfCollection!.doc(docId).delete();
      print('Turf Deleted with ID: $docId');
    } catch (e) {
      print('Error deleting turf: $e');
    }
  }

  // Get all Turfs from Firestore
  Future<List<Turf>> getTurfs() async {
    List<Turf> turfs = [];

    try {
      QuerySnapshot querySnapshot = await turfCollection!.get();
      querySnapshot.docs.forEach((doc) {
        turfs.add(Turf.fromMap(doc.data() as Map<String, dynamic>));
      });
    } catch (e) {
      print('Error fetching turfs: $e');
    }

    return turfs;
  }
}