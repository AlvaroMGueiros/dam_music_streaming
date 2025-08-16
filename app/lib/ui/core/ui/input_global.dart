import "package:flutter/material.dart";
import "package:provider/provider.dart";

class CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData iconData;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final void Function(String?)? onSaved;

  const CustomInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.iconData,
    this.validator,
    this.onChanged,
    this.onSaved
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: theme.colorScheme.surface,
          border: Border.all(color: theme.dividerColor)),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration.collapsed(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey[600]),
              ),
              validator: validator,
              onChanged: onChanged,
              onSaved: onSaved,
            ),
          ),
          SizedBox(width: 10),
          Icon(
            iconData,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}