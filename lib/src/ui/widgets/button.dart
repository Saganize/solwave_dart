// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/color_constants.dart';
import '../../utils/font_style.dart';

class SolwaveButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final String? icon;
  final double? buttonWidth;
  final bool disableBorder;
  const SolwaveButton({
    Key? key,
    this.onPressed,
    required this.title,
    this.backgroundColor,
    this.textStyle,
    this.icon,
    this.buttonWidth,
    this.disableBorder = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: icon != null
          ? SvgPicture.asset(
              icon!,
              package: 'solwave',
            )
          : const SizedBox.shrink(),
      style: ButtonStyle(
        alignment: Alignment.center,
        backgroundColor: MaterialStateProperty.all<Color>(
            backgroundColor ?? ColorConstants.primaryButtonCTA),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
            side: disableBorder
                ? BorderSide.none
                : const BorderSide(color: Colors.white, width: 0.2),
          ),
        ),
        minimumSize: MaterialStateProperty.all<Size>(
          Size((buttonWidth ?? 0.85) * MediaQuery.of(context).size.width, 50.0),
        ),
        elevation: MaterialStateProperty.all<double>(2.0),
        shadowColor:
            MaterialStateProperty.all<Color>(Colors.black.withOpacity(0.08)),
      ),
      label: Text(
        title,
        style: textStyle ?? FontStyles.paragraph,
      ),
    );
  }
}
