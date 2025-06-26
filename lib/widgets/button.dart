import 'package:flutter/material.dart';

class OrangeButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool enabled;

  const OrangeButton({
    super.key,
    this.text = "Order Food",
    required this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: enabled ? onPressed : null,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: enabled ? const Color(0xffF25700) : Colors.grey,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
