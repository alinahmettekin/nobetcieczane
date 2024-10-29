import 'package:flutter/material.dart';

class CustomCityLabel extends StatelessWidget {
  final Color? backgroundColor;
  final void Function()? onTrailingTap;
  final void Function()? onTap;
  final bool? centerTitle;
  final String text;
  final Color? foregroundColor;

  const CustomCityLabel({
    super.key,
    this.backgroundColor,
    this.centerTitle,
    required this.text,
    this.foregroundColor,
    this.onTrailingTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: ListTile(
          title: Text(
            textAlign: centerTitle == null ? TextAlign.start : TextAlign.center,
            text,
            style: TextStyle(color: foregroundColor ?? Theme.of(context).colorScheme.inversePrimary),
          ),
          trailing: IconButton(
            onPressed: onTrailingTap,
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
