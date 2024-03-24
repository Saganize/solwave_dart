import 'package:flutter/material.dart';

import '../../utils/color_constants.dart';
import '../../utils/font_style.dart';

void showBackDialog(BuildContext context, VoidCallback? callback) {
  showAdaptiveDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text(
          'Are you sure you want to leave this page?',
        ),
        backgroundColor: ColorConstants.defaultScaffoldBackground,
        titleTextStyle: FontStyles.heading,
        contentTextStyle: FontStyles.paragraph,
        actions: <Widget>[
          TextButton(
            child: Text('Stay', style: FontStyles.paragraph),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text('Leave', style: FontStyles.paragraph),
            onPressed: () {
              Navigator.pop(context);
              if (callback != null) {
                callback();
              }
            },
          ),
        ],
      );
    },
  );
}
