import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String? result;
  final String? error;

  const ResultScreen({this.result, this.error});

  @override
  Widget build(BuildContext context) {
    final isError = error != null;
    return Scaffold(
      appBar: AppBar(
        title: Text('Prediction Result'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 6,
            child: Container(
              padding: const EdgeInsets.all(30),
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isError ? Icons.error_outline : Icons.check_circle_outline,
                    color: isError ? Colors.red : Colors.green,
                    size: 80,
                  ),
                  SizedBox(height: 20),
                  Text(
                    isError
                        ? 'Oops! Something went wrong.'
                        : 'Prediction Successful!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isError ? Colors.red : Colors.green[700],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    isError
                        ? error!
                        : 'Predicted Incidence:\n$result per 1000 people',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text("Back", style: TextStyle(fontSize: 16)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
