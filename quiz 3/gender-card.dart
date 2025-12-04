import 'package:flutter/material.dart';
import 'gender_card.dart';
import 'results_screen.dart'; // <-- Added this import

enum Gender { male, female }

class BMIScreen extends StatefulWidget {
  const BMIScreen({super.key});

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String _system = 'metric';
  Gender _gender = Gender.male;

  double? _bmi;
  String? _category;
  String? _advice;
  String? _errorMessage;

  // HEIGHT SLIDER VALUE
  double _heightValue = 170;

  // WEIGHT CARD VALUE
  double _weightValue = 60;

  // AGE CARD VALUE
  int _ageValue = 25;

  double parseNumber(String input) {
    input = input.trim();
    if (input.isEmpty) throw FormatException("Empty input");
    return double.parse(input);
  }

  double heightToMeters(String input, String system) {
    input = input.trim().toLowerCase();
    if (system == "metric") {
      if (input.endsWith("cm")) {
        double cm = parseNumber(input.replaceAll("cm", ""));
        return cm / 100;
      } else if (input.endsWith("m")) {
        return parseNumber(input.replaceAll("m", ""));
      } else {
        double num = parseNumber(input);
        return (num > 3) ? num / 100 : num;
      }
    }
    if (input.contains("'")) {
      List<String> p = input.split("'");
      double ft = parseNumber(p[0]);
      double inch = (p.length > 1 && p[1].isNotEmpty)
          ? parseNumber(p[1].replaceAll('"', ""))
          : 0;
      return (ft * 12 + inch) * 0.0254;
    }
    if (input.endsWith("in")) {
      return parseNumber(input.replaceAll("in", "")) * 0.0254;
    }
    double val = parseNumber(input);
    return (val > 3) ? val * 0.0254 : val;
  }

  double weightToKg(String input, String system) {
    input = input.trim().toLowerCase();
    if (system == "metric") {
      if (input.endsWith("kg")) return parseNumber(input.replaceAll("kg", ""));
      return parseNumber(input);
    }
    if (input.endsWith("lb") || input.endsWith("lbs")) {
      double lb = parseNumber(input.replaceAll("lbs", "").replaceAll("lb", ""));
      return lb * 0.45359237;
    }
    return parseNumber(input) * 0.45359237;
  }

  double bmiCalc(double kg, double m) => kg / (m * m);

  String bmiCategory(double bmi) {
    if (bmi < 18.5) return "Underweight";
    if (bmi < 25) return "Normal";
    if (bmi < 30) return "Overweight";
    return "Obesity";
  }

  String bmiAdvice(String c) {
    switch (c) {
      case "Underweight":
        return "Try gaining weight with healthy meals.";
      case "Normal":
        return "Great! Maintain your lifestyle.";
      case "Overweight":
        return "Try exercising and eating balanced meals.";
      case "Obesity":
        return "Consult a healthcare professional.";
    }
    return "";
  }

  // ================= Updated _calculate method =================
  void _calculate() {
    setState(() {
      _errorMessage = null;
      _bmi = null;
      _category = null;
      _advice = null;
    });

    try {
      final kg = weightToKg(_weightController.text, _system);
      final m = heightToMeters(_heightController.text, _system);
      final bmi = bmiCalc(kg, m);
      final cat = bmiCategory(bmi);
      final adv = bmiAdvice(cat);

      setState(() {
        _bmi = bmi;
        _category = cat;
        _advice = adv;
      });

      // ===== Navigate to ResultScreen =====
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsScreen(
            bmi: bmi,
            category: cat,
            advice: adv,
          ),
        ),
      );
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    }
  }

  void _reset() {
    setState(() {
      _weightController.clear();
      _heightController.clear();
      _ageController.clear();
      _bmi = null;
      _category = null;
      _advice = null;
      _errorMessage = null;
      _gender = Gender.male;
      _heightValue = 170;
      _weightValue = 60;
      _ageValue = 25;
    });
  }

  Widget _buildCard(
      {required String title,
        required String value,
        required VoidCallback onIncrement,
        required VoidCallback onDecrement}) {
    return Expanded(
      child: Card(
        elevation: 3,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: onDecrement,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF282C4F),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.remove, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                  InkWell(
                    onTap: onIncrement,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF282C4F),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final weightHint =
    _system == 'metric' ? 'e.g. 68 or 68kg' : 'e.g. 150 or 150lb';
    final heightHint =
    _system == 'metric' ? 'e.g. 1.70 or 170cm' : 'e.g. 5\'9" or 69in';
    final ageHint = 'Enter your age';

    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ------------------------ GENDER CARDS ------------------------
            Row(
              children: [
                GenderCard(
                  gender: "male",
                  icon: Icons.man,
                  selected: (_gender == Gender.male),
                  onTap: () => setState(() => _gender = Gender.male),
                ),
                const SizedBox(width: 12),
                GenderCard(
                  gender: "female",
                  icon: Icons.woman,
                  selected: (_gender == Gender.female),
                  onTap: () => setState(() => _gender = Gender.female),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ------------------------ SYSTEM CHOICE ------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text('Metric'),
                  selected: _system == 'metric',
                  onSelected: (_) => setState(() => _system = 'metric'),
                ),
                const SizedBox(width: 12),
                ChoiceChip(
                  label: const Text('Imperial'),
                  selected: _system == 'imperial',
                  onSelected: (_) => setState(() => _system = 'imperial'),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ------------------------ HEIGHT CARD ------------------------
            Card(
              elevation: 3,
              child: Container(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    const Text(
                      "HEIGHT",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _heightValue.toStringAsFixed(0),
                          style: const TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          "cm",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    Slider(
                      value: _heightValue,
                      min: 120,
                      max: 220,
                      onChanged: (value) {
                        setState(() {
                          _heightValue = value;
                          _heightController.text =
                              value.toStringAsFixed(0); // sync
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ------------------------ WEIGHT & AGE CARDS IN ROW ------------------------
            Row(
              children: [
                _buildCard(
                  title: "WEIGHT",
                  value: _weightValue.toStringAsFixed(0),
                  onIncrement: () {
                    setState(() {
                      _weightValue++;
                      _weightController.text = _weightValue.toStringAsFixed(0);
                    });
                  },
                  onDecrement: () {
                    setState(() {
                      if (_weightValue > 1) _weightValue--;
                      _weightController.text = _weightValue.toStringAsFixed(0);
                    });
                  },
                ),
                const SizedBox(width: 12),
                _buildCard(
                  title: "AGE",
                  value: _ageValue.toString(),
                  onIncrement: () {
                    setState(() {
                      if (_ageValue < 120) _ageValue++;
                      _ageController.text = _ageValue.toString();
                    });
                  },
                  onDecrement: () {
                    setState(() {
                      if (_ageValue > 1) _ageValue--;
                      _ageController.text = _ageValue.toString();
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ------------------------ TEXTFIELDS ------------------------
            TextField(
              controller: _weightController,
              keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Weight',
                hintText: weightHint,
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _heightController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Height',
                hintText: heightHint,
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _ageController,
              keyboardType:
              const TextInputType.numberWithOptions(decimal: false),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Age',
                hintText: ageHint,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _calculate, // <-- This will navigate to ResultScreen
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child:
                  Text("Calculate BMI", style: TextStyle(fontSize: 16)),
                ),
              ),
            ),

            const SizedBox(height: 12),

            if (_errorMessage != null)
              Card(
                color: Colors.red[50],
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
