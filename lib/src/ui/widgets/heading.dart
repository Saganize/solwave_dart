import 'package:flutter/material.dart';

import '../../utils/color_constants.dart';

class SolwaveHeading extends StatelessWidget {
  const SolwaveHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        const Text(
          'Solwave',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Powered by',
              style: TextStyle(
                color: ColorConstants.secondaryTextColor.withOpacity(0.5),
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(width: 4),
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Saga',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      color: ColorConstants.secondaryTextColor.withOpacity(0.5),
                    ),
                  ),
                  TextSpan(
                    text: 'nize',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: ColorConstants.secondaryTextColor.withOpacity(0.5),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
