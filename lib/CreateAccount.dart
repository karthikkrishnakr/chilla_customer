import 'dart:convert';
import 'package:chilla_customer/CustomerRegistration.dart';
import 'package:chilla_customer/Login.dart';

import 'package:chilla_customer/design.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateAccount extends StatefulWidget {
  static String bearerToken = "";
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _PhoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    const String apiUrl =
        'http://104.237.9.211:8007/karuthal/api/v1/persona/signup';

    final Map<String, dynamic> requestData = {
      'email': _emailController.text.trim(),
      'password': _passwordController.text.trim(),
      "persona": "customer"
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        await _login();
      } else {
        _showErrorDialog('Failed to create account. Please try again.');
      }
    } catch (e) {
      print(e);
      _showErrorDialog('Error occurred. Please try again later.');
    }
  }

  Future<void> _login() async {
    const String url =
        'http://104.237.9.211:8007/karuthal/api/v1/usermanagement/login';
    final Map<String, dynamic> body = {
      "username": _emailController.text,
      "password": _passwordController.text,
    };

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("Create: ,$responseData");
        CreateAccount.bearerToken = responseData['authtoken'];
        print(CreateAccount.bearerToken);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Customerregistration(
                    email: _emailController.text,
                    token: CreateAccount.bearerToken,
                  )),
        );
      } else {
        //ScaffoldMessenger.of(context).showCustomSnackBar(context, "ERROR\nInvalid Entry");
        print('Login failed with status code: ${response.statusCode}');
        print('Error message: ${response.body}');
      }
    } catch (e) {
      //ScaffoldMessenger.of(context).showCustomSnackBar(context, "Network Error");
      print('Error occurred: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        Center(
                          child: Text(
                            'Create Account',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  color: Color(0xFF57CC99),
                                  fontFamily:
                                      GoogleFonts.anekGurmukhi().fontFamily,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40.0,
                                ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildLabelText(context, "Email"),
                        const SizedBox(height: 2),
                        _buildProjectedTextFormField(
                          controller: _emailController,
                          isPassword: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            } else if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildLabelText(context, "Phone Number"),
                        const SizedBox(height: 2),
                        _buildProjectedTextFormField(
                          controller: _PhoneNumberController,
                          isPassword: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            } else if (value.length != 10) {
                              return 'Must be 10 digits';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildLabelText(context, "Password"),
                            Row(children: [
                              IconButton(
                                icon: Icon(
                                  color: Color(0xFF838181),
                                  _isPasswordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              Text(
                                _isPasswordVisible ? 'Unhide' : 'Hide',
                                style: TextStyle(
                                  color: const Color(0xFF838181),
                                  fontSize: 16,
                                ),
                              )
                            ]),
                          ],
                        ),
                        const SizedBox(height: 2),
                        _buildPasswordField(),
                        const SizedBox(height: 40),
                        Center(
                          child: SizedBox(
                            height: 48.0,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF57CC99),
                              ),
                              onPressed: _signUp,
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontFamily: GoogleFonts.signika().fontFamily,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: constraints.maxHeight > 400
                      ? constraints.maxHeight - 400
                      : 0,
                  child: Stack(
                    children: [
                      ClipPath(
                        clipper: BottomWaveClipper(),
                        child: Container(
                          width: double.infinity,
                          color: Color(0xFFC7F9DE),
                        ),
                      ),
                      Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Column(children: [
                            Image.asset(
                              'assets/image.png',
                              height: 275,
                              fit: BoxFit.contain,
                            ),
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 48.0,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                      ),
                                      onPressed: () {},
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Sign in with ",
                                            style: TextStyle(
                                              color: const Color(0xFF57CC99),
                                              fontSize: 20,
                                              fontFamily: GoogleFonts.signika()
                                                  .fontFamily,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Image.asset(
                                            'assets/google_logo.png',
                                            height: 30.0,
                                            width: 30.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Already have an account? ',
                                      style: TextStyle(
                                        color: const Color(0xFF38A3A5),
                                        fontSize: 18,
                                        fontFamily:
                                            GoogleFonts.robotoFlex().fontFamily,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'Log in',
                                          style: TextStyle(
                                            color: const Color(0xFF296685),
                                            fontWeight: FontWeight.normal,
                                            fontFamily: GoogleFonts.robotoFlex()
                                                .fontFamily,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Login()),
                                              );
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ])),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabelText(BuildContext context, String labelText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Text(
        labelText,
        style: TextStyle(
          color: Color(0xFF838181),
          fontSize: 16,
          fontFamily: GoogleFonts.roboto().fontFamily,
        ),
      ),
    );
  }

  Widget _buildProjectedTextFormField({
    required TextEditingController controller,
    required bool isPassword,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          cursorColor: Color(0xFF838181),
          obscureText: isPassword ? !_isPasswordVisible : false,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          ),
          validator: validator,
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return _buildProjectedTextFormField(
      controller: _passwordController,
      isPassword: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        } else if (value.length < 8) {
          return 'Password must be at least 8 characters long';
        } else if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
          return 'Password must contain at least one lowercase letter';
        } else if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
          return 'Password must contain at least one uppercase letter';
        } else if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
          return 'Password must contain at least one digit';
        } else if (!RegExp(r'(?=.*[!@#\$&*~])').hasMatch(value)) {
          return 'Password must contain at least one special character';
        }
        return null;
      },
    );
  }
}
