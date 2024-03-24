import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/color_constants.dart';
import '../../utils/font_style.dart';
import '../../utils/string_constants.dart';

class WalletTile extends StatelessWidget {
  final String iconUri;
  final String? title;
  final String? subtitle;
  final bool? isSelected;
  final VoidCallback onTap;
  final bool disabled;
  const WalletTile({
    Key? key,
    required this.iconUri,
    required this.onTap,
    this.title,
    this.subtitle,
    this.isSelected = false,
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (isSelected! || disabled) ? null : onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: ColorConstants.tileBackground,
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconUri,
              width: 30,
              height: 30,
              package: 'solwave',
            ),
            const SizedBox(
              width: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: disabled
                        ? FontStyles.subtitle.copyWith(
                            color: ColorConstants.secondaryTextColor
                                .withOpacity(0.3),
                          )
                        : FontStyles.subtitle,
                  )
                else
                  RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Saga',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: ColorConstants.secondaryTextColor,
                          ),
                        ),
                        TextSpan(
                          text: 'nize',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            color: ColorConstants.secondaryTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (subtitle != null) ...[
                  const SizedBox(
                    height: 7,
                  ),
                  Text(
                    truncateString(subtitle!),
                    style: FontStyles.captionText.copyWith(
                        color:
                            ColorConstants.secondaryTextColor.withOpacity(0.6)),
                  )
                ]
              ],
            ),
            const Spacer(),
            Text(
              isSelected!
                  ? StringConstants.selectedButtonCTA
                  : StringConstants.selectionButtonCTA,
              style: isSelected!
                  ? FontStyles.captionText
                      .copyWith(color: ColorConstants.primaryButtonCTA)
                  : disabled
                      ? FontStyles.captionText.copyWith(
                          color: ColorConstants.secondaryTextColor
                              .withOpacity(0.3),
                        )
                      : FontStyles.captionText,
            ),
            const SizedBox(
              width: 22,
            ),
          ],
        ),
      ),
    );
  }
}
