import 'package:flutter/material.dart';

class CustomCityButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  const CustomCityButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onPressed,
        title: Text(text, style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary)),
      ),
    );
  }
}
