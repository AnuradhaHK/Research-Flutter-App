import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON decoding

class ButtonStyles {
  static const double buttonHeight = 60.0; // Same button height as before

  static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    fixedSize: const Size.fromHeight(buttonHeight),
    textStyle: const TextStyle(fontSize: 16),
  );

  static ButtonStyle redButtonStyle = ElevatedButton.styleFrom(
    fixedSize: const Size.fromHeight(buttonHeight),
    backgroundColor: Colors.red,
    textStyle: const TextStyle(fontSize: 16),
  );
}

class Button01Screen extends StatefulWidget {
  const Button01Screen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Button01ScreenState createState() => _Button01ScreenState();
}

class _Button01ScreenState extends State<Button01Screen> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _data = []; // To store the parsed JSON data

  void _fetchData() async {
    final String size = _controller.text;
    final String apiUrl =
        'https://jsonplaceholder.typicode.com/photos?_limit=$size';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          _data = json.decode(response.body); // Parse the JSON response
        });
      } else {
        setState(() {
          _data = [];
        });
      }
    } catch (e) {
      setState(() {
        _data = [];
      });
    }
  }

  void _resetData() {
    setState(() {
      _controller.clear();
      _data = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Request'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration:
                        const InputDecoration(labelText: 'Enter Request Size'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(
                    width: 10), // Spacing between the text field and buttons
                ElevatedButton(
                  onPressed: _fetchData,
                  style: ButtonStyles.elevatedButtonStyle,
                  child: const Text('FETCH API DATA'),
                ),
                const SizedBox(width: 10), // Spacing between the buttons
                ElevatedButton(
                  onPressed: _resetData,
                  style: ButtonStyles.redButtonStyle,
                  child: const Text('RESET'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _data.isNotEmpty
                  ? ListView.builder(
                      itemCount: _data.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Image.network(_data[index]['thumbnailUrl']),
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
