import 'package:flutter/material.dart';

import '../../utils/font_style.dart';

class ShowOtherButton extends StatelessWidget {
  final VoidCallback onTap;
  const ShowOtherButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Text(
              'show other',
              style: FontStyles.captionText.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            const Icon(
              Icons.arrow_drop_down_sharp,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
