// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/color_constants.dart';
import '../../utils/font_style.dart';
import '../widgets/button.dart';

class WalletErrorView extends StatelessWidget {
  final String error;
  const WalletErrorView({
    Key? key,
    required this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 120),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'lib/assets/error.svg',
                      height: 64,
                      width: 64,
                      package: 'solwave',
                    ),
                    const SizedBox(height: 40),
                    Text('Error Occured', style: FontStyles.subheading),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        error,
                        textAlign: TextAlign.center,
                        style: FontStyles.label.copyWith(
                          color: ColorConstants.secondaryTextColor
                              .withOpacity(0.8),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: SolwaveButton(
                title: 'Close',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
