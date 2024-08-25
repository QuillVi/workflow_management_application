import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class AppDropdown<T> extends StatefulWidget {
  List<DropdownMenuItem<T>> dropdownMenuItemList;
  Function(dynamic) onChanged;
//  Function()? onClear;
  T? value;
  final String hint;
  final String label;

  final bool isEnabled;
//  final Widget? clearWidget;
  final double? hightDropdown;

  AppDropdown({
    super.key,
    required this.dropdownMenuItemList,
    required this.onChanged,
    required this.label,
    // required this.onClear,

    required this.hint,
    required this.value,
    this.hightDropdown,
    this.isEnabled = true,
    // required this.clearWidget,
  });

  @override
  State<AppDropdown> createState() => _AppDropdownState<T>();
}

class _AppDropdownState<T> extends State<AppDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2(
      dropdownStyleData: const DropdownStyleData(
        decoration: BoxDecoration(color: Colors.white),
        maxHeight: 300,
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        // filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      isExpanded: true,
      hint: Text(
        widget.hint,
        style: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 12,
        ),
      ),
      value: widget.value,
      buttonStyleData: ButtonStyleData(height: widget.hightDropdown ?? 50),
      items: widget.dropdownMenuItemList,
      onChanged: widget.onChanged,
    );
  }
}
