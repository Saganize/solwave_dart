// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:solwave/src/ui/wallet_sign_message/wallet_sign_message_cubit.dart';

import '../../core/solwave_view_type.dart';
import '../../models/solwave_transaction.dart';
import '../wallet_auth/wallet_auth_cubit.dart';
import '../wallet_auth/wallet_auth_view.dart';
import '../wallet_error/wallet_error_view.dart';
import '../wallet_selection/wallet_selection_cubit.dart';
import '../wallet_selection/wallet_selection_view.dart';
import '../wallet_sign_message/wallet_sign_message_view.dart';
import '../wallet_transaction/wallet_transaction_cubit.dart';
import '../wallet_transaction/wallet_transaction_view.dart';
import '../widgets/loader.dart';
import 'wallet_controller_cubit.dart';

class WalletControllerView extends StatefulWidget {
  final SolwaveViewType type;
  final SolanaTransaction? tx;
  final String? message;
  final Function(String signature, String? message)? onTransacitonComplete;
  const WalletControllerView({
    Key? key,
    required this.type,
    this.tx,
    this.message,
    this.onTransacitonComplete,
  }) : super(key: key);

  @override
  State<WalletControllerView> createState() => _WalletControllerViewState();
}

class _WalletControllerViewState extends State<WalletControllerView> {
  @override
  void initState() {
    if (widget.type == SolwaveViewType.selectWallet) {
      context.read<WalletControllerCubit>().setWalletSelectionFlow();
    } else if (widget.type == SolwaveViewType.transact) {
      context.read<WalletControllerCubit>().setWalletTransactionFlow();
    } else {
      context.read<WalletControllerCubit>().signMessageFlow();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletControllerCubit, WalletFlowState>(
      listener: (context, state) {
        if (state is WalletFlowCloseActivity ||
            state is WalletFlowForceCloseActivity) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state is WalletFlowLoadingState) {
          return const Center(
            child: SolwaveLoader(),
          );
        } else if (state is WalletFlowAuthState) {
          return BlocProvider(
            create: (_) => WalletAuthCubit(),
            child: const WalletAuthView(),
          );
        } else if (state is WalletFlowTransactionState) {
          return BlocProvider(
            create: (_) => WalletTransactionCubit(
              tx: widget.tx!,
              onTransacitonComplete: widget.onTransacitonComplete,
            ),
            child: const WalletTransactionView(),
          );
        } else if (state is WalletFlowSignMessageState) {
          return BlocProvider(
            create: (_) => WalletSignMessageCubit(
              message: widget.message!,
              onTransacitonComplete: widget.onTransacitonComplete,
            ),
            child: const WalletSignMessageView(),
          );
        } else if (state is WalletFlowSelectionState) {
          return BlocProvider(
            create: (_) => WalletSelectionCubit(),
            child: const WalletSelectionView(),
          );
        } else if (state is WalletFlowErrorState) {
          return WalletErrorView(
            error: state.errorMessage,
          );
        } else {
          return Container();
        }
      },
    );
  }
}
