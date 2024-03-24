import 'package:flutter/material.dart';
import '../../utils/color_constants.dart';

class InfoCard extends StatelessWidget {
  final Widget child;
  final bool borderEnabled;
  const InfoCard({super.key, required this.child, this.borderEnabled = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: borderEnabled
            ? Border.all(
                color: ColorConstants.borderColor,
              )
            : null,
        borderRadius: BorderRadius.circular(6),
        color: ColorConstants.tileBackground,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: child,
      ),
    );
  }
}
