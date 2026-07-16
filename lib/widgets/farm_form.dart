import 'package:flutter/material.dart';

class FarmFormData {
  double rainfall;
  double temperature;
  String soilType;
  String cropType;
  double area;
  double? budget;

  FarmFormData({
    this.rainfall = 120.0,
    this.temperature = 26.0,
    this.soilType = 'sandy',
    this.cropType = 'maize',
    this.area = 5.0,
    this.budget,
  });
}

/// Farm details input form, extracted from the original 600+ line
/// home_screen.dart into its own widget so it can be read, tested and
/// modified independently of the results display and API-wiring logic.
class FarmForm extends StatefulWidget {
  final FarmFormData initialData;
  final bool isLoading;
  final ValueChanged<FarmFormData> onSubmit;

  const FarmForm({
    super.key,
    required this.initialData,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  State<FarmForm> createState() => _FarmFormState();
}

class _FarmFormState extends State<FarmForm> {
  final _formKey = GlobalKey<FormState>();

  // BEFORE: TextFormField(initialValue: ...) rebuilt from raw state fields
  // on every setState(), which silently resets the cursor position to the
  // end and can drop the character the user was mid-typing on rebuild.
  // AFTER: proper TextEditingControllers, created once in initState and
  // disposed properly - the standard, correct Flutter pattern for
  // controlled text fields.
  late final TextEditingController _rainfallController;
  late final TextEditingController _temperatureController;
  late final TextEditingController _areaController;
  late final TextEditingController _budgetController;

  late String _soilType;
  late String _cropType;
  bool _showAdvancedOptions = false;

  static const soilTypes = ['sandy', 'clay', 'loamy', 'loam', 'silt', 'silty'];
  static const cropTypes = [
    'maize', 'wheat', 'rice', 'barley', 'sorghum', 'soybean', 'cotton',
  ];

  @override
  void initState() {
    super.initState();
    final d = widget.initialData;
    _rainfallController = TextEditingController(text: d.rainfall.toString());
    _temperatureController =
        TextEditingController(text: d.temperature.toString());
    _areaController = TextEditingController(text: d.area.toString());
    _budgetController =
        TextEditingController(text: d.budget?.toString() ?? '');
    _soilType = d.soilType;
    _cropType = d.cropType;
  }

  @override
  void dispose() {
    _rainfallController.dispose();
    _temperatureController.dispose();
    _areaController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    widget.onSubmit(
      FarmFormData(
        rainfall: double.tryParse(_rainfallController.text) ?? 120.0,
        temperature: double.tryParse(_temperatureController.text) ?? 26.0,
        soilType: _soilType,
        cropType: _cropType,
        area: double.tryParse(_areaController.text) ?? 5.0,
        budget: _budgetController.text.isNotEmpty
            ? double.tryParse(_budgetController.text)
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.agriculture, color: colorScheme.primary, size: 30),
                  const SizedBox(width: 10),
                  Text(
                    'Farm Details',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _NumberField(
                controller: _rainfallController,
                label: 'Rainfall (mm)',
                icon: Icons.water_drop,
                validator: (value) {
                  // BEFORE: the temperature validator called
                  // `double.tryParse(value!)` with a forced null-unwrap.
                  // If the user cleared the field entirely, `value` is
                  // null and `value!` throws, crashing the whole form.
                  // Every validator here now null-checks properly first.
                  if (value == null || value.isEmpty) {
                    return 'Please enter rainfall';
                  }
                  final val = double.tryParse(value);
                  if (val == null || val < 0) {
                    return 'Enter a valid positive number';
                  }
                  if (val > 1000) {
                    return 'Rainfall must be 1000mm or less';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              _NumberField(
                controller: _temperatureController,
                label: 'Temperature (°C)',
                icon: Icons.thermostat,
                allowNegative: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter temperature';
                  }
                  final val = double.tryParse(value);
                  if (val == null) {
                    return 'Enter a valid number';
                  }
                  if (val < -20 || val > 60) {
                    return 'Temperature should be between -20°C and 60°C';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              _Dropdown(
                label: 'Soil Type',
                icon: Icons.landscape,
                value: _soilType,
                items: soilTypes,
                onChanged: (v) => setState(() => _soilType = v!),
              ),
              const SizedBox(height: 15),
              _Dropdown(
                label: 'Crop Type',
                icon: Icons.spa,
                value: _cropType,
                items: cropTypes,
                onChanged: (v) => setState(() => _cropType = v!),
              ),
              const SizedBox(height: 15),
              _NumberField(
                controller: _areaController,
                label: 'Area (hectares)',
                icon: Icons.square_foot,
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
              ),
              const SizedBox(height: 15),
              InkWell(
                onTap: () => setState(
                  () => _showAdvancedOptions = !_showAdvancedOptions,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.tune, color: colorScheme.secondary),
                        const SizedBox(width: 8),
                        Text(
                          'Advanced Options',
                          style: TextStyle(
                            fontSize: 16,
                            color: colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      _showAdvancedOptions
                          ? Icons.expand_less
                          : Icons.expand_more,
                      color: colorScheme.secondary,
                    ),
                  ],
                ),
              ),
              if (_showAdvancedOptions) ...[
                const SizedBox(height: 15),
                _NumberField(
                  controller: _budgetController,
                  label: 'Budget (USD) - Optional',
                  icon: Icons.attach_money,
                  isRequired: false,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final val = double.tryParse(value);
                      if (val == null || val <= 0) {
                        return 'Enter a valid budget amount';
                      }
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: widget.isLoading ? null : _submit,
                  icon: widget.isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Icon(Icons.rocket_launch, color: Colors.white),
                  label: Text(
                    widget.isLoading
                        ? 'Optimizing...'
                        : 'Get Quantum Recommendations',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NumberField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?) validator;
  final bool allowNegative;
  final bool isRequired;

  const _NumberField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.validator,
    this.allowNegative = false,
    this.isRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
      keyboardType: TextInputType.numberWithOptions(
        decimal: true,
        signed: allowNegative,
      ),
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}

class _Dropdown extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _Dropdown({
    required this.label,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      initialValue: value,
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item[0].toUpperCase() + item.substring(1)),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}
