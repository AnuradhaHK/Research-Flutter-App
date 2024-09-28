import 'package:flutter/material.dart';
import 'MatrixMultiplicationScreen.dart';
import 'PrimeNumberGeneratorScreen.dart';
import 'NetworkRequestScreen.dart';
import 'FileUploadScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green, // Set the green background
      body: Column(
        children: [
          const SizedBox(height: 60), // Space from the top of the screen

          // Topic text, similar to the image design
          const Center(
            child: Text(
              'Flutter',
              textAlign: TextAlign.center, // Ensures text is centered
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold),
            ),
          ),

          const Center(
            child: Text(
              'Performance Test App',
              textAlign: TextAlign.center, // Ensures text is centered
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 60), // Space between title and container

          // Expanded white container touching the bottom
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Network Request Section
                    const Text(
                      'Network Request',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(350, 60),
                          textStyle: const TextStyle(fontSize: 16),
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const NetworkRequestScreen(),
                            ),
                          );
                        },
                        child: const Text('Call API Request'),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // File Upload Section
                    const Text(
                      'Upload a File',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(350, 60),
                          textStyle: const TextStyle(fontSize: 16),
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FileUploadScreen(),
                            ),
                          );
                        },
                        child: const Text('File Uploader'),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Matrix Multiplication Section
                    const Text(
                      'Matrix Multiplication',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(350, 60),
                          textStyle: const TextStyle(fontSize: 16),
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const MatrixMultiplierScreen(),
                            ),
                          );
                        },
                        child: const Text('Multiply'),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Prime Numbers Generation Section
                    const Text(
                      'Prime Number Generation',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(350, 60),
                          textStyle: const TextStyle(fontSize: 16),
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const PrimeNumbersGeneratorPage(),
                            ),
                          );
                        },
                        child: const Text('Generate Prime'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
