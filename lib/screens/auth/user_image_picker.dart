import 'dart:io';

import 'package:flutter/material.dart';
import "package:image_picker/image_picker.dart";

class UserimagePicker extends StatefulWidget {
  const UserimagePicker({super.key, required this.onGetImage});

  final void Function(File image) onGetImage;

  @override
  State<UserimagePicker> createState() {
    return _UserimagePickerState();
  }
}

class _UserimagePickerState extends State<UserimagePicker> {
  File? _selectedImage;

  void _getImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 150,
      imageQuality: 50,
    );

    if (pickedImage == null) return;

    setState(() {
      _selectedImage = File(pickedImage.path);
    });
    
    widget.onGetImage(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    // print(_selectedImage);
    return Column(
      children: [
        // if (_selectedImage != null)
          // Container(
          //   width: 150,
          //   height: 150,
          //   decoration: BoxDecoration(
          //     shape: BoxShape.circle,
          //     color: Colors.green,
          //     border: BoxBorder.all(
          //       color: Theme.of(context).colorScheme.primary,
          //       width: 1,
          //     ),
          //   ),
          //   child: CircleAvatar(
          //     radius: 20,
          //     backgroundColor: Colors.grey,
          //     foregroundImage: FileImage(_selectedImage!),
          //   ),
          // ),
          Stack(
            children: [
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  shape: BoxShape.circle,
                  border: BoxBorder.all(
                    color: Theme.of(context).colorScheme.primary,
                    width:2,
                  ),
                ),
              ),
              Positioned(
                top: 5,
                left: 5,
                right: 5,
                bottom: 5,
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey,
                  foregroundImage: _selectedImage != null ? FileImage(_selectedImage!) : null,
                ),
              ),
            ],
          ),
        TextButton.icon(
          onPressed: _getImage,
          label: Text(
            "Add Image",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          icon: Icon(Icons.image),
        ),
      ],
    );
  }
}
