import 'package:flutter/material.dart';
import 'package:nobetcieczane/core/base/entities/selectable.dart';

/// SelectableListItem is a StatelessWidget that
/// contains the selectable list item.
class SelectableListItem extends StatelessWidget {
  /// SelectableListItem constructor
  const SelectableListItem({
    required this.item,
    required this.isDarkMode,
    required this.onTap,
    super.key,
  });
  final Selectable item;
  final bool isDarkMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      tileColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
      title: Text(
        item.cities,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
      onTap: onTap,
    );
  }
}
