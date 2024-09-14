import 'package:flutter/material.dart';
import 'package:research_project_app/screens/button01_screen.dart';
import 'package:research_project_app/screens/FileUploadScreen.dart';

class ButtonStyles {
  static const double buttonHeight = 60.0; // Increase button height
  static const double buttonWidth = 425.0; // Set constant button width

  static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    fixedSize: const Size(buttonWidth, buttonHeight),
    textStyle: const TextStyle(fontSize: 16),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: ElevatedButton(
                style: ButtonStyles.elevatedButtonStyle,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Button01Screen()),
                  );
                },
                child: const Text('NETWORK REQUEST BUTTON'),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                style: ButtonStyles.elevatedButtonStyle,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FileUploadScreen()),
                  );
                },
                child: const Text('File Upload'),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                style: ButtonStyles.elevatedButtonStyle,
                onPressed: () {},
                child: const Text('CRUD Operation'),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                style: ButtonStyles.elevatedButtonStyle,
                onPressed: () {},
                child: const Text('Button 04'),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                style: ButtonStyles.elevatedButtonStyle,
                onPressed: () {},
                child: const Text('Button 05'),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                style: ButtonStyles.elevatedButtonStyle,
                onPressed: () {},
                child: const Text('Button 06'),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                style: ButtonStyles.elevatedButtonStyle,
                onPressed: () {},
                child: const Text('Button 07'),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                style: ButtonStyles.elevatedButtonStyle,
                onPressed: () {},
                child: const Text('Button 08'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
