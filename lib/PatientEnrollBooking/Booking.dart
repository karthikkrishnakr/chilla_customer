import 'package:chilla_customer/PatientEnrollBooking/AdditionalService.dart';
import 'package:chilla_customer/PatientEnrollBooking/SelectPatient.dart';
import 'package:chilla_customer/PatientEnrollBooking/ServieceNeeded.dart';
import 'package:chilla_customer/PatientEnrollBooking/SelectGender.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookService extends StatefulWidget {
  final String token;
  final int customerId;
  const BookService({super.key, required this.token, required this.customerId});

  @override
  State<BookService> createState() => _BookServiceState();
}

class _BookServiceState extends State<BookService> {

  var selectedServices,selectedPatients,selectedGender;

  Future<void> bookRequest() async {
    final url = 'http://104.237.9.211:8007/karuthal/api/v1/bookingrequest/create';
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${widget.token}',
    };

    final body = jsonEncode({
      "enrolledByCustomer": {"customerId": widget.customerId},
      "requestedServices" : selectedServices,
      "preferredGender" : selectedGender,
      "requestedFor" : selectedPatients
    });

    print(body);

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);
      
      if (response.statusCode == 200) {
        print("Booking Successful");
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.greenAccent,
            iconTheme: IconThemeData(color: Colors.white)),
        drawer: Drawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Text(
                  'Select the services required',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.black,
                        fontFamily: GoogleFonts.anekGurmukhi().fontFamily,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                ),
                _buildLabelText(context, "Service Needed"),
                SizedBox(
                  height: 5,
                ),
                ServiceNeeded(
                    onSelectionChanged: (selectedService) {
                      print('Selected Service: $selectedService');
                      selectedServices = selectedService;
                    },
                    token: widget.token,
                  ),
                SizedBox(height: 20),
                _buildLabelText(context, "Additional Service"),
                AdditionalService(),
                SizedBox(height: 20),
                _buildLabelText(context, "Caretaker Gender"),
                GenderNeeded(
                  onSelectionChanged: (gender) {
                    selectedGender = gender;
                  },
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  'Select patients',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.black,
                        fontFamily: GoogleFonts.anekGurmukhi().fontFamily,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                ),
                SizedBox(height: 30),
                _buildLabelText(context, "Patients list"),
                SelectPatient(
                  onSelectionChanged: (patients){
                    selectedPatients = patients;
                    print(patients);
                  },
                  token: widget.token,
                  customerId: widget.customerId
                ),
                SizedBox(height: 80),
                Center(
                  child: SizedBox(
                    height: 48.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF57CC99),
                      ),
                      onPressed: () {
                        bookRequest();
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => Dashboard(email: "", token: widget.token,),
                        //     ));
                      },
                      child: Text(
                        "Book",
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
      ),
    );
  }
}

Widget _buildLabelText(BuildContext context, String labelText) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: Text(
      labelText,
      style: TextStyle(
        color: Colors.black,
        fontSize: 22,
        fontFamily: GoogleFonts.roboto().fontFamily,
      ),
    ),
  );
}
