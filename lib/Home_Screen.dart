import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image; 
  final ImagePicker _picker =
      ImagePicker(); 


  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        preferredCameraDevice: CameraDevice.rear,
      );
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path); 
        });
        
        Navigator.pushNamed(context, '/result', arguments: _image);
      }
    } catch (e) {
      print("Error al seleccionar la imagen: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reconocimiento de Medicamentos"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.camera),
              icon: Icon(Icons.camera),
              label: Text("Tomar foto"),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: Icon(Icons.photo_library),
              label: Text("Seleccionar desde la galería"),
            ),
            if (_image != null) ...[
              SizedBox(height: 20),
              Image.file(_image!,
                  height: 200), 
            ],
          ],
        ),
      ),
    );
  }
}
