import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'button.dart';
import 'close_button.dart';

import '../../../solwave.dart';
import '../../utils/color_constants.dart';
import '../../utils/font_style.dart';

enum TransactionProcessing { processing, processed, complete, failure, error }

class TransactionLoadingView extends StatefulWidget {
  final TransactionProcessing widgetType;
  final String? launchUrl;
  final String? description;
  const TransactionLoadingView({
    Key? key,
    required this.widgetType,
    this.launchUrl,
    this.description,
  }) : super(key: key);

  @override
  State<TransactionLoadingView> createState() => TransactionLoadingViewState();
}

class TransactionLoadingViewState extends State<TransactionLoadingView> {
  late String title;
  late String description;
  String footer = '';

  @override
  Widget build(BuildContext context) {
    switch (widget.widgetType) {
      case TransactionProcessing.processing:
        title = 'Processing...';
        description = 'Please wait, while we complete your transaction';
        footer = 'Do not press back or close app';
        break;
      case TransactionProcessing.processed:
        title = 'Transaction Processed';
        description = 'Confirming your transaction...';
        footer = 'Just another moments while we finish things up';
        break;
      case TransactionProcessing.complete:
        title = 'Transaction Complete';
        description = 'Check status on Solscan from below';
        break;
      case TransactionProcessing.failure:
        title = 'Transaction Failed';
        description = widget.description ??
            'Something went wrong while verifying transaction';
        break;
      case TransactionProcessing.error:
        title = 'Error Occured';
        description = 'Error Reason';
        break;
    }

    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.widgetType == TransactionProcessing.complete)
                  SvgPicture.asset(
                    'lib/assets/blue_check.svg',
                    height: 64,
                    width: 64,
                    package: 'solwave',
                  )
                else if (widget.widgetType == TransactionProcessing.failure)
                  SvgPicture.asset(
                    'lib/assets/red_cross.svg',
                    height: 64,
                    width: 64,
                    package: 'solwave',
                  )
                else
                  const SizedBox(
                    height: 64,
                    width: 64,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      backgroundColor: Colors.black,
                      strokeWidth: 8.0,
                    ),
                  ),
                const SizedBox(height: 40),
                Text(title, style: FontStyles.subheading),
                const SizedBox(height: 16),
                Text(
                  description,
                  style: FontStyles.label.copyWith(
                    color: ColorConstants.secondaryTextColor.withOpacity(0.8),
                  ),
                )
              ],
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: widget.widgetType == TransactionProcessing.complete
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.launchUrl != null)
                        SolwaveButton(
                          title: 'View Transaction',
                          buttonWidth: 0.65,
                          disableBorder: true,
                          backgroundColor: ColorConstants.tileBackground,
                          onPressed: () {
                            launchURL(widget.launchUrl!);
                          },
                        ),
                      const SizedBox(width: 15),
                      GestureDetector(
                        onTap: () {
                          shareMessage(
                              'I just sent a transaction on Solana \nurl : ${widget.launchUrl}');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: ColorConstants.tileBackground,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.share,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      )
                    ],
                  )
                : Text(
                    footer,
                    style: FontStyles.label.copyWith(
                      color: ColorConstants.secondaryTextColor.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
          ),
        ),
        if (widget.widgetType == TransactionProcessing.complete ||
            widget.widgetType == TransactionProcessing.failure ||
            widget.widgetType == TransactionProcessing.error)
          const Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(top: 16, right: 6),
              child: SolwaveCloseButton(),
            ),
          )
      ],
    );
  }
}
