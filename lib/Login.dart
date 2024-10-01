import 'dart:convert';
import 'package:chilla_customer/CreateAccount.dart';
import 'package:chilla_customer/Error.dart';
import 'package:chilla_customer/dashboard.dart';
import 'package:chilla_customer/design.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  static String bearerToken = "";
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

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
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print(response.body);
        print(jsonDecode(response.body)["assignedRoles"]);
        Login.bearerToken = jsonDecode(response.body)['authtoken'];
        if(!jsonDecode(response.body)["assignedRoles"].contains('Customer')){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Color(0xFF57CC99),
              content: Text(
                'Not a Customer',
              style: TextStyle(color: Colors.black),
              ),
            ),
          );
        }
        else{
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Dashboard(
              email: _emailController.text,
              token: Login.bearerToken,
            )),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFF57CC99),
            content: Text(
              'Please Enter Valid Email or Password',
              style: TextStyle(color: Colors.black),
            ),
          ),
        );
        print('Login failed with status code: ${response.statusCode}');
        print('Error message: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF57CC99),
          content: Text(
            'Network Error',
            style: TextStyle(color: Colors.black),
          ),
        ),
      );
      print('Error occurred: $e');
      if (e is http.ClientException) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFF57CC99),
            content: Text(
              'Network Error',
              style: TextStyle(color: Colors.black),
            ),
          ),
        );
        print('Possible CORS or network error.');
      }
    }
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
                            'Log in',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  color: const Color(0xFF57CC99),
                                  fontFamily:
                                      GoogleFonts.anekGurmukhi().fontFamily,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40,
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
                            } /* else if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }*/
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildLabelText(context, "Password"),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    color: const Color(0xFF838181),
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
                                  style: const TextStyle(
                                    color: Color(0xFF838181),
                                    fontSize: 16,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        _buildPasswordField(),
                        const SizedBox(height: 2),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const work(),
                              ),
                            );
                          },
                          child: _buildLabelText(context, "Forgot Password ?"),
                        ),
                        const SizedBox(height: 40),
                        Center(
                          child: SizedBox(
                            height: 48.0,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF57CC99),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // Call the login function here
                                  _login();
                                }
                              },
                              child: Text(
                                "Log in",
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
                          color: const Color(0xFFC7F9DE),
                        ),
                      ),
                      Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Column(children: [
                            Image.asset(
                              'assets/oldcare2.png',
                              height: 250,
                              fit: BoxFit.contain,
                            ),
                            const Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: 175,
                                    child: Divider(
                                      height: 1,
                                      color: Color(0x66666666),
                                    ),
                                  ),
                                  Text(
                                    "Or",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0x66666666)),
                                  ),
                                  SizedBox(
                                    width: 175,
                                    child: Divider(
                                      height: 1,
                                      color: Color(0x66666666),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const CreateAccount()),
                                  );
                                },
                                child: Text(
                                  'Create an account',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: const Color(0xFF296685),
                                    fontFamily:
                                        GoogleFonts.robotoFlex().fontFamily,
                                    decoration: TextDecoration.underline,
                                    decorationColor: const Color(0xFF296685),
                                  ),
                                ),
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
          color: const Color(0xFF838181),
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
          cursorColor: const Color(0xFF838181),
          obscureText: isPassword ? !_isPasswordVisible : false,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          ),
          validator: validator,
          style: const TextStyle(fontSize: 14),
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
        }
        return null;
      },
    );
  }
}
