import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Multiline text input field with modern styling
class TextInputField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final int? maxLines;
  final int? maxLength;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;

  const TextInputField({
    super.key,
    this.label,
    this.hint,
    this.initialValue,
    this.onChanged,
    this.controller,
    this.maxLines = 5,
    this.maxLength,
    this.readOnly = false,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          onChanged: onChanged,
          maxLines: maxLines,
          maxLength: maxLength,
          readOnly: readOnly,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white54
                      : Colors.black54,
                ),
            filled: true,
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}

