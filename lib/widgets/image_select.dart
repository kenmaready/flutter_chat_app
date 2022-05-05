import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ImageSelect extends StatefulWidget {
  const ImageSelect({Key? key, required this.getImageFn}) : super(key: key);

  final void Function(File) getImageFn;

  @override
  State<ImageSelect> createState() => _ImageSelectState();
}

class _ImageSelectState extends State<ImageSelect> {
  File? _pickedImage;

  void _selectImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile Ximage = await _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 50) as XFile;
    File image = File(Ximage.path);
    setState(() {
      _pickedImage = image;
    });
    widget.getImageFn(image);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CircleAvatar(
        radius: 45,
        backgroundColor: Colors.grey,
        backgroundImage:
            _pickedImage == null ? null : FileImage(_pickedImage as File),
      ),
      TextButton.icon(
          icon: const Icon(Icons.camera),
          label: const Text('select profile pic'),
          onPressed: _selectImage)
    ]);
  }
}
