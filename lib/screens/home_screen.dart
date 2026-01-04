import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  double rainfall = 120.0;
  double temperature = 26.0;
  String soilType = 'sandy';
  String cropType = 'maize';
  double area = 5.0;

  // Results
  Map<String, dynamic>? recommendation;
  bool isLoading = false;
  String errorMessage = '';

  final List<String> soilTypes = ['sandy', 'clay', 'loamy', 'silty'];
  final List<String> cropTypes = ['maize', 'wheat', 'rice', 'soybean', 'cotton'];

  Future<void> _getRecommendation() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      recommendation = null;
      errorMessage = '';
    });

    try {
      final result = await ApiService.getRecommendation(
        rainfall: rainfall,
        temperature: temperature,
        soilType: soilType,
        cropType: cropType,
        area: area,
      );

      setState(() {
        recommendation = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Q-CYO: Crop Yield Optimizer'),
        backgroundColor: Colors.green[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          'Enter Farm Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[900],
                          ),
                        ),
                        SizedBox(height: 20),

                        // Rainfall
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Rainfall (mm)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.water_drop),
                          ),
                          keyboardType: TextInputType.number,
                          initialValue: rainfall.toString(),
                          onChanged: (value) {
                            rainfall = double.tryParse(value) ?? 120.0;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter rainfall';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15),

                        // Temperature
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Temperature (°C)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.thermostat),
                          ),
                          keyboardType: TextInputType.number,
                          initialValue: temperature.toString(),
                          onChanged: (value) {
                            temperature = double.tryParse(value) ?? 26.0;
                          },
                        ),
                        SizedBox(height: 15),

                        // Soil Type Dropdown
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Soil Type',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.landscape),
                          ),
                          value: soilType,
                          items: soilTypes.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type[0].toUpperCase() + type.substring(1)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              soilType = value!;
                            });
                          },
                        ),
                        SizedBox(height: 15),

                        // Crop Type Dropdown
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Crop Type',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.spa),
                          ),
                          value: cropType,
                          items: cropTypes.map((crop) {
                            return DropdownMenuItem(
                              value: crop,
                              child: Text(crop[0].toUpperCase() + crop.substring(1)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              cropType = value!;
                            });
                          },
                        ),
                        SizedBox(height: 15),

                        // Area
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Area (hectares)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.square_foot),
                          ),
                          keyboardType: TextInputType.number,
                          initialValue: area.toString(),
                          onChanged: (value) {
                            area = double.tryParse(value) ?? 5.0;
                          },
                        ),
                        SizedBox(height: 25),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _getRecommendation,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                              'Get Recommendations',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Error Message
              if (errorMessage.isNotEmpty)
                Card(
                  color: Colors.red[50],
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Error: $errorMessage',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),

              // Results Display
              if (recommendation != null)
                Card(
                  elevation: 4,
                  color: Colors.green[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '📊 Recommendations',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[900],
                          ),
                        ),
                        SizedBox(height: 20),

                        _buildResultRow(
                          '🌾 Yield per Hectare',
                          '${recommendation!['yield_per_hectare']?.toStringAsFixed(2) ?? 'N/A'} tons',
                        ),
                        _buildResultRow(
                          '📦 Total Yield',
                          '${recommendation!['total_yield']?.toStringAsFixed(2) ?? 'N/A'} tons',
                        ),
                        _buildResultRow(
                          '🧪 Fertilizer Required',
                          '${recommendation!['fertilizer_kg_per_ha']?.toStringAsFixed(0) ?? 'N/A'} kg/ha',
                        ),

                        // Weather Risk with color coding
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _getRiskColor(recommendation!['weather_risk'] ?? ''),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.cloud, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                'Weather Risk: ${recommendation!['weather_risk']}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green[900],
            ),
          ),
        ],
      ),
    );
  }

  Color _getRiskColor(String risk) {
    switch (risk.toLowerCase()) {
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'high':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}