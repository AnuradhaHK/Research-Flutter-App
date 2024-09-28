import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import '../db/database_helper.dart';
import '../models/uploaded_file.dart';

class FileUploadScreen extends StatefulWidget {
  const FileUploadScreen({super.key});

  @override
  _FileUploadScreenState createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  String? _selectedFilePath;
  UploadedFile? _selectedFile;
  List<UploadedFile> uploadedFiles = [];
  final TextEditingController _fileNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUploadedFiles();
  }

  // Load files from SQLite database
  void _loadUploadedFiles() async {
    final files = await DatabaseHelper.getFiles();
    setState(() {
      uploadedFiles = files;
    });
  }

  // Pick a file using FilePicker
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      String filePath = result.files.single.path!;
      String fileName = path.basename(filePath);

      setState(() {
        _selectedFilePath = filePath;
        _fileNameController.text =
            fileName; // Display the file name in the textbox
      });
    }
  }

  // Save the selected file to the database and measure the time taken
  void _saveFile() async {
    if (_selectedFilePath != null && _fileNameController.text.isNotEmpty) {
      Stopwatch stopwatch = Stopwatch()..start(); // Start the stopwatch

      await DatabaseHelper.insertFile(
          _fileNameController.text, _selectedFilePath!);

      stopwatch.stop(); // Stop the stopwatch after the operation is complete
      int timeTaken =
          stopwatch.elapsedMicroseconds; // Get the time taken in microseconds

      setState(() {
        _fileNameController.clear(); // Clear the textbox after saving
        _selectedFilePath = null;
        _loadUploadedFiles(); // Reload the list after insertion
      });

      // Show success message with the time taken
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Successfully saved the file. Time for the save: $timeTaken µs')),
      );
    }
  }

  // Remove the selected file from the database and measure the time taken
  void _removeSelectedFile() async {
    if (_selectedFile != null) {
      Stopwatch stopwatch = Stopwatch()..start(); // Start the stopwatch

      await DatabaseHelper.deleteFile(_selectedFile!.id);

      stopwatch.stop(); // Stop the stopwatch after the operation is complete
      int timeTaken =
          stopwatch.elapsedMicroseconds; // Get the time taken in microseconds

      setState(() {
        _selectedFile = null;
        _fileNameController.clear(); // Clear the textbox
        _loadUploadedFiles(); // Refresh the list after deletion
      });

      // Show success message with the time taken
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Successfully deleted the file. Time for the deletion: $timeTaken microseconds')),
      );
    }
  }

  // Select a file when clicked in the list
  void _selectFile(UploadedFile file) {
    setState(() {
      _selectedFile = file;
      _fileNameController.text =
          file.fileName; // Display the file name in the textbox
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Uploader'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // TextField for displaying selected file name
            TextField(
              controller: _fileNameController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Selected File',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Buttons for Upload, Save, and Remove File
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _pickFile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Upload File'),
                ),
                ElevatedButton(
                  onPressed: _saveFile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Save File'),
                ),
                if (_selectedFile != null)
                  ElevatedButton(
                    onPressed: _removeSelectedFile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Remove File'),
                  ),
              ],
            ),
            const SizedBox(height: 36),

            // Table header or "No files uploaded" message
            if (uploadedFiles.isNotEmpty)
              const Text(
                'Uploaded Files',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            else
              const Text(
                'No files uploaded yet',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 10),

            // Table for listing uploaded files
            if (uploadedFiles.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: uploadedFiles.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(uploadedFiles[index].fileName),
                      onTap: () {
                        _selectFile(uploadedFiles[
                            index]); // Display the file in the textbox
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
