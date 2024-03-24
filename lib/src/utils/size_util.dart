import 'package:flutter/material.dart';

class SizeUtil {
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;

  static late TextScaler textMultiplier;
  static late double imageSizeMultiplier;
  static late double heightMultiplier;

  static scaleText(int fontSize) => textMultiplier.scale(fontSize.toDouble());

  static void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    textMultiplier = MediaQuery.of(context).textScaler;

    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    imageSizeMultiplier = blockSizeHorizontal;
    heightMultiplier = blockSizeVertical;
  }
}

extension FontScaler on int {
  get scaleFont => SizeUtil.scaleText(this);

  get sw => SizeUtil.blockSizeHorizontal * this;
  get sh => SizeUtil.blockSizeVertical * this;
}
