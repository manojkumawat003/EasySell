import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';
//import 'package:firebase_storage/firebase_storage.dart';

class ImageInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ImageInput();
  }
}

class _ImageInput extends State<ImageInput> {
  File _imageFile;

  void _getImage(ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 400.0, maxHeight: 400.0)
        .then((File image) {
      setState(() {
        _imageFile = image;
      });
      Navigator.pop(context);
      //  print(image);
    });
  }

  // void _uploadImage() {
  //   final StorageReference storageRef =
  //       FirebaseStorage.instance.ref().child("myImage.jpg");
  //   final StorageUploadTask uploadTask = storageRef.putFile(_imageFile);
  // }

  void _openImagePicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            // decoration: BoxDecoration(
            //   color: Colors.teal,
            //   gradient: LinearGradient(
            //     begin: Alignment.topRight,
            //     end: Alignment.bottomLeft,
            //     // Add one stop for each color. Stops should increase from 0 to 1
            //     stops: [0.1, 0.5, 0.7, 0.9],
            //     colors: [
            //       // Colors are easy thanks to Flutter's Colors class.
            //       Colors.deepPurple[800],
            //       Colors.deepPurple[700],
            //       Colors.deepPurple[600],
            //       Colors.deepPurple[400],
            //     ],
            //   ),
            // ),

            height: 250,
            // margin: EdgeInsets.only(top: 10),
            child: Column(
              children: <Widget>[
                Text(
                  'Select an option',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'oswald',
                      fontSize: 20.0),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                FloatingActionButton.extended(
                  label: Text('Open Camera'),
                  icon: Icon(Icons.camera),
                  onPressed: () {
                    _getImage(ImageSource.camera);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                FloatingActionButton.extended(
                  label: Text('Open Gallary'),
                  icon: Icon(Icons.image),
                  onPressed: () {
                    _getImage(ImageSource.gallery);
                  },
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        OutlineButton(
          borderSide:
              BorderSide(color: Theme.of(context).accentColor, width: 2.0),
          onPressed: () {
            _openImagePicker();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.add_a_photo,
                color: Theme.of(context).accentColor,
              ),
              SizedBox(
                width: 20.0,
              ),
              Text(
                'Add Image',
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        _imageFile == null
            ? Text('Please select an image!')
            : Image.file(
                _imageFile,
                width: MediaQuery.of(context).size.width,
                height: 300,
                filterQuality: FilterQuality.high,
                alignment: Alignment.center,
                fit: BoxFit.cover,
              ),
      ],
    );
  }
}
