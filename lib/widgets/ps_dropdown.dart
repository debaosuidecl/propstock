import 'package:flutter/material.dart';

class PSDropdown extends StatelessWidget {
  String? selectedValue;
  void Function(String?)? onChanged;
  List<String> itemsToSelect;
  PSDropdown({
    super.key,
    required this.selectedValue,
    required this.onChanged,
    required this.itemsToSelect,
  });
  // setState(() {
  //   selectedValue = newValue;
  // });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .25,
      padding: EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 8,
      ),
      // color: Colors.green,
      decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xffCBDFF7),
            width: 1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(
            8,
          ))),
      child: DropdownButton<String>(
        isExpanded: true,
        isDense: true,
        borderRadius: BorderRadius.zero,
        underline: SizedBox(),
        value: selectedValue,
        icon: const Icon(
          Icons.keyboard_arrow_down,
          weight: .5,
          color: Color(0xffCBDFF7),
        ),
        iconSize: 24,
        alignment: Alignment.topRight, // Align the icon to the right
        onChanged: onChanged,
        items: itemsToSelect.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value.isEmpty ? "Add no." : value, // Display the placeholder text
              style: TextStyle(
                fontSize: 14,
                color: value == ""
                    ? Colors.grey
                    : Colors.black, // Style for placeholder item
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
