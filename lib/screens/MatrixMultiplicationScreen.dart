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
    int rows = int.tryParse(_rowsController.text) ?? 0;
    int cols = int.tryParse(_colsController.text) ?? 0;

    if (rows > 0 && cols > 0) {
      setState(() {
        _matricesGenerated = true;
        _resultMatrix = null;
        _calculationTime = null;
        _matrixAControllers = List.generate(
            rows, (i) => List.generate(cols, (j) => TextEditingController()));
        _matrixBControllers = List.generate(
            rows, (i) => List.generate(cols, (j) => TextEditingController()));
      });
    } else {
      setState(() {
        _matricesGenerated = false;
      });
    }
  }

  void _multiplyMatrices() {
    int rows = _matrixAControllers.length;
    int cols = _matrixAControllers[0].length;

    List<List<int>> matrixA = List.generate(
        rows,
        (i) => List.generate(
            cols, (j) => int.tryParse(_matrixAControllers[i][j].text) ?? 0));

    List<List<int>> matrixB = List.generate(
        rows,
        (i) => List.generate(
            cols, (j) => int.tryParse(_matrixBControllers[i][j].text) ?? 0));

    List<List<int>> result =
        List.generate(rows, (i) => List.generate(cols, (j) => 0));

    final startTime = DateTime.now();

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        for (int k = 0; k < cols; k++) {
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
        // Wrap with SingleChildScrollView
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
                  'Calculation Time: $_calculationTime microseconds',
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
