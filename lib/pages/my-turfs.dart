import 'package:spoco_app/model/turf.dart';
import 'package:flutter/material.dart';
import 'package:spoco_app/services/turf-service.dart';

class MyTurfsPage extends StatefulWidget {
  const MyTurfsPage({super.key});

  @override
  State<MyTurfsPage> createState() => _MyTurfsPageState();
}

class _MyTurfsPageState extends State<MyTurfsPage> {
  final formKey = GlobalKey<FormState>();
  Turf turf = Turf.getEmptyObject();
 TurfService service =TurfService();

  bool showProgress = false;

  addTurfToDB() async {
    formKey.currentState!.save();
    String result = await service.addTurf(turf);
    if (result.contains("Successfully")) {
      setState(() {
        showProgress = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      
      body: showProgress
          ? const Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 8,
                    ),
                    Text("Please Wait..")
                  ]),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: turf.photos.isEmpty
                                ? const NetworkImage(
                                    "",
                                  )
                                : NetworkImage(
                                    turf.photos[0],
                                  ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                           style:TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                              labelText: "Enter Turf Name",
                              prefixIcon: const Icon(Icons.person),
                        prefixIconColor: Colors.white,
                       labelStyle: TextStyle(
                    color:   const Color.fromARGB(255, 58, 243, 33) ,
                  ),
                        focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: const Color.fromARGB(255, 58, 243, 33)),
                  ),),
                          onSaved: (value) {
                            turf.name = value!;
                          },
                        ),
                        TextFormField( style:TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                              labelText: "Enter Turf Description",
                              prefixIcon: const Icon(Icons.brush),
                        prefixIconColor: Colors.white,
                       labelStyle: TextStyle(
                    color:   const Color.fromARGB(255, 58, 243, 33) ,
                  ),
                        focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: const Color.fromARGB(255, 58, 243, 33)),
                  ),),
                          onSaved: (value) {
                            turf.description = value!;
                          },
                        ),
                        TextFormField( style:TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                              labelText: "Enter Your Address Line", prefixIcon: const Icon(Icons.home),
                        prefixIconColor: Colors.white,
                       labelStyle: TextStyle(
                    color:   const Color.fromARGB(255, 58, 243, 33) ,
                  ),
                        focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: const Color.fromARGB(255, 58, 243, 33)),
                  )
                              ),
                          onSaved: (value) {
                            turf.addressLine = value!;
                          },
                        ),
                        TextFormField( style:TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                              labelText: "Enter Your City",
                               prefixIcon: const Icon(Icons.home),
                        prefixIconColor: Colors.white,
                       labelStyle: TextStyle(
                    color:   const Color.fromARGB(255, 58, 243, 33) ,
                  ),
                        focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: const Color.fromARGB(255, 58, 243, 33)),
                  )),
                          onSaved: (value) {
                            turf.city = value!;
                          },
                        ),
                        TextFormField( style:TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                              labelText: "Enter Your State",
                               prefixIcon: const Icon(Icons.home),
                        prefixIconColor: Colors.white,
                       labelStyle: TextStyle(
                    color:   const Color.fromARGB(255, 58, 243, 33) ,
                  ),
                        focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: const Color.fromARGB(255, 58, 243, 33)),
                  )),
                          onSaved: (value) {
                            turf.state = value!;
                          },
                        ),
                        TextFormField( style:TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                              labelText: "Enter Your Country",
                               prefixIcon: const Icon(Icons.home),
                        prefixIconColor: Colors.white,
                       labelStyle: TextStyle(
                    color:   const Color.fromARGB(255, 58, 243, 33) ,
                  ),
                        focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: const Color.fromARGB(255, 58, 243, 33)),
                  )),
                          onSaved: (value) {
                            turf.country = value!;
                          },
                        ),
                        TextFormField( style:TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                              labelText: "Enter Turf Hourly Rental",
                               prefixIcon: const Icon(Icons.money_rounded),
                        prefixIconColor: Colors.white,
                       labelStyle: TextStyle(
                    color:   const Color.fromARGB(255, 58, 243, 33) ,
                  ),
                        focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: const Color.fromARGB(255, 58, 243, 33)),
                  )),
                          onSaved: (value) {
                            turf.rent = int.parse(value!);
                          },
                        ),
                        DropdownButtonFormField<String>( style:TextStyle(color: Colors.white),
                          value: turf.condition,
                          items:
                              ["Select Condition", "new", "Old"].map((element) {
                            return DropdownMenuItem<String>(
                                value: element, child: Text(element,style:TextStyle( backgroundColor:Colors.black,color:Color.fromARGB(255, 58, 243, 33))));
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              turf.condition = value!;
                            });
                          },
                        ),
                        TextFormField( style:TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                              labelText: "Enter Turf Capacity",
                               prefixIcon: const Icon(Icons.group),
                        prefixIconColor: Colors.white,
                       labelStyle: TextStyle(
                    color:   const Color.fromARGB(255, 58, 243, 33) ,
                  ),
                        focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: const Color.fromARGB(255, 58, 243, 33)),
                  )),
                          onSaved: (value) {
                            turf.capacity = int.parse(value!);
                          },
                        ),
                        DropdownButtonFormField<String>( style:TextStyle(color: Colors.white),
                          value: turf.visibility,
                          items: ["Select Visibility", "Day", "Night", "Both",]
                              .map((element) {
                            return DropdownMenuItem<String>(
                                value: element, child: Text(element,style:TextStyle( backgroundColor:Colors.black,color:Color.fromARGB(255, 58, 243, 33))));
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              turf.visibility = value!;
                            });
                          },
                        ),
                        Padding(
                            padding: const EdgeInsets.all(16),
                            child: ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    showProgress = true;
                                    addTurfToDB();
                                  });
                                },
                                child: const Text("Add New Turf",  style: TextStyle(color: Colors.black),)))
                      ],
                    )),
              ),
            ),
    );
  }
}