import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task2/model/user_model.dart' show UserModel;
import 'package:task2/provider/user_provider.dart';
import 'package:task2/views/order_screen.dart';
import 'package:task2/widgets/button.dart';

class UserInputScreen extends StatefulWidget {
  const UserInputScreen({super.key});

  @override
  State<UserInputScreen> createState() => _UserInputScreenState();
}

class _UserInputScreenState extends State<UserInputScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _gender;
  String _weight = '';
  String _height = '';
  String _age = '';

  bool _isFormValid = false;

  void _checkFormValidity() {
    final isValid =
        _weight.isNotEmpty &&
        double.tryParse(_weight) != null &&
        _height.isNotEmpty &&
        double.tryParse(_height) != null &&
        _age.isNotEmpty &&
        int.tryParse(_age) != null &&
        _gender != null;

    setState(() {
      _isFormValid = isValid;
    });
  }

  InputDecoration getBorderDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.orange, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Your Details'),
     
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("Gender", style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  decoration: getBorderDecoration(),
                  borderRadius: BorderRadius.circular(5),
                  value: _gender,
                  hint: const Text('Choose your Gender'),
                  items: const [
                    DropdownMenuItem(value: 'Male', child: Text('Male')),
                    DropdownMenuItem(value: 'Female', child: Text('Female')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _gender = value;
                      _checkFormValidity();
                    });
                  },
                ),
                const SizedBox(height: 16),

                Align(
                  alignment: Alignment.topLeft,
                  child: Text("Weight (kg)", style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  decoration: getBorderDecoration(hint: 'Enter your weight'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _weight = value;
                    _checkFormValidity();
                  },
                ),
                const SizedBox(height: 16),

                Align(
                  alignment: Alignment.topLeft,
                  child: Text("Height (cm)", style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  decoration: getBorderDecoration(hint: 'Enter your height'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _height = value;
                    _checkFormValidity();
                  },
                ),
                const SizedBox(height: 16),

                Align(
                  alignment: Alignment.topLeft,
                  child: Text("Age (years)", style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  decoration: getBorderDecoration(hint: 'Enter your age'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _age = value;
                    _checkFormValidity();
                  },
                ),
                const SizedBox(height: 20),

                OrangeButton(
                  text: "Calculate Calories",
                  enabled: _isFormValid,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      final user = UserModel(
                        gender: _gender!,
                        weight: double.parse(_weight),
                        height: double.parse(_height),
                        age: int.parse(_age),
                      );

                      userProvider.setUser(user);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PlaceOrderScreen(),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
