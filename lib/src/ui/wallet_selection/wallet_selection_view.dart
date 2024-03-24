import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/wallet_provider.dart';
import '../../utils/color_constants.dart';
import '../../utils/font_style.dart';
import '../../utils/string_constants.dart';
import '../wallet_controller/wallet_controller_cubit.dart';
import '../widgets/loader.dart';
import '../widgets/wallet_tile.dart';
import 'available_wallets.dart';
import 'wallet_selection_cubit.dart';

class WalletSelectionView extends StatelessWidget {
  const WalletSelectionView({
    Key? key,
  }) : super(key: key);

  handlWalletOnTap(BuildContext context, WalletProvider provider) {
    if (provider == WalletProvider.saganize) {
      context.read<WalletSelectionCubit>().selectWallet();
    } else if (provider == WalletProvider.phantom) {
      context
          .read<WalletSelectionCubit>()
          .selectWalletprovider(WalletProvider.phantom);
    } else if (provider == WalletProvider.solflare) {
      context
          .read<WalletSelectionCubit>()
          .selectWalletprovider(WalletProvider.solflare);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletSelectionCubit, WalletSelectionState>(
      listener: (context, state) {
        if (state is WalletAuthFlow) {
          context.read<WalletControllerCubit>().setWalletAuthFlow();
        }

        if (state is WalletSelected) {
          context.read<WalletControllerCubit>().selectWalletCallback(
                state.currentWallet,
              );
        }
      },
      builder: (context, state) {
        if (state is WalletSelectionError) {
          return Container();
        } else if (state is WalletSelected) {
          return _WalletList(
            handleOnTap: handlWalletOnTap,
            state: state,
          );
        } else if (state is WalletNotSelected) {
          return _WalletList(
            handleOnTap: handlWalletOnTap,
          );
        } else {
          return const SolwaveLoader();
        }
      },
    );
  }
}

class _WalletList extends StatelessWidget {
  final Function(BuildContext, WalletProvider) handleOnTap;
  final WalletSelected? state;
  const _WalletList({required this.handleOnTap, this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 90),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              StringConstants.walletSelectionScreenTitle.recomended,
              style: FontStyles.captionText.copyWith(
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          WalletTile(
            iconUri: AvailableWallets.solwave.walletProvider.logo,
            subtitle: state != null &&
                    state!.currentWallet.walletProvider.package ==
                        AvailableWallets.solwave.walletProvider.package
                ? state?.currentWallet.publicAddress
                : null,
            isSelected: state != null &&
                state!.currentWallet.walletProvider.package ==
                    AvailableWallets.solwave.walletProvider.package,
            onTap: () => handleOnTap(context, WalletProvider.saganize),
          ),
          const SizedBox(
            height: 22,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              StringConstants.walletSelectionScreenTitle.otherWallets,
              style: FontStyles.captionText.copyWith(
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            decoration: BoxDecoration(
              color: ColorConstants.tileBackground,
              borderRadius: BorderRadius.circular(6),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: AvailableWallets.otherWallets
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: WalletTile(
                        disabled: !e.available,
                        iconUri: e.walletProvider.logo,
                        title: e.walletProvider.title,
                        subtitle: state != null &&
                                state!.currentWallet.walletProvider.package ==
                                    e.walletProvider.package
                            ? state?.currentWallet.publicAddress
                            : null,
                        isSelected: state != null &&
                            state!.currentWallet.walletProvider.package ==
                                e.walletProvider.package,
                        onTap: () => handleOnTap(
                          context,
                          e.walletProvider,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
