import 'package:flutter/material.dart';
import 'loading_screen.dart';

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, TextEditingController> _controllers = {
    'malaria_cases_reported': TextEditingController(),
    'bed_net_use_pct': TextEditingController(),
    'fever_antimalarial_pct': TextEditingController(),
    'ipt_pregnancy_pct': TextEditingController(),
    'urban_pop_growth_pct': TextEditingController(),
    'rural_pop_growth_pct': TextEditingController(),
    'urban_pop_pct': TextEditingController(),
    'basic_sanitation_pct': TextEditingController(),
    'drinking_water_urban_pct': TextEditingController(),
  };

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  String? _validateField(String key, String? value) {
    if (value == null || value.isEmpty) return 'Required';
    final number = double.tryParse(value);
    if (number == null) return 'Must be a number';

    switch (key) {
      case 'malaria_cases_reported':
        if (number < 0) return 'Must be ≥ 0';
        break;
      case 'bed_net_use_pct':
      case 'fever_antimalarial_pct':
      case 'ipt_pregnancy_pct':
      case 'urban_pop_pct':
      case 'basic_sanitation_pct':
      case 'drinking_water_urban_pct':
        if (number < 0 || number > 100) return 'Must be between 0 and 100';
        break;
      case 'urban_pop_growth_pct':
      case 'rural_pop_growth_pct':
        if (number < -10 || number > 15) return 'Must be between -10 and 15';
        break;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Malaria Predictor'),
        backgroundColor: Colors.teal,
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.teal.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ..._controllers.entries.map((entry) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: TextFormField(
                          controller: entry.value,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            labelText: entry.key.replaceAll("_", " ").toUpperCase(),
                            border: InputBorder.none,
                          ),
                          validator: (value) =>
                              _validateField(entry.key, value),
                        ),
                      ),
                    ),
                  )),
              SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final inputData = {
                      for (var e in _controllers.entries)
                        e.key: double.parse(e.value.text)
                    };

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LoadingScreen(data: inputData),
                      ),
                    );
                  }
                },
                child: Text("Predict", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
