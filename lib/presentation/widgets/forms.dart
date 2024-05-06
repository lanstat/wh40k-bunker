import 'package:flutter/material.dart';

import 'labels.dart';

class TextInput extends StatelessWidget {
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final String label;

  const TextInput({
    super.key,
    required this.controller,
    required this.validator,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(label, labelSize: LabelSize.small,),
        TextFormField(
          controller: controller,
          validator: validator,
          decoration: const InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.grey
                )
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.purple,
                    width: 2
                )
            ),
            border: OutlineInputBorder(),
          ),
        )
      ],
    );
  }
}