import 'package:flutter/material.dart';

class CustomCityButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final bool? centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  const CustomCityButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.centerTitle,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: GestureDetector(
        onTap: onPressed,
        child: ListTile(
          title: Text(
            textAlign: centerTitle == null ? TextAlign.start : TextAlign.center,
            text,
            style: TextStyle(color: foregroundColor ?? Theme.of(context).colorScheme.inversePrimary),
          ),
        ),
      ),
    );
  }
}
