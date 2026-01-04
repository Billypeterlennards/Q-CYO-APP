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
  String budget = ''; // Optional budget field

  // Results
  Map<String, dynamic>? recommendation;
  bool isLoading = false;
  String errorMessage = '';
  bool showAdvancedOptions = false;

  final List<String> soilTypes = ['sandy', 'clay', 'loamy', 'loam', 'silt', 'silty'];
  final List<String> cropTypes = ['maize', 'wheat', 'rice', 'barley', 'sorghum', 'soybean', 'cotton'];

  @override
  void initState() {
    super.initState();
    _testConnection();
  }

  Future<void> _testConnection() async {
    setState(() {
      isLoading = true;
    });

    final isConnected = await ApiService.testConnection();

    setState(() {
      isLoading = false;
      if (!isConnected) {
        errorMessage = 'Cannot connect to API. Make sure the backend server is running at ${ApiService.baseUrl}';
      }
    });
  }

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
        budget: budget.isNotEmpty ? double.tryParse(budget) : null,
      );

      setState(() {
        recommendation = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString().replaceAll('Exception: ', '');
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.psychology, color: Colors.purple),
            SizedBox(width: 10),
            Text('Q-CYO: Quantum Crop Yield Optimizer'),
          ],
        ),
        backgroundColor: Colors.green[800],
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Connection status
              if (errorMessage.contains('Cannot connect to API'))
                Card(
                  color: Colors.orange[50],
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.warning, color: Colors.orange),
                            SizedBox(width: 8),
                            Text(
                              'API Connection Required',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange[900],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          errorMessage,
                          style: TextStyle(color: Colors.orange[800]),
                        ),
                        SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: _testConnection,
                          icon: Icon(Icons.refresh),
                          label: Text('Retry Connection'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              SizedBox(height: 10),

              // Input Form Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.agriculture, color: Colors.green, size: 30),
                            SizedBox(width: 10),
                            Text(
                              'Farm Details',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[900],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        // Rainfall
                        _buildInputField(
                          label: 'Rainfall (mm)',
                          icon: Icons.water_drop,
                          initialValue: rainfall.toString(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter rainfall';
                            }
                            final val = double.tryParse(value);
                            if (val == null || val < 0) {
                              return 'Enter a valid positive number';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            rainfall = double.tryParse(value) ?? 120.0;
                          },
                        ),

                        SizedBox(height: 15),

                        // Temperature
                        _buildInputField(
                          label: 'Temperature (°C)',
                          icon: Icons.thermostat,
                          initialValue: temperature.toString(),
                          validator: (value) {
                            final val = double.tryParse(value!);
                            if (val != null && (val < -20 || val > 60)) {
                              return 'Temperature should be between -20°C and 60°C';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            temperature = double.tryParse(value) ?? 26.0;
                          },
                        ),

                        SizedBox(height: 15),

                        // Soil Type Dropdown
                        _buildDropdown(
                          label: 'Soil Type',
                          icon: Icons.landscape,
                          value: soilType,
                          items: soilTypes,
                          onChanged: (value) {
                            setState(() {
                              soilType = value!;
                            });
                          },
                        ),

                        SizedBox(height: 15),

                        // Crop Type Dropdown
                        _buildDropdown(
                          label: 'Crop Type',
                          icon: Icons.spa,
                          value: cropType,
                          items: cropTypes,
                          onChanged: (value) {
                            setState(() {
                              cropType = value!;
                            });
                          },
                        ),

                        SizedBox(height: 15),

                        // Area
                        _buildInputField(
                          label: 'Area (hectares)',
                          icon: Icons.square_foot,
                          initialValue: area.toString(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter area';
                            }
                            final val = double.tryParse(value);
                            if (val == null || val <= 0) {
                              return 'Enter a valid positive number';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            area = double.tryParse(value) ?? 5.0;
                          },
                        ),

                        SizedBox(height: 15),

                        // Advanced Options Toggle
                        InkWell(
                          onTap: () {
                            setState(() {
                              showAdvancedOptions = !showAdvancedOptions;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.tune,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Advanced Options',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue[700],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Icon(
                                showAdvancedOptions
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                        ),

                        // Budget Input (Optional)
                        if (showAdvancedOptions)
                          Column(
                            children: [
                              SizedBox(height: 15),
                              _buildInputField(
                                label: 'Budget (USD) - Optional',
                                icon: Icons.attach_money,
                                initialValue: budget,
                                validator: (value) {
                                  if (value != null && value.isNotEmpty) {
                                    final val = double.tryParse(value);
                                    if (val == null || val <= 0) {
                                      return 'Enter a valid budget amount';
                                    }
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  budget = value;
                                },
                              ),
                            ],
                          ),

                        SizedBox(height: 25),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton.icon(
                            onPressed: isLoading ? null : _getRecommendation,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                            icon: isLoading
                                ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                                : Icon(Icons.rocket_launch, color: Colors.white),
                            label: isLoading
                                ? Text('Optimizing...', style: TextStyle(fontSize: 18))
                                : Text(
                              'Get Quantum Recommendations',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              if (errorMessage.isNotEmpty && !errorMessage.contains('Cannot connect to API'))
                Card(
                  color: Colors.red[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.error, color: Colors.red),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Error',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[900],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                errorMessage,
                                style: TextStyle(color: Colors.red[800]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Results Display
              if (recommendation != null)
                _buildResultsCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required IconData icon,
    required String initialValue,
    required String? Function(String?)? validator,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: Icon(icon, color: Colors.green),
        filled: true,
        fillColor: Colors.green[50],
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      initialValue: initialValue,
      onChanged: onChanged,
      validator: validator,
    );
  }

  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: Icon(icon, color: Colors.green),
        filled: true,
        fillColor: Colors.green[50],
      ),
      value: value,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(
            item[0].toUpperCase() + item.substring(1),
            style: TextStyle(fontSize: 16),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildResultsCard() {
    final data = recommendation!;
    final riskLevel = data['weather_risk_level'] ?? data['weather_risk'] ?? 'N/A';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.insights, color: Colors.green[900], size: 30),
                SizedBox(width: 10),
                Text(
                  '📊 Quantum-Optimized Recommendations',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900],
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Quantum Status
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.purple),
              ),
              child: Row(
                children: [
                  Icon(Icons.psychology, color: Colors.purple),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quantum Optimization',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[800],
                          ),
                        ),
                        Text(
                          data['quantum_optimization_used'] == true
                              ? '✅ Active'
                              : '⚠️ Classical Only',
                          style: TextStyle(color: Colors.purple[700]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Yield Section
            _buildSectionHeader('🌾 Yield Prediction'),
            _buildResultRow(
              'Prediction Method',
              data['yield_prediction_method'] ?? 'N/A',
            ),
            _buildResultRow(
              'Yield per Hectare',
              '${_formatNumber(data['yield_per_hectare'])} tons',
            ),
            _buildResultRow(
              'Total Yield',
              '${_formatNumber(data['total_yield'])} tons',
            ),

            SizedBox(height: 20),

            // Fertilizer Section
            _buildSectionHeader('🧪 Fertilizer Recommendations'),
            _buildResultRow(
              'Total Fertilizer',
              '${_formatNumber(data['fertilizer_total_kg_per_ha'])} kg/ha',
            ),

            // NPK Details
            if (data['fertilizer_npk_breakdown'] != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Text(
                    'NPK Breakdown:',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNpkChip('N', data['fertilizer_npk_breakdown']['N']),
                      _buildNpkChip('P', data['fertilizer_npk_breakdown']['P']),
                      _buildNpkChip('K', data['fertilizer_npk_breakdown']['K']),
                    ],
                  ),
                ],
              ),

            _buildResultRow(
              'Timing',
              data['fertilizer_timing'] ?? 'Standard',
            ),
            _buildResultRow(
              'Cost per Hectare',
              '\$${_formatNumber(data['fertilizer_cost_per_ha'])}',
            ),

            // Total Cost
            _buildResultRow(
              'Total Cost',
              '\$${_formatNumber(data['total_cost_usd'])}',
              isHighlighted: true,
            ),

            // Budget Status
            if (data['budget_constraint_usd'] != null)
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: data['within_budget'] == true ? Colors.green[100] : Colors.orange[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: data['within_budget'] == true ? Colors.green : Colors.orange,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      data['within_budget'] == true ? Icons.check_circle : Icons.warning,
                      color: data['within_budget'] == true ? Colors.green : Colors.orange,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        data['within_budget'] == true
                            ? '✅ Within budget (\$${_formatNumber(data['budget_constraint_usd'])})'
                            : '⚠️ Over budget (\$${_formatNumber(data['budget_constraint_usd'])})',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: data['within_budget'] == true ? Colors.green[800] : Colors.orange[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            SizedBox(height: 20),

            // Weather Risk
            _buildSectionHeader('⚠️ Weather Risk Assessment'),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getRiskColor(riskLevel),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.cloud, color: Colors.white),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Risk Level: $riskLevel',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Risk Factors
            if (data['risk_factors'] != null && data['risk_factors'] is Map)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Text(
                    'Risk Factors:',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: (data['risk_factors'] as Map).entries.map((entry) {
                      final riskName = entry.key.toString().replaceAll('_', ' ');
                      final riskValue = entry.value;
                      return Chip(
                        label: Text('${riskName}: ${_formatNumber(riskValue)}'),
                        backgroundColor: riskValue > 0.3 ? Colors.orange[100] : Colors.green[100],
                      );
                    }).toList(),
                  ),
                ],
              ),

            // Model Info
            SizedBox(height: 20),
            _buildSectionHeader('🤖 Model Information'),
            _buildResultRow(
              'ML Model Used',
              data['ml_model_used'] == true ? '✅ Active' : '⚠️ Not Active',
            ),
            _buildResultRow(
              'Area Processed',
              '${_formatNumber(data['area_hectares'])} hectares',
            ),

            // Timestamp
            if (data['timestamp'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Generated: ${_formatTimestamp(data['timestamp'])}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.green[900],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, {bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
              color: isHighlighted ? Colors.green[900] : Colors.green[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNpkChip(String nutrient, dynamic value) {
    final color = nutrient == 'N' ? Colors.blue : nutrient == 'P' ? Colors.orange : Colors.red;
    return Chip(
      label: Text(
        '$nutrient: ${_formatNumber(value)} kg',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      backgroundColor: color,
    );
  }

  String _formatNumber(dynamic value) {
    if (value == null) return 'N/A';
    if (value is double) {
      return value.toStringAsFixed(2);
    }
    if (value is int) {
      return value.toString();
    }
    try {
      final numVal = double.tryParse(value.toString());
      return numVal?.toStringAsFixed(2) ?? value.toString();
    } catch (e) {
      return value.toString();
    }
  }

  String _formatTimestamp(dynamic timestamp) {
    try {
      if (timestamp == null) return 'N/A';
      final dateTime = DateTime.parse(timestamp.toString());
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return timestamp.toString();
    }
  }

  Color _getRiskColor(String risk) {
    final riskLower = risk.toLowerCase();
    if (riskLower.contains('very low') || riskLower.contains('low')) {
      return Colors.green;
    } else if (riskLower.contains('moderate')) {
      return Colors.orange;
    } else if (riskLower.contains('high')) {
      return Colors.red[600]!;
    } else if (riskLower.contains('extreme')) {
      return Colors.red[900]!;
    } else {
      return Colors.grey;
    }
  }
}