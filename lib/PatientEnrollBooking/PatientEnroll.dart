import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Patientenroll extends StatefulWidget {
  final String email;
  final String token;
  final int customerId;
  const Patientenroll(
      {super.key,
      required this.email,
      required this.token,
      required this.customerId});

  @override
  State<Patientenroll> createState() => _PatientenrollState();
}

class _PatientenrollState extends State<Patientenroll> {
  bool _termsAccepted = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _relationController = TextEditingController();
  final TextEditingController _healthDifficultiesController =
      TextEditingController();

  Future<void> _enrollPatient() async {
    final url =
        'http://104.237.9.211:8007/karuthal/api/v1/persona/enrollpatient';
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${widget.token}',
    };

    final body = jsonEncode({
      "age": int.tryParse(_ageController.text) ?? 0,
      "gender": _genderController.text,
      "healthDescription": _healthDifficultiesController.text,
      "email": _emailController.text,
      "firstName": _firstnameController.text,
      "lastName": _lastnameController.text,
      "enrolledBy": {"customerId": widget.customerId},
    });

    print(body);

    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("Successful");
        print(response.body);
        Navigator.pop(context);
      } else {
        // Handle error response
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to enroll patient: ${response.body}'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      // Handle exceptions
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error occurred: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Patient Enrollment',
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                color: const Color(0xFF57CC99),
                                fontFamily:
                                    GoogleFonts.anekGurmukhi().fontFamily,
                                fontWeight: FontWeight.normal,
                                fontSize: 27.0,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Fill out the form carefully",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: const Color(0xFF3A3A3A),
                                fontFamily: GoogleFonts.robotoFlex().fontFamily,
                                fontSize: 16.0,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(children: [
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabelText(context, "FirstName"),
                            const SizedBox(height: 8),
                            _buildTextField(
                              context,
                              controller: _firstnameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter FirstName';
                                }
                                return null;
                              },
                            ),
                          ]),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabelText(context, "LastName"),
                            const SizedBox(height: 8),
                            _buildTextField(
                              context,
                              controller: _lastnameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter LastName';
                                }
                                return null;
                              },
                            ),
                          ]),
                    )
                  ]),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabelText(context, "Age"),
                            const SizedBox(height: 8),
                            _buildTextField(
                              context,
                              controller: _ageController,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabelText(context, "Gender"),
                            const SizedBox(height: 8),
                            _buildTextField(
                              context,
                              controller: _genderController,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabelText(context, "E-Mail"),
                            const SizedBox(height: 8),
                            _buildTextField(
                              context,
                              controller: _emailController,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabelText(context, "Phone"),
                            const SizedBox(height: 8),
                            _buildTextField(
                              context,
                              controller: _phoneController,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabelText(context, "Country"),
                            const SizedBox(height: 8),
                            _buildTextField(
                              context,
                              controller: _countryController,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabelText(context, "City"),
                            const SizedBox(height: 8),
                            _buildTextField(
                              context,
                              controller: _cityController,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _buildLabelText(context, "Health Difficulties"),
                  const SizedBox(height: 8),
                  _buildTextLargeField(
                    context,
                    controller: _healthDifficultiesController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter health difficulties';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  _buildLabelText(context, "Relation with patient"),
                  const SizedBox(height: 8),
                  _buildTextField(
                    context,
                    controller: _relationController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Relation';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    "Terms and Conditions",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "If you read everything, select the checkbox",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                        ),
                      ),
                      Checkbox(
                        value: _termsAccepted,
                        checkColor: Colors.white,
                        activeColor: const Color(0xFF57CC99),
                        onChanged: (value) {
                          setState(() {
                            _termsAccepted = value ?? false;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                  Center(
                    child: SizedBox(
                      height: 48.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF57CC99),
                        ),
                        onPressed: _termsAccepted
                            ? () {
                                if (_formKey.currentState!.validate()) {
                                  _enrollPatient();
                                }
                              }
                            : null,
                        child: const Text(
                          "Enroll Patient",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextFormField(
        controller: controller,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Color(0xFF57CC99)),
          ),
          errorStyle: const TextStyle(
            color: Colors.red,
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildTextLargeField(
    BuildContext context, {
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextFormField(
        controller: controller,
        cursorColor: Colors.black,
        maxLines: null,
        minLines: 5,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.greenAccent),
          ),
          errorStyle: const TextStyle(
            color: Colors.red,
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildLabelText(BuildContext context, String labelText) {
    Color labelColor;

    if (labelText == "Permanent Address") {
      labelColor = const Color(0xFF838181);
    } else {
      labelColor = Colors.black;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Text(
        labelText,
        style: TextStyle(
          color: labelColor,
          fontSize: 16,
          fontFamily: GoogleFonts.robotoFlex().fontFamily,
        ),
      ),
    );
  }
}
