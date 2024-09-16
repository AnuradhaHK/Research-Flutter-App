import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ButtonStyles {
  static const double buttonHeight = 60.0; // Consistent height

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

class NetworkRequestScreen extends StatefulWidget {
  const NetworkRequestScreen({super.key});

  @override
  _NetworkRequestScreenState createState() => _NetworkRequestScreenState();
}

class _NetworkRequestScreenState extends State<NetworkRequestScreen> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _data = [];
  int? _fetchTimeMicroseconds; // Variable to store the time in microseconds

  void _fetchData() async {
    final String size = _controller.text;
    final String apiUrl =
        'https://jsonplaceholder.typicode.com/photos?_limit=$size';

    try {
      // Start timing before the request
      final startTime = DateTime.now();

      final response = await http.get(Uri.parse(apiUrl));

      // End timing after the request
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime).inMicroseconds;

      if (response.statusCode == 200) {
        setState(() {
          _data = json.decode(response.body);
          _fetchTimeMicroseconds = duration; // Set the fetch time
        });
      } else {
        setState(() {
          _data = [];
          _fetchTimeMicroseconds = null;
        });
      }
    } catch (e) {
      setState(() {
        _data = [];
        _fetchTimeMicroseconds = null;
      });
    }
  }

  void _resetData() {
    setState(() {
      _controller.clear();
      _data = [];
      _fetchTimeMicroseconds = null; // Reset the fetch time
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Request'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter a number to generate the API request up to that limit:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter a response size',
              ),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: _fetchData,
              child: const Text('Fetch API Data'),
            ),

            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: _resetData,
              child: const Text('Reset'),
            ),
            const SizedBox(height: 20),

            // Display the fetch time if available
            if (_fetchTimeMicroseconds != null)
              Text(
                'Time to fetch data: $_fetchTimeMicroseconds µs',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

            const SizedBox(height: 20),

            // Display the fetched data or a message when no data is available
            Expanded(
              child: _data.isNotEmpty
                  ? ListView.builder(
                      itemCount: _data.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Image.network(
                            'https://cors-anywhere.herokuapp.com/${_data[index]['thumbnailUrl']}',
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.broken_image);
                            },
                          ),
                          title: Text(_data[index]['title']),
                        );
                      },
                    )
                  : const Center(child: Text('No data available')),
            ),
          ],
        ),
      ),
    );
  }
}
