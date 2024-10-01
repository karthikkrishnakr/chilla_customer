import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SelectPatient extends StatefulWidget {
  final Function(List patients) onSelectionChanged; // Callback to parent
  final String token;
  final int customerId;
  //final List<Map<String, String>> services; // List of services

  const SelectPatient({
    super.key, 
    required this.onSelectionChanged,
    required this.token, 
    required this.customerId
  });

  @override
  _SelectPatientState createState() => _SelectPatientState();
}

class _SelectPatientState extends State<SelectPatient> {
  late Future<List> patientsAvailable;
  List patients = [];

  Future<List> getPatients() async{
    final apiUrl = "http://104.237.9.211:8007/karuthal/api/v1/persona/patientsby/${widget.customerId}";
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.token}',
    };
    final patientList = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );
    print("Check: ${jsonDecode(patientList.body)}");
    var registeredPatients = jsonDecode(patientList.body);
    return registeredPatients;
    //print(newservices[1]['name']);
    
  }

  void initState() {
    super.initState();
    patientsAvailable = getPatients(); // Call checkServices when the widget is created
    _printPatients();
  }

  void _printPatients() async {
  try {
    patients = await patientsAvailable; // Await the future to get the resolved value
    print(patients); // Now it will print the actual list of services
  } catch (e) {
    print('Error fetching services: $e'); // Handle error if needed
  }
}

  bool _isExpanded = false;
  final TextEditingController _controller = TextEditingController();
  List<int> _selectedIds = [];
  List<String> _selectedPatients = [];
  List<Map<String, int>> _selectedValues = [];

  void _toggleSelection(String value,int id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        // Deselect the value
        _selectedIds.remove(id);
        _selectedPatients.remove(value);
        _selectedValues.remove({"patientId":id});
      } else {
        // Select the value
        _selectedIds.add(id);
        _selectedPatients.add(value);
        _selectedValues.add({"patientId":id});
      }

      // Update the text field with the selected values
      _controller.text = _selectedPatients.join(', ');

      // Close the dropdown after selection (optional)
      // _isExpanded = false;
    });

    // Notify the parent of the selection change
    // if(!_isExpanded){
    //   widget.onSelectionChanged(_selectedValues);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                    if(!_isExpanded){
                      widget.onSelectionChanged(_selectedValues);
                    }
                  });
                },
                child: Container(
                  width: constraints.maxWidth,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: _selectedValues.isEmpty
                                ? 'Choose Patient(s)'
                                : _selectedValues.join(', '),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                      ),
                      Icon(
                        _isExpanded
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
              if (_isExpanded)
                Container(
                  width: constraints.maxWidth,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF57CC99)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: patients
                        .map((patient) => Column(
                              children: [
                                _buildPartition(
                                  patient['firstName'],
                                  patient['lastName'],
                                  patient['patientId']
                                ),
                                const Divider(color: Colors.grey),
                              ],
                            ))
                        .toList(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPartition(String firstName, String lastName, int patientIdNum) {
    bool isSelected = _selectedIds.contains(patientIdNum);

    return GestureDetector(
      onTap: () {
        _toggleSelection("$firstName $lastName",patientIdNum);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$firstName $lastName",
              style: TextStyle(
                color: isSelected ? Colors.green : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                color: Colors.green,
              ),
          ],
        ),
      ),
    );
  }

  

  

  
}
