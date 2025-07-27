import 'package:flutter/material.dart';
import 'result_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoadingScreen extends StatefulWidget {
  final Map<String, double> data;

  LoadingScreen({required this.data});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _makePrediction();
  }

  Future<void> _makePrediction() async {
    try {
      final response = await http.post(
        Uri.parse('https://linear-regression-model-par3.onrender.com/predict'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(widget.data),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body)['predicted_incidence_per_1000'].toString();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ResultScreen(result: result)),
        );
      } else {
        final error = json.decode(response.body)['detail'].toString();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ResultScreen(error: error)),
        );
      }
    } catch (e) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ResultScreen(error: e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.teal),
            SizedBox(height: 20),
            Text(
              "Predicting...",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
