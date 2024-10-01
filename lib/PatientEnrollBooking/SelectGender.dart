import 'package:flutter/material.dart';

class GenderNeeded extends StatefulWidget {
  final Function(String gender) onSelectionChanged; // Callback to parent
  //final List<Map<String, String>> services; // List of services

  const GenderNeeded({
    super.key, 
    required this.onSelectionChanged,// Accept services as a parameter
  });

  @override
  _GenderNeededState createState() => _GenderNeededState();
}

class _GenderNeededState extends State<GenderNeeded> {
  var genders = ['MALE','FEMALE','TRANSGENDER'];
  bool _isExpanded = false;
  final TextEditingController _controller = TextEditingController();
  String _selectedHintText = 'Choose Service';

  void _addToTextField(String gender) {
    setState(() {
      _selectedHintText = gender;
      _controller.text = gender;
      _controller.selection =
          TextSelection.fromPosition(TextPosition(offset: gender.length));
      _isExpanded = false;
    });

    widget.onSelectionChanged(gender); // Notify the parent of the selection
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
                            hintText: _selectedHintText,
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
                    children: genders
                        .map((gender) => Column(
                              children: [
                                _buildPartition(
                                  gender
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

  Widget _buildPartition(String gender) {
    

    return GestureDetector(
      onTap: () {
        _addToTextField(gender);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: gender,
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
