import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/color_constants.dart';
import '../../utils/font_style.dart';
import '../../utils/size_util.dart';
import '../../utils/string_constants.dart';
import '../wallet_controller/wallet_controller_cubit.dart';
import '../webview/solwave_webview.dart';
import '../webview/solwave_webview_cubit.dart';
import '../widgets/button.dart';
import '../widgets/loader.dart';
import 'wallet_auth_cubit.dart';

class WalletAuthView extends StatelessWidget {
  const WalletAuthView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletAuthCubit, WalletAuthState>(
      listener: (context, state) {
        final bloc = context.read<WalletControllerCubit>();
        if (state is WalletWebViewAuth) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider<WalletControllerCubit>.value(
                value: bloc,
                child: BlocProvider(
                  create: (_) => SolwaveWebViewCubit(),
                  child: SolwaveWebview(url: state.url),
                ),
              ),
            ),
          );
        } else if (state is WalletAuthError) {
          context.read<WalletControllerCubit>().setWalletErrorFlow(state.error);
        }
      },
      builder: (context, state) {
        if (state is WalletAuthLoading) {
          return
              //  PopScope(
              //   canPop: false,
              //   onPopInvoked: (didPop) {
              //     if (didPop) {
              //       return;
              //     }
              //     showBackDialog(
              //       context,
              //       () =>
              //           context.read<WalletControllerCubit>().forceCloseActivity(),
              //     );
              //   },
              //   child:

              const SolwaveLoader();
          // );
        } else if (state is WalletUnAuthenticated) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: ColorConstants.authBackgroundColors,
              ),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: SvgPicture.asset(
                    'lib/assets/rhombus.svg',
                    width: 62.sw,
                    fit: BoxFit.fitWidth,
                    package: 'solwave',
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Transform.scale(
                    scale: -1.0,
                    child: SvgPicture.asset(
                      'lib/assets/rhombus.svg',
                      width: 62.sw,
                      fit: BoxFit.fitWidth,
                      package: 'solwave',
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: (state).authFlow != AuthFlowOptions.landing
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  children: [
                    if ((state).authFlow == AuthFlowOptions.singup)
                      const _NewAccountFlow()
                    else if ((state).authFlow == AuthFlowOptions.login)
                      const _LoginFlow()
                    else
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 4.sh,
                          ),
                          SvgPicture.asset(
                            'lib/assets/saganize.svg',
                            width: 50,
                            height: 50,
                            package: 'solwave',
                          ),
                          SizedBox(height: 5.sh),
                          Text(
                            'One account for \n secure transactions',
                            textAlign: TextAlign.center,
                            style: FontStyles.heading,
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'SAGAnize becomes a secure wallet that stores \n all the funds for easy and safe transactions.',
                            textAlign: TextAlign.center,
                            style: FontStyles.paragraph.copyWith(
                              fontSize: 13,
                              color: ColorConstants.secondaryTextColor
                                  .withOpacity(0.4),
                            ),
                          ),
                          SizedBox(height: 5.sh),
                          SolwaveButton(
                            title: 'Create new account',
                            onPressed: () {
                              context
                                  .read<WalletAuthCubit>()
                                  .updateFlow(AuthFlowOptions.singup);
                            },
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Text(
                                StringConstants.authfooterText.$1,
                                style: FontStyles.paragraphLight
                                    .copyWith(fontSize: 12),
                              ),
                              GestureDetector(
                                onTap: () {
                                  context
                                      .read<WalletAuthCubit>()
                                      .updateFlow(AuthFlowOptions.login);
                                },
                                child: Text(
                                  StringConstants.authfooterText.$2,
                                  style: FontStyles.paragraph
                                      .copyWith(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class _NewAccountFlow extends StatelessWidget {
  const _NewAccountFlow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 130),
          Text(
            StringConstants.authScreenNewAccountTitle,
            style: FontStyles.heading,
          ),
          const SizedBox(height: 10),
          Text(
            StringConstants.authScreenNewAccountSubtitle,
            style: FontStyles.paragraphLight,
          ),
          const SizedBox(height: 68),
          Text(
            StringConstants.authConnectEmail,
            style: FontStyles.paragraph,
          ),
          const SizedBox(height: 20),
          SolwaveButton(
            title: 'Connect with Google',
            icon: 'lib/assets/google.svg',
            onPressed: () {
              context.read<WalletAuthCubit>().authFlow(login: false);
            },
            backgroundColor: Colors.white,
            textStyle: FontStyles.paragraph.copyWith(color: Colors.black),
          )
        ],
      ),
    );
  }
}

class _LoginFlow extends StatelessWidget {
  const _LoginFlow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 130),
          Text(
            StringConstants.authScreenLoginTitle,
            style: FontStyles.heading,
          ),
          const SizedBox(height: 10),
          Text(
            StringConstants.authScreenLoginSubtitle,
            style: FontStyles.paragraphLight,
          ),
          const SizedBox(height: 68),
          Text(
            StringConstants.authConnectEmail,
            style: FontStyles.paragraph,
          ),
          const SizedBox(height: 20),
          SolwaveButton(
            title: 'Connect with Google',
            icon: 'lib/assets/google.svg',
            onPressed: () {
              context.read<WalletAuthCubit>().authFlow();
            },
            backgroundColor: Colors.white,
            textStyle: FontStyles.paragraph.copyWith(color: Colors.black),
          )
        ],
      ),
    );
  }
}
