import 'package:flutter/material.dart';

import 'color_constants.dart';
import 'size_util.dart';

class FontStyles {
  static TextStyle title = TextStyle(
    fontFamily: 'Rubik',
    package: 'solwave',
    fontSize: 28.scaleFont,
    fontWeight: FontWeight.w600,
    color: ColorConstants.secondaryTextColor,
  );

  static TextStyle heading = TextStyle(
    fontFamily: 'Rubik',
    package: 'solwave',
    fontSize: 24.scaleFont,
    fontWeight: FontWeight.w600,
    color: ColorConstants.secondaryTextColor,
  );

  static TextStyle subheading = TextStyle(
    fontFamily: 'Rubik',
    package: 'solwave',
    fontSize: 22.scaleFont,
    fontWeight: FontWeight.w600,
    color: ColorConstants.secondaryTextColor,
  );

  static TextStyle subtitle = TextStyle(
    fontFamily: 'Poppins',
    package: 'solwave',
    fontSize: 16.scaleFont,
    fontWeight: FontWeight.w600,
    color: ColorConstants.secondaryTextColor,
  );

  static TextStyle subtitleLight = TextStyle(
    fontFamily: 'Poppins',
    package: 'solwave',
    fontSize: 13.scaleFont,
    fontWeight: FontWeight.w300,
    color: ColorConstants.secondaryTextColor,
  );

  static TextStyle captionText = TextStyle(
    fontFamily: 'Inter',
    package: 'solwave',
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: ColorConstants.secondaryTextColor,
  );

  static TextStyle paragraph = TextStyle(
    fontFamily: 'Inter',
    package: 'solwave',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: ColorConstants.secondaryTextColor,
  );

  static TextStyle paragraphLight = TextStyle(
    fontFamily: 'Inter',
    package: 'solwave',
    fontSize: 16,
    fontWeight: FontWeight.w300,
    color: ColorConstants.secondaryTextColor.withOpacity(0.66),
  );

  static TextStyle label = TextStyle(
    fontFamily: 'Inter',
    package: 'solwave',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: ColorConstants.secondaryTextColor,
  );
}
