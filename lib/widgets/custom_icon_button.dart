import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.label,
    this.onPressed,
    required this.icon,
  });

  final String label;
  final void Function()? onPressed;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: label.text.make(),
    ).h(45).wPCT(context: context, widthPCT: 75).pOnly(bottom: 10);
  }
}
