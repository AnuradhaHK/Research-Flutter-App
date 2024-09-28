// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../database_helper.dart';

class FileUploadScreen extends StatefulWidget {
  const FileUploadScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FileUploadScreenState createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  String? _fileName;
  html.File? _file;
  DatabaseHelper _dbHelper = DatabaseHelper();

  void _pickFile() {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = '.txt,.jpg,.png,.pdf'; // Example of file types
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      if (files!.isNotEmpty) {
        _file = files.first;
        setState(() {
          _fileName = _file!.name;
        });
      }
    });
  }

  Future<void> _saveFile() async {
    if (_file != null) {
      final reader = html.FileReader();
      reader.readAsArrayBuffer(_file!);
      reader.onLoadEnd.listen((event) async {
        Uint8List data = reader.result as Uint8List;
        await _dbHelper.insertFile(_fileName!, data);
        setState(() {
          _file = null;
          _fileName = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File saved successfully!')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Uploader'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_file != null) ...[
              Text(
                'Selected File: $_fileName',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _pickFile,
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Upload File'),
                ),
                const SizedBox(width: 20),
                if (_file != null)
                  ElevatedButton(
                    onPressed: _saveFile,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text('Save File'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
