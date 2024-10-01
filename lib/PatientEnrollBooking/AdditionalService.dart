import 'package:flutter/material.dart';

class AdditionalService extends StatefulWidget {
  const AdditionalService({super.key});

  @override
  _AdditionalService createState() => _AdditionalService();
}

class _AdditionalService extends State<AdditionalService> {
  bool _isExpanded = false;
  final TextEditingController _controller = TextEditingController();
  String _selectedHintText = 'Choose Service';

  void _addToTextField(String mainText, String hintText) {
    setState(() {
      _selectedHintText = mainText;
      _controller.text = hintText;
      _controller.selection =
          TextSelection.fromPosition(TextPosition(offset: hintText.length));
      _isExpanded = false;
    });
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
                    border: Border.all(color: Color(0xFF57CC99)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPartition('Driving', 'Driving'),
                      const Divider(color: Colors.grey),
                      _buildPartition(
                          'Basic surgical products (wheel chair, walker, stretchers, water and air beds etc)',
                          'Basic surgical products'),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPartition(String mainText, String hintText) {
    final bracketStart = mainText.indexOf('(');
    final bracketEnd = mainText.indexOf(')') + 1;

    String beforeBracketText = mainText;
    String bracketText = '';
    String afterBracketText = '';

    if (bracketStart != -1 && bracketEnd != -1) {
      beforeBracketText = mainText.substring(0, bracketStart);
      bracketText = mainText.substring(bracketStart, bracketEnd);
      afterBracketText = mainText.substring(bracketEnd);
    }

    return GestureDetector(
      onTap: () {
        _addToTextField(mainText, hintText);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: beforeBracketText,
                style: const TextStyle(color: Colors.black),
              ),
              if (bracketText.isNotEmpty)
                TextSpan(
                  text: bracketText,
                  style: const TextStyle(color: Colors.grey),
                ),
              TextSpan(
                text: afterBracketText,
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}