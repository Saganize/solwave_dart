import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/solwave_transaction.dart';
import '../../models/wallet.dart';
import '../../utils/color_constants.dart';
import '../../utils/font_style.dart';
import '../../utils/helpers.dart';
import '../../utils/size_util.dart';
import '../../utils/string_constants.dart';
import '../wallet_controller/wallet_controller_cubit.dart';
import '../webview/solwave_webview.dart';
import '../webview/solwave_webview_cubit.dart';
import '../widgets/button.dart';
import '../widgets/dialog.dart';
import '../widgets/info_card.dart';
import '../widgets/loader.dart';
import '../widgets/transaction_loading_view.dart';
import 'wallet_transaction_cubit.dart';

class WalletTransactionView extends StatefulWidget {
  const WalletTransactionView({
    Key? key,
  }) : super(key: key);

  @override
  State<WalletTransactionView> createState() => _WalletTransactionViewState();
}

class _WalletTransactionViewState extends State<WalletTransactionView> {
  void handleSendTx() {
    context.read<WalletTransactionCubit>().checkForBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.sh,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: BlocConsumer<WalletTransactionCubit, WalletTransactionState>(
        listener: (context, state) {
          final bloc = context.read<WalletControllerCubit>();
          final transactionBloc = context.read<WalletTransactionCubit>();
          if (state is WalletTransactionArppove) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider<WalletControllerCubit>.value(
                  value: bloc,
                  child: BlocProvider<WalletTransactionCubit>.value(
                    value: transactionBloc,
                    child: BlocProvider(
                      create: (_) => SolwaveWebViewCubit(
                        transaction: state.tx,
                      ),
                      child: SolwaveWebview(url: state.url),
                    ),
                  ),
                ),
              ),
            );
          } else if (state is WalletTransactionError) {
            context
                .read<WalletControllerCubit>()
                .setWalletErrorFlow(state.error);
          }
        },
        builder: (context, state) {
          if (state is WalletTransactionLoading ||
              state is WalletTransactionArppove ||
              state is WalletDeeplinkFlow) {
            return PopScope(
              canPop: false,
              onPopInvoked: (didPop) {
                if (didPop) {
                  return;
                }
                showBackDialog(
                  context,
                  () => context
                      .read<WalletControllerCubit>()
                      .forceCloseActivity(),
                );
              },
              child: const SolwaveLoader(),
            );
          } else if (state is WalletTransactionInitiated) {
            return _WalletTransactionIntialized(
              description: state.txInfoBody,
              transaction: state.tx,
              networkFeeText: state.networkFeeText,
              networkFeeTitle: state.networkFeeTitle,
              onPressed: handleSendTx,
              wallet: state.wallet,
            );
          } else if (state is WalletLowFunds) {
            return WalletLowFundsview(
              from: state.wallet.publicAddress!,
              amount: '${state.tx.data.lamports}',
              onPressed: handleSendTx,
              countdown: state.countdown,
            );
          } else if (state is WalletTransactionProcessing) {
            return const TransactionLoadingView(
              widgetType: TransactionProcessing.processing,
            );
          } else if (state is WalletTransactionProcessed) {
            return const TransactionLoadingView(
              widgetType: TransactionProcessing.processed,
            );
          } else if (state is WalletTransactionComplete) {
            return TransactionLoadingView(
              widgetType: TransactionProcessing.complete,
              launchUrl: state.url,
            );
          } else if (state is WalletTransactionFailure) {
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
      ),
    );
  }
}

class _WalletTransactionIntialized extends StatelessWidget {
  final String? description;
  final SolwaveTransaction transaction;
  final String networkFeeText;
  final String networkFeeTitle;
  final VoidCallback onPressed;
  final WalletEntity wallet;

  const _WalletTransactionIntialized({
    required this.description,
    required this.transaction,
    required this.onPressed,
    required this.wallet,
    required this.networkFeeText,
    required this.networkFeeTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 85),
      child: Stack(
        children: [
          Row(
            children: [
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InfoCard(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  StringConstants
                                      .transactionViewEstimatedCharged.title,
                                  style: FontStyles.label.copyWith(
                                    color: ColorConstants.secondaryTextColor
                                        .withOpacity(0.8),
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 22),
                                if (description != null) ...[
                                  Text(
                                    description!,
                                    maxLines: 3,
                                    style: FontStyles.label
                                        .copyWith(color: ColorConstants.yellow),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                                if (transaction.isTransferInstruction) ...[
                                  Text(
                                    '${lamportsToSol(transaction.data.lamports!)} SOL',
                                    style: FontStyles.label
                                        .copyWith(color: ColorConstants.red),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'from : ${truncateString(transaction.data.from!)}',
                                    style: FontStyles.label
                                        .copyWith(color: ColorConstants.green),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'to : ${truncateString(transaction.data.to!)}',
                                    style: FontStyles.label
                                        .copyWith(color: ColorConstants.green),
                                  ),
                                ]
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    InfoCard(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            networkFeeTitle,
                            style: FontStyles.label.copyWith(
                              color: ColorConstants.secondaryTextColor
                                  .withOpacity(0.4),
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            networkFeeText,
                            style: FontStyles.label.copyWith(
                              color: ColorConstants.secondaryTextColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
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
                                wallet.walletProvider.title,
                                style:
                                    FontStyles.subtitle.copyWith(fontSize: 18),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                truncateString(wallet.publicAddress!),
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
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: SolwaveButton(
                title: transaction.isTransferInstruction
                    ? 'Pay ${lamportsToSol(transaction.data.lamports!)} SOL'
                    : 'Pay Now',
                onPressed: onPressed,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class WalletLowFundsview extends StatelessWidget {
  final String from;
  final String amount;
  final VoidCallback onPressed;

  final int? countdown;
  const WalletLowFundsview({
    Key? key,
    required this.from,
    required this.amount,
    required this.onPressed,
    this.countdown,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 90),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: ColorConstants.addFundsIcon,
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: ColorConstants.red.withOpacity(0.2),
                          ),
                          shape: BoxShape.circle),
                      child: Container(
                        margin: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: ColorConstants.red,
                          ),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(16),
                        child: SvgPicture.asset(
                          'lib/assets/recieve_dollar.svg',
                          package: 'solwave',
                          width: 7.sw,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    StringConstants.transactionViewLowBalance.title,
                    style: FontStyles.title,
                  ),
                  const SizedBox(height: 7),
                  Text(
                    StringConstants.transactionViewLowBalance.body,
                    style: FontStyles.subtitleLight.copyWith(
                      color: ColorConstants.secondaryTextColor.withOpacity(0.4),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: from));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: ColorConstants.tileBackground,
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 30),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            truncateString(from),
                            style: FontStyles.subtitle.copyWith(fontSize: 14),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.copy,
                            color: Colors.white,
                            size: 14,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 52),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      'You need ${lamportsToSol(int.tryParse(amount)!)} Sol for the transaction',
                      style: FontStyles.label.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SolwaveButton(
                    title: (countdown != null && countdown! > 0)
                        ? 'Continue in $countdown'
                        : 'Continue',
                    onPressed: (countdown != null && countdown! > 0)
                        ? null
                        : onPressed,
                    backgroundColor: (countdown != null && countdown! > 0)
                        ? ColorConstants.primaryButtonCTA.withOpacity(0.5)
                        : null,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
