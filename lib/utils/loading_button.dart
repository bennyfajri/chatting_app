import 'package:flutter/material.dart';


class LoadingSaveButton extends StatelessWidget {
  const LoadingSaveButton({
    super.key,
    required this.text,
    required this.isLoading,
    required this.onPressed,
  });

  final String text;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: isLoading
                ? Colors.grey
                : Colors.blue,
          ),
          onPressed: onPressed,
          child: isLoading
              ? const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(),
          )
              : Text(text, style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}