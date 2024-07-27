import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class MultiImageUpload extends StatefulWidget {
  const MultiImageUpload({super.key});

  @override
  _MultiImageUploadState createState() => _MultiImageUploadState();
}

class _MultiImageUploadState extends State<MultiImageUpload> {
  // Create an Empty List of Files, which will store multiple image paths
  List<File> imageFiles = [];
  List<String> imageURLs = [];

  pickupMultipleImages() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        imageFiles = result.paths.map((path) => File(path!)).toList();
      });
    } else {
      print("User canceled the picker");
    }
  }

  uploadMultipleImages() async {
    print("uploadMultipleImages Started...");
    final storageRef = FirebaseStorage.instance.ref();

    for (File file in imageFiles) {
      try {
        print("Uploading Image ${file.path.split("/").last}");
        // String str = "/Users/ishant/Downloads/image1.png"
        // String fileName = str.split("/").last;
        // Last Path Segment is -> File Name

        final turfPicRef =
            storageRef.child("turf-pics/${file.path.split("/").last}");
        print("file is: $file");
        await turfPicRef.putFile(file);
        String url = await turfPicRef.getDownloadURL();
        imageURLs.add(url);
        print("Image Url is: ${url}");
      } catch (e) {
        print("Something Went Wrong...");
        print(e);
      }
    }
    print("uploadMultipleImages Finished...");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: const Text("Upload Multiple Images"),
      ),*/
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: pickupMultipleImages,
                child: const Text("Select Multiple Images")),
            const SizedBox(
              height: 12,
            ),
            imageFiles.isNotEmpty
                ? Wrap(
                    children: imageFiles
                        .map((file) => Padding(
                            padding: const EdgeInsets.all(
                              8,
                            ),
                            child: Image.file(
                              file,
                              width: 100,
                              height: 100,
                            )))
                        .toList())
                : const Text("No Images Selected"),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
                onPressed: uploadMultipleImages,
                child: const Text("Upload Multiple Images")),
          ],
        ),
      ),
    );
  }
}

       /*children: [
                Padding(padding: EdgeInsets.all(8,), child: Image.file(imageFiles[0], width: 100, height: 100,)),
                Padding(padding: EdgeInsets.all(8,), child: Image.file(imageFiles[1], width: 100, height: 100,)),
                Padding(padding: EdgeInsets.all(8,), child: Image.file(imageFiles[2], width: 100, height: 100,)),
              ],*/      
       