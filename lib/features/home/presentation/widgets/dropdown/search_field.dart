import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    required this.controller,
    required this.onChanged,
    super.key,
    this.hintText,
  });
  final TextEditingController controller;
  final String? hintText;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 12,
        ),
      ),
      onChanged: onChanged,
    );
  }
}
