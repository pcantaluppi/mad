// custom_input_field.dart
import 'package:flutter/material.dart';

/// A custom input field widget that provides a labeled text input with optional suffix icon and validation.
class CustomInputField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final String? Function(String?) validator;
  final bool suffixIcon;
  final bool? isDense;
  final bool obscureText;
  final TextEditingController? controller;
  final Icon? icon;

  /// Creates a new [CustomInputField] widget.
  /// The [labelText] is the text to display as the label for the input field.
  /// The [hintText] is the text to display as a hint inside the input field.
  /// The [validator] is a function that validates the input value.
  /// The [suffixIcon] determines whether to show a suffix icon.
  /// The [isDense] determines whether to use a dense layout for the input field.
  /// The [obscureText] determines whether to obscure the text input.
  /// The [controller] is an optional [TextEditingController] to control the input field's text.
  /// The [icon] is an optional icon in front of the text field.
  const CustomInputField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.validator,
    this.suffixIcon = false,
    this.isDense,
    this.obscureText = false,
    this.controller,
    this.icon
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.9,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Center(
              child: Text(
                widget.labelText,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
            ),
          ),
          TextFormField(
            controller: widget.controller,
            obscureText: widget.obscureText && _obscureText,
            decoration: InputDecoration(
              isDense: widget.isDense ?? false,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(),
              ),
              hintText: widget.hintText,
              prefixIcon: widget.icon,
              suffixIcon: widget.suffixIcon
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : null,
            ),
            validator: widget.validator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ],
      ),
    );
  }
}
