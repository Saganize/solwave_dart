import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'wallet_sign_message_cubit.dart';
import '../widgets/loader.dart';

import '../../utils/color_constants.dart';
import '../../utils/font_style.dart';
import '../../utils/string_constants.dart';
import '../wallet_controller/wallet_controller_cubit.dart';
import '../webview/solwave_webview.dart';
import '../webview/solwave_webview_cubit.dart';
import '../widgets/button.dart';
import '../widgets/dialog.dart';
import '../widgets/info_card.dart';
import '../widgets/transaction_loading_view.dart';

class WalletSignMessageView extends StatelessWidget {
  const WalletSignMessageView({super.key});

  void handleSignMessage() {}

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletSignMessageCubit, WalletSignMessageState>(
      listener: (context, state) {
        final bloc = context.read<WalletControllerCubit>();
        final signMessageBloc = context.read<WalletSignMessageCubit>();
        if (state is WalletSignMessageSign) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider<WalletControllerCubit>.value(
                value: bloc,
                child: BlocProvider<WalletSignMessageCubit>.value(
                  value: signMessageBloc,
                  child: BlocProvider(
                    create: (_) => SolwaveWebViewCubit(
                      message: state.message,
                    ),
                    child: SolwaveWebview(url: state.url),
                  ),
                ),
              ),
            ),
          );
        } else if (state is WalletSignMessageError) {
          context.read<WalletControllerCubit>().setWalletErrorFlow(state.error);
        } else if (state is WalletSignMessageClose) {
          context.read<WalletControllerCubit>().closeActivity();
        }
      },
      builder: (context, state) {
        if (state is WalletSignMessageLoading ||
            state is WalletDeeplinkFlow ||
            state is WalletSignMessageSign) {
          return PopScope(
            canPop: false,
            onPopInvoked: (didPop) {
              if (didPop) {
                return;
              }
              showBackDialog(
                context,
                () =>
                    context.read<WalletControllerCubit>().forceCloseActivity(),
              );
            },
            child: const SolwaveLoader(),
          );
        } else if (state is WalletSignMessageInit) {
          return Padding(
            padding: const EdgeInsets.only(top: 100.0, left: 16, right: 16),
            child: Stack(
              children: [
                Column(
                  children: [
                    InfoCard(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  StringConstants.singMessageTitle,
                                  style: FontStyles.label.copyWith(
                                    color: ColorConstants.secondaryTextColor
                                        .withOpacity(0.8),
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  state.message,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: FontStyles.label.copyWith(
                                    color: ColorConstants.secondaryTextColor
                                        .withOpacity(0.5),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    InfoCard(
                      borderEnabled: false,
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                StringConstants.transactionWalletText,
                                style: FontStyles.label.copyWith(
                                  color: ColorConstants.secondaryTextColor
                                      .withOpacity(0.4),
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                state.wallet.walletProvider.title,
                                style:
                                    FontStyles.subtitle.copyWith(fontSize: 18),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                truncateString(state.wallet.publicAddress!),
                                style: FontStyles.captionText.copyWith(
                                  color: ColorConstants.secondaryTextColor
                                      .withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: SolwaveButton(
                      title: 'Sign Message',
                      onPressed: () {
                        context.read<WalletSignMessageCubit>().signMessage();
                      },
                    ),
                  ),
                )
              ],
            ),
          );
        } else if (state is WalletSignMessageProcessing) {
          return const TransactionLoadingView(
            widgetType: TransactionProcessing.processing,
          );
        } else if (state is WalletSignMessageComplete) {
          return TransactionLoadingView(
            widgetType: TransactionProcessing.complete,
            launchUrl: state.url,
          );
        } else if (state is WalletSignMessageFailure) {
          return TransactionLoadingView(
            widgetType: TransactionProcessing.failure,
            description: state.failureMessage,
          );
        } else {
          return const TransactionLoadingView(
            widgetType: TransactionProcessing.error,
          );
        }
      },
    );
  }
}
