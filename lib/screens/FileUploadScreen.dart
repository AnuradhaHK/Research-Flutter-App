// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';

class ButtonStyles {
  static const double buttonHeight = 60.0;

  static ButtonStyle elevatedButtonStyle(Color backgroundColor) {
    return ElevatedButton.styleFrom(
      fixedSize: const Size.fromHeight(buttonHeight),
      textStyle: const TextStyle(fontSize: 16),
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Rounded corners
      ),
    );
  }
}

class FileUploadScreen extends StatefulWidget {
  const FileUploadScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
      backgroundColor: Colors.green, // Set the green background
      body: Column(
        children: [
          const SizedBox(height: 60), // Space from the top of the screen

          // Topic text, similar to the previous component
          const Center(
            child: Text(
              'File Upload Testing Page',
              textAlign: TextAlign.center, // Ensures text is centered
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 60), // Space between title and container

          // Expanded white container touching the bottom
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: Column(
                children: [
                  // Display file name if a file is selected
                  if (_file != null) ...[
                    Text(
                      'Selected File: $_fileName',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                        height: 20), // Space between text and buttons
                  ],

                  // Upload and Remove buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Upload File button with consistent style and blue color
                      ElevatedButton(
                        onPressed: _pickFile,
                        style: ButtonStyles.elevatedButtonStyle(Colors.blue),
                        child: const Text('Upload File'),
                      ),

                      const SizedBox(width: 20),

                      if (_file != null)
                        // Remove File button with consistent style and red color
                        ElevatedButton(
                          onPressed: _removeFile,
                          style: ButtonStyles.elevatedButtonStyle(Colors.red),
                          child: const Text('Remove File'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
