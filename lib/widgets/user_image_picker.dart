import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File image) selectedImage;
  const UserImagePicker({super.key, required this.selectedImage});

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? imageFile;
  void pickImage() async{
    final image = await ImagePicker().pickImage(source: ImageSource.camera,maxWidth: 300);
    if(image == null){
      return ;
    }
    setState(() {
      imageFile = File(image.path);
      widget.selectedImage(imageFile!);
    });

  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: pickImage,
      child: imageFile != null ? CircleAvatar(
        backgroundColor: Colors.teal,
        radius: 75,
        
        foregroundImage: FileImage(imageFile!) ,
      ): const CircleAvatar(
    backgroundColor: Colors.teal,
    radius: 75,

    foregroundImage: AssetImage('assets/sample_user.png'),
    )
    );
  }
}
