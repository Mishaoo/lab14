import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';

void main() => runApp(PhotoApp());

class PhotoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PhotoScreen(),
    );
  }
}

class PhotoScreen extends StatefulWidget {
  @override
  _PhotoScreenState createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  final MethodChannel _channel = MethodChannel('com.example.photo_app/date');
  File? _image;
  String _currentDate = 'Немає даних';

  Future<void> _getCurrentDate() async {
    try {
      final String result = await _channel.invokeMethod('getCurrentDate');
      setState(() {
        _currentDate = result;
      });
    } on PlatformException catch (e) {
      setState(() {
        _currentDate = 'Помилка: ${e.message}';
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Photo App')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _getCurrentDate,
            child: Text('Отримати поточну дату'),
          ),
          Text('Поточна дата: $_currentDate'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _pickImage,
            child: Text('Зробити фото'),
          ),
          _image != null
              ? Image.file(_image!)
              : Text('Фото ще не зроблено'),
        ],
      ),
    );
  }
}
