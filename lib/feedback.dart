import 'package:chilla_customer/dashboard.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:google_fonts/google_fonts.dart';

class FeedbackPage extends StatefulWidget {
  final String email;
  final String token;
  final int customerId;
  const FeedbackPage(
      {super.key,
      required this.email,
      required this.token,
      required this.customerId});
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  int _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _additionalFeedbackController =
      TextEditingController();

  void _submitFeedback() {
    final feedback = _feedbackController.text;
    final additionalFeedback = _additionalFeedbackController.text;
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Dashboard(
                email: widget.email,
                token: "Bearer ${widget.token}",
              )),
    );
    print('Rating: $_rating');
    print('Feedback: $feedback');
    print('Additional Feedback: $additionalFeedback');
    // Handle feedback submission
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(23.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Post-Shift Feedback",
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(
                            color: const Color(0xFF57CC99),
                            fontFamily: GoogleFonts.anekGurmukhi().fontFamily,
                            fontWeight: FontWeight.normal,
                            fontSize: 27.0,
                          ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Please rate your overall experience',
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(height: 20),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      double maxSize = 53.0;
                      double minSize = 53.0;
                      double availableWidth = constraints.maxWidth;
                      double starSize = math.min(
                          maxSize,
                          math.max(
                              minSize,
                              availableWidth /
                                  12)); // Adjust the divisor as needed
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(5, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _rating = index + 1;
                              });
                            },
                            child: Icon(
                              _rating > index
                                  ? Icons.star_border_purple500_outlined
                                  : Icons.star_border_purple500_outlined,
                              color: _rating > index
                                  ? Colors.amber
                                  : Color(0xFFD9D9D9),
                              size:
                                  starSize, // Responsive star size with constraints
                            ),
                          );
                        }),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Please provide a short review of the service and any comments or suggestions you have:',
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    child: TextField(
                      controller: _feedbackController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Is there anything else you would like to share about this shift?',
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    child: TextField(
                      controller: _additionalFeedbackController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 20), // Adjust padding for responsiveness
                      ),
                      onPressed: _submitFeedback,
                      child: Text(
                        'Submit Feedback',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )));
  }
}
