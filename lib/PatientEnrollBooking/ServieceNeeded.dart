import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ServiceNeeded extends StatefulWidget {
  final Function(List selectedValues) onSelectionChanged; // Callback to parent
  final String token;
  //final List<Map<String, String>> services; // List of services

  const ServiceNeeded({
    super.key, 
    required this.onSelectionChanged,
    required this.token, // Accept services as a parameter
  });

  @override
  _ServiceNeededState createState() => _ServiceNeededState();
}

class _ServiceNeededState extends State<ServiceNeeded> {
  late Future<List> serviceAvailable;
  List newservices = [];

  Future<List> getServices() async{
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.token}',
    };
    final serviceList = await http.get(
      Uri.parse("http://104.237.9.211:8007/karuthal/api/v1/metadata/services"),
      headers: headers,
    );
    //print(jsonDecode(serviceList.body)[0]['name']);
    var newservices = jsonDecode(serviceList.body);
    return newservices;
    //print(newservices[1]['name']);
    
  }

  void initState() {
    super.initState();
    serviceAvailable = getServices(); // Call checkServices when the widget is created
    _printServices();
  }

  void _printServices() async {
  try {
    newservices = await serviceAvailable; // Await the future to get the resolved value
    print(newservices); // Now it will print the actual list of services
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
        _selectedValues.remove({"id":id});
      } else {
        // Select the value
        _selectedIds.add(id);
        _selectedPatients.add(value);
        _selectedValues.add({"id":id});
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
                                ? 'Choose Service(s)'
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
                    children: newservices
                        .map((service) => Column(
                              children: [
                                _buildPartition(
                                  service['name'],
                                  service['id'],
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

  Widget _buildPartition(String name, int serviceIdNum) {
    bool isSelected = _selectedIds.contains(serviceIdNum);

    return GestureDetector(
      onTap: () {
        _toggleSelection("$name",serviceIdNum);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$name",
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
