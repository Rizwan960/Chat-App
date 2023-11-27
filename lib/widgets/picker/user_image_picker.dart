import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File image) pickImageFn;
  const UserImagePicker({super.key, required this.pickImageFn});

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;
  void _imagePicker() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    setState(() {
      _pickedImage = File(pickedFile!.path);
    });
    widget.pickImageFn(File(_pickedImage!.path));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage!) : null,
        ),
        ElevatedButton.icon(
          onPressed: _imagePicker,
          icon: const Icon(Icons.image),
          label: const Text('Add Image'),
        )
      ],
    );
  }
}