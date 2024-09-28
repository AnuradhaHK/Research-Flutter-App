import 'package:flutter/material.dart';

class MatrixMultiplierScreen extends StatefulWidget {
  const MatrixMultiplierScreen({super.key});

  @override
  _MatrixMultiplierScreenState createState() => _MatrixMultiplierScreenState();
}

class _MatrixMultiplierScreenState extends State<MatrixMultiplierScreen> {
  final TextEditingController _rowsController = TextEditingController();
  final TextEditingController _colsController = TextEditingController();
  List<List<TextEditingController>> _matrixAControllers = [];
  List<List<TextEditingController>> _matrixBControllers = [];
  List<List<int>>? _resultMatrix;
  bool _matricesGenerated = false;
  int? _calculationTime;

  void _generateMatrices() {
    int rowsA = int.tryParse(_rowsController.text) ?? 0;
    int colsA = int.tryParse(_colsController.text) ?? 0;

    // Ensure rows and columns are greater than 0
    if (rowsA > 0 && colsA > 0) {
      setState(() {
        _matricesGenerated = true;
        _resultMatrix = null;
        _calculationTime = null;

        // Matrix A will have dimensions rowsA x colsA
        _matrixAControllers = List.generate(
            rowsA, (i) => List.generate(colsA, (j) => TextEditingController()));

        // Matrix B should have dimensions colsA x rowsA
        _matrixBControllers = List.generate(
            colsA, (i) => List.generate(rowsA, (j) => TextEditingController()));
      });
    } else {
      setState(() {
        _matricesGenerated = false;
      });
    }
  }

  void _multiplyMatrices() {
    int rowsA = _matrixAControllers.length;
    int colsA = _matrixAControllers[0].length;
    int rowsB = _matrixBControllers.length;
    int colsB = _matrixBControllers[0].length;

    // Matrix A has dimensions rowsA x colsA
    List<List<int>> matrixA = List.generate(
        rowsA,
        (i) => List.generate(
            colsA, (j) => int.tryParse(_matrixAControllers[i][j].text) ?? 0));

    // Matrix B has dimensions rowsB x colsB (which should be colsA x rowsA)
    List<List<int>> matrixB = List.generate(
        rowsB,
        (i) => List.generate(
            colsB, (j) => int.tryParse(_matrixBControllers[i][j].text) ?? 0));

    // Resultant matrix will have dimensions rowsA x colsB
    List<List<int>> result =
        List.generate(rowsA, (i) => List.generate(colsB, (j) => 0));

    final startTime = DateTime.now();

    // Perform matrix multiplication
    for (int i = 0; i < rowsA; i++) {
      for (int j = 0; j < colsB; j++) {
        for (int k = 0; k < rowsB; k++) {
          result[i][j] += matrixA[i][k] * matrixB[k][j];
        }
      }
    }

    final endTime = DateTime.now();
    final timeTaken = endTime.difference(startTime).inMicroseconds;

    setState(() {
      _resultMatrix = result;
      _calculationTime = timeTaken;
    });
  }

  void _resetMatrices() {
    setState(() {
      _rowsController.clear();
      _colsController.clear();
      _matricesGenerated = false;
      _matrixAControllers.clear();
      _matrixBControllers.clear();
      _resultMatrix = null;
      _calculationTime = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matrix Multiplier'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter the number of rows and columns:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _rowsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Rows',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _colsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Columns',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: _generateMatrices,
              child: const Text('Generate Matrices'),
            ),
            const SizedBox(height: 10),
            if (_matricesGenerated) ...[
              const Text(
                'Matrix A:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildMatrixInputFields(_matrixAControllers),
              const SizedBox(height: 20),
              const Text(
                'Matrix B:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildMatrixInputFields(_matrixBControllers),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: _multiplyMatrices,
                child: const Text('Multiply'),
              ),
              const SizedBox(height: 20),
            ],
            if (_resultMatrix != null) ...[
              if (_calculationTime != null)
                Text(
                  'Calculation Time: $_calculationTime µs',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              const SizedBox(height: 10),
              const Text(
                'Result Matrix:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildResultMatrix(),
            ],
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: _resetMatrices,
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatrixInputFields(
      List<List<TextEditingController>> matrixControllers) {
    return Column(
      children: matrixControllers.map((row) {
        return Row(
          children: row.map((controller) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  Widget _buildResultMatrix() {
    return Column(
      children: _resultMatrix!.map((row) {
        return Row(
          children: row.map((value) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    color: Colors.green[100],
                  ),
                  child: Text(
                    value.toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}
