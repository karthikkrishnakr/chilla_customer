import 'package:chilla_customer/design.dart';
import 'package:flutter/material.dart';

class Caretakers extends StatefulWidget {
  const Caretakers({super.key});

  @override
  State<Caretakers> createState() => CaretakersState();
}

class CaretakersState extends State<Caretakers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.grey,
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ClipPath(
                  clipper: BottomWaveClipper(),
                  child: Container(
                    height: 350,
                    width: double.infinity,
                    color: const Color(0xffC7F9DE),
                  ),
                ),
              ),
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 2,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "Available Caretakers",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 2,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildCaretakerButton("Rishikesh"),
                          _buildCaretakerButton("Aswin"),
                          _buildCaretakerButton("Kripa"),
                          _buildCaretakerButton("Adith"),
                          _buildCaretakerButton("Sidharth"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCaretakerButton(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        height: 75,
        width: 270,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFC7F9CC),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            shadowColor: Colors.black.withOpacity(0.2),
            elevation: 5,
          ),
          onPressed: () {},
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                width: 45,
                height: 45,
                decoration: const BoxDecoration(
                  color: Colors.greenAccent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.green,
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

@override
bool shouldReclip(CustomClipper<Path> oldClipper) => false;
