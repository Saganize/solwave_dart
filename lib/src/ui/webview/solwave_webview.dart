import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../wallet_sign_message/wallet_sign_message_cubit.dart';

import '../../../solwave_dart.dart';
import '../../core/solwave_error.dart';
import '../../utils/color_constants.dart';
import '../wallet_controller/wallet_controller_cubit.dart';
import '../wallet_transaction/wallet_transaction_cubit.dart';
import '../widgets/dialog.dart';
import '../widgets/loader.dart';
import 'models/webview_actions.dart';
import 'solwave_webview_cubit.dart';

class SolwaveWebview extends StatefulWidget {
  final String url;
  const SolwaveWebview({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  State<SolwaveWebview> createState() => _SolwaveWebviewState();
}

class _SolwaveWebviewState extends State<SolwaveWebview> {
  SolwaveTransaction? _transaction;
  String? _signMessage;

  void _onWebViewCreated(InAppWebViewController controller) async {
    await controller.addWebMessageListener(
      WebMessageListener(
        jsObjectName: "Solwave",
        onPostMessage: (message, sourceOrigin, isMainFrame, replyProxy) {
          final webviewResponse = WebViewAction.fromJson(json.decode(message!));

          switch (webviewResponse.action) {
            case WebViewActions.getEmailAndPublicKey:
              context.read<SolwaveWebViewCubit>().saveWallet(
                    webviewResponse.params.publicKey!,
                  );
              break;

            case WebViewActions.close:
              handleWebViewClosingEvents(
                webviewResponse.params.event!,
                webviewResponse.params.message!,
              );
              Navigator.pop(context);
              break;

            case WebViewActions.getTransaction:
              final tx = context.read<SolwaveWebViewCubit>().transaction;
              _transaction = tx;
              if (tx == null) {
                break;
              } else {
                final encodedTx = jsonEncode(stringifyTx(tx));
                final txReponse = {
                  'action': "getTransaction",
                  'value': encodedTx,
                };

                replyProxy.postMessage(jsonEncode(txReponse));
              }
              break;

            case WebViewActions.getMessage:
              final singMessage = context.read<SolwaveWebViewCubit>().message;
              _signMessage = singMessage;
              if (singMessage == null) {
                context
                    .read<WalletControllerCubit>()
                    .setWalletErrorFlow(SolwaveErrorCodes.genericError.name);
              } else {
                final signMessageResponse = {
                  'action': "getMessage",
                  'value': _signMessage,
                };

                replyProxy.postMessage(jsonEncode(signMessageResponse));
              }

              break;

            case WebViewActions.transactionComplete:
              context
                  .read<SolwaveWebViewCubit>()
                  .emiTransactionCallback(webviewResponse.params.signature!);
              break;

            case WebViewActions.onMessageSigned:
              context
                  .read<SolwaveWebViewCubit>()
                  .emiSignMessageCallback(webviewResponse.params.signature!);
              break;
          }
        },
      ),
    );

    await controller.loadUrl(
      urlRequest: URLRequest(
        url: Uri.parse(widget.url),
      ),
    );
  }

  void _onConsoleMessage(
      InAppWebViewController controller, ConsoleMessage message) {
    debugPrint('==============> Console message $message');
  }

  handleWebViewClosingEvents(WebViewClosingEvents event, String message) {
    final bloc = context.read<WalletControllerCubit>();
    return switch (event) {
      WebViewClosingEvents.userCreationSuccess => bloc.closeActivity(),
      WebViewClosingEvents.loginSuccessful => bloc.closeActivity(),
      WebViewClosingEvents.userCreationFailure =>
        bloc.setWalletErrorFlow(message),
      WebViewClosingEvents.loginFailure => bloc.setWalletErrorFlow(message),
      WebViewClosingEvents.transactionCompleted => false,
      WebViewClosingEvents.signingMessageSucces => false,
      WebViewClosingEvents.signingMessageFailed =>
        bloc.setWalletErrorFlow(message),
      WebViewClosingEvents.transactionFailed =>
        bloc.setWalletErrorFlow(message),
      WebViewClosingEvents.serverError => bloc.setWalletErrorFlow(message)
    };
  }

  SolwaveTransactionStringify stringifyTx(SolwaveTransaction tx) {
    return SolwaveTransactionStringify(
      status: tx.status,
      type: tx.type,
      data: TransactionPayloadStringify(
        to: tx.data.to,
        from: tx.data.from,
        fees: tx.data.fees,
        lamports: tx.data.lamports,
        transaction: jsonEncode(tx.data.transaction),
      ),
    );
  }

  void onForceClose({bool authFlow = false}) {
    Navigator.pop(context);
    context.read<WalletControllerCubit>().forceCloseActivity(
          authFlow: authFlow,
        );
  }

  @override
  Widget build(BuildContext ctx) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }

        if (_transaction != null || _signMessage != null) {
          showBackDialog(context, () => onForceClose());
        } else {
          showBackDialog(context, () => onForceClose(authFlow: true));
        }
      },
      child: Stack(
        children: [
          InAppWebView(
            onWebViewCreated: _onWebViewCreated,
            onConsoleMessage: _onConsoleMessage,
            onLoadStart: (controller, uri) {
              context.read<SolwaveWebViewCubit>().setLoading();
            },
            onLoadStop: (controller, url) {
              context.read<SolwaveWebViewCubit>().setLoadend();
            },
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                javaScriptEnabled: true,
                javaScriptCanOpenWindowsAutomatically: true,
                cacheEnabled: true,
              ),
            ),
          ),
          BlocConsumer<SolwaveWebViewCubit, SolWaveWebViewState>(
              listener: (ctx, state) {
            if (state is WebViewTransactionSuccessful) {
              context
                  .read<WalletTransactionCubit>()
                  .updateSignatures(state.signatures);
            }

            if (state is WebViewSignMessageSuccessful) {
              context
                  .read<WalletSignMessageCubit>()
                  .updateSignatures(state.signatures);
            }

            if (state is WebViewWalletSaved) {
              context.read<WalletControllerCubit>().selectWalletCallback(
                    state.currentWallet,
                  );
            }
          }, builder: (ctx, state) {
            if (state is WebViewLoading) {
              return Container(
                color: ColorConstants.defaultScaffoldBackground,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: const SolwaveLoader(),
              );
            } else {
              return const SizedBox.shrink();
            }
          })
        ],
      ),
    );
  }
}
