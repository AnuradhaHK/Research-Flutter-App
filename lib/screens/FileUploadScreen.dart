import 'dart:html' as html;
import 'package:flutter/material.dart';

class FileUploadScreen extends StatefulWidget {
  const FileUploadScreen({super.key});

  @override
  _FileUploadScreenState createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  String? _fileName;
  html.File? _file;

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

  void _removeFile() {
    setState(() {
      _file = null;
      _fileName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Upload'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_file != null) ...[
              Text('Selected File: $_fileName'),
              const SizedBox(height: 20),
            ],
            ElevatedButton(
              onPressed: _pickFile,
              child: const Text('Upload File'),
            ),
            const SizedBox(height: 20),
            if (_file != null)
              ElevatedButton(
                onPressed: _removeFile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Remove File'),
              ),
          ],
        ),
      ),
    );
  }
}
