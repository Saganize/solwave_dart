import 'package:flutter/material.dart';

import '../../utils/color_constants.dart';

class SolwaveCloseButton extends StatelessWidget {
  const SolwaveCloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorConstants.buttonColor,
        ),
        padding: const EdgeInsets.all(12),
        child: const Icon(
          Icons.close,
          color: Colors.white,
        ),
      ),
    );
  }
}
