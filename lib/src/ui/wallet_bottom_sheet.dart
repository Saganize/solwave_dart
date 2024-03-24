import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/wallet.dart';
import '../utils/size_util.dart';
import '../utils/color_constants.dart';
import '../models/solwave_transaction.dart';
import 'wallet_controller/wallet_controller_view.dart';
import '../core/solwave_view_type.dart';
import 'wallet_controller/wallet_controller_cubit.dart';
import 'widgets/heading.dart';

class SolwaveBottomSheet extends BottomSheet {
  const SolwaveBottomSheet(
      {super.key, required super.onClosing, required super.builder});

  static Future<dynamic> openBottomSheet(
    BuildContext context, {
    required SolwaveViewType type,
    SolanaTransaction? tx,
    String? message,
    Function(WalletEntity)? onWalletSelection,
    Function(String signature, String? message)? onTransacitonComplete,
  }) {
    return showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: getSheetHeight(type),
          decoration: BoxDecoration(
            color: ColorConstants.defaultScaffoldBackground,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              BlocProvider(
                create: (_) =>
                    WalletControllerCubit(selectionCallback: onWalletSelection),
                child: WalletControllerView(
                  type: type,
                  tx: tx,
                  message: message,
                  onTransacitonComplete: onTransacitonComplete,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SolwaveHeading(),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

double getSheetHeight(SolwaveViewType type) {
  if (type == SolwaveViewType.signMessage) {
    return switch (SizeUtil.screenWidth) {
      > 390 && < 431 => 48.sh,
      > 431 => 42.sh,
      _ => 55.sh
    };
  } else if (type == SolwaveViewType.selectWallet) {
    return switch (SizeUtil.screenWidth) {
      > 390 && < 431 => 52.sh,
      > 431 => 50.sh,
      _ => 62.sh
    };
  } else {
    return switch (SizeUtil.screenWidth) {
      > 390 && < 431 => 63.sh,
      > 431 => 58.sh,
      _ => 69.sh
    };
  }
}
