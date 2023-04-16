import 'package:flutter/material.dart';

class RefreshButton extends StatelessWidget {
  final Function() onPressed;
  const RefreshButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          Colors.tealAccent,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
      ),
      child: const Text(
        'Refresh',
        style: TextStyle(
          color: Colors.black,
          letterSpacing: 2,
        ),
      ),
    );
  }
}
