import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  final String label;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: label.text.size(18).make(),
    ).h(45).wPCT(context: context, widthPCT: 75).pOnly(bottom: 10);
  }
}
