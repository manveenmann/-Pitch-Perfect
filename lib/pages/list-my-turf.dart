import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spoco_app/model/turf.dart';
import 'package:flutter/material.dart';

class ListMyTurfs extends StatefulWidget {
  const ListMyTurfs({super.key});

  @override
  _ListMyTurfsState createState() => _ListMyTurfsState();
}

class _ListMyTurfsState extends State<ListMyTurfs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed("/add-turf");
          },
          child: const Icon(
            Icons.add,
            color: Colors.amber,
          )),
      body: StreamBuilder<QuerySnapshot>(
        // where is the data ? stream is representing data as snapshots -> real time documents
        stream: FirebaseFirestore.instance.collection("turfs").snapshots(),
        // snapshot contains data in real time
        // data means collection (turfs) of documents
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Something Went Wrong. Please Try Again",
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          // Length of collection is 0 i.e. no document
          if (!snapshot.hasData) {
            return const Center(
              child: Text("No Turf Found"),
            );
          }

          // List of Turf Objects
          List<Turf> turfs = snapshot.data!.docs
              .map((doc) => Turf.fromMap(doc.data() as Map<String, dynamic>))
              .toList();

          return ListView(
            children: turfs
                .map((turf) => Card(
                      margin: EdgeInsets.all(12),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            turf.photos.isNotEmpty
                                ? Image.network(
                                    turf.photos[0],
                                    height: 200,
                                    fit: BoxFit.cover,
                                  )
                                : Container(),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    turf.name,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    turf.addressLine,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    turf.city,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    turf.state,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  const Divider(),
                                  Text(
                                    "\u20b9 ${turf.rent} per hour",
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.blue),
                                  ),
                                  const Divider(),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.info_outlined,
                                              color: Colors.amber,
                                            )),
                                        IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.edit_outlined,
                                              color: Colors.amber,
                                            )),
                                        IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.delete_outline_outlined,
                                              color: Colors.amber,
                                            )),
                                        IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.calendar_today_outlined,
                                              color: Colors.amber,
                                            ))
                                      ])
                                ],
                              ),
                            ),
                          ]),
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}

/*
  Assignment:
    1. List My Turfs (Condition with UID)

*/