import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  IconData? icon;
  void Function()? onPressed;
  CustomButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });
  Color _getButtonColor() {
    switch (label) {
      case "View Information":
        return Colors.blue;
      case "Move To The Form":
        return Colors.green;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 25),
      label: Text(label, style: const TextStyle(fontSize: 18)),
      style: ElevatedButton.styleFrom(
        backgroundColor: _getButtonColor(),
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
