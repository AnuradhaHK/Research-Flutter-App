import 'package:flutter/material.dart';

class PrimeNumbersGeneratorPage extends StatefulWidget {
  const PrimeNumbersGeneratorPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PrimeNumbersGeneratorPageState createState() =>
      _PrimeNumbersGeneratorPageState();
}

class _PrimeNumbersGeneratorPageState extends State<PrimeNumbersGeneratorPage> {
  List<int> primeNumbers = [];
  int generationTime = 0; // Variable to store time taken for prime generation

  void generatePrimes(int limit) {
    List<int> primes = [];
    final startTime = DateTime.now(); // Start time for measuring the duration

    for (int num = 2; num <= limit; num++) {
      bool isPrime = true;
      for (int i = 2; i <= num ~/ 2; i++) {
        if (num % i == 0) {
          isPrime = false;
          break;
        }
      }
      if (isPrime) primes.add(num);
    }

    final endTime = DateTime.now(); // End time for measuring the duration
    setState(() {
      primeNumbers = primes;
      generationTime = endTime
          .difference(startTime)
          .inMicroseconds; // Calculate time in microseconds
    });
  }

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prime Numbers Generator'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter a number to generate primes up to that limit:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter a limit',
              ),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                int limit = int.tryParse(_controller.text) ?? 0;
                if (limit > 1) {
                  generatePrimes(limit);
                } else {
                  setState(() {
                    primeNumbers = [];
                    generationTime = 0; // Reset time if invalid input
                  });
                }
              },
              child: const Text('Generate Primes'),
            ),
            const SizedBox(height: 20),

            // Display time taken to generate primes
            if (generationTime > 0)
              Text(
                'Time to generate primes: $generationTime µs',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 20),

            const Text(
              'Prime Numbers:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Wrap the prime numbers list in a Flexible widget for scrollability
            Expanded(
              child: primeNumbers.isEmpty
                  ? const Center(
                      child: Text('No primes generated.'),
                    )
                  : SingleChildScrollView(
                      child: Wrap(
                        spacing: 8.0, // Space between numbers
                        runSpacing: 8.0, // Space between lines of numbers
                        children: primeNumbers
                            .map((prime) => Chip(
                                  label: Text(prime.toString()),
                                  backgroundColor: Colors.green[100],
                                ))
                            .toList(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
