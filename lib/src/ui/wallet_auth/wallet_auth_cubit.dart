import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/constants.dart';
import '../../models/api_response/initiate_auth_response.dart';

import '../../models/wallet.dart';
import '../../repository/repository.dart';

enum AuthFlowOptions { login, singup, landing }

class WalletAuthCubit extends Cubit<WalletAuthState> {
  WalletAuthCubit() : super(WalletAuthLoading()) {
    repo = Repository.instance;
    FirebaseAuth.instance.userChanges().listen(
      (User? user) async {
        if (!isClosed) {
          if (user != null) {
            final w = await getUserPublicKey();
            if (w != null) {
              emit(WalletAuthenticated(user: user));
            }
          } else {
            emit(WalletUnAuthenticated());
          }
        }
      },
    );
  }

  late final Repository repo;

  Future<WalletEntity?> getUserPublicKey() async {
    final wallet = await repo.getCurrentWallet();
    return wallet;
  }

  void emitAuthState(InitiateAuthResponse user, {required bool login}) {
    final path = login ? 'login' : 'register';
    final webviewUrl =
        'https://saganize-transaction-website-git-flutter-cdhiraj40.vercel.app/${user.authIdempotencyId}/$path?access-token=${user.accessToken}&api-key=${ApiKeyConstants.apiKey}&email=${user.email}&platform=flutter';
    emit(
      WalletWebViewAuth(
        url: webviewUrl,
      ),
    );
  }

  void authFlow({bool login = true}) async {
    emit(WalletAuthLoading());
    if (login) {
      final (success, failure) = await repo.login();
      if (success != null) {
        if (success.data == null) {
          emit(WalletAuthError(error: success.errors?.first.message ?? ''));
        } else {
          emitAuthState(success.data!, login: login);
        }
      } else if (failure != null) {
        emit(WalletAuthError(error: failure.message));
      }
    } else {
      final (success, failure) = await repo.createUser();

      if (success != null) {
        if (success.data == null) {
          emit(WalletAuthError(error: success.errors?.first.message ?? ''));
        } else {
          emitAuthState(success.data!, login: login);
        }
      } else if (failure != null) {
        emit(WalletAuthError(error: failure.message));
      }
    }
  }

  void updateFlow(AuthFlowOptions authFlow) {
    if (state is WalletUnAuthenticated) {
      emit(
        WalletUnAuthenticated(
          authFlow: authFlow,
        ),
      );
    }
  }

  void setUserWallet({required WalletEntity wallet}) async {
    final result = await repo.addCurrentWallet(wallet: wallet);
    if (result) {
    } else {
      emit(WalletAuthError(error: 'Something went wrong'));
    }
  }
}

abstract class WalletAuthState {}

class WalletAuthLoading extends WalletAuthState {}

class WalletAuthError extends WalletAuthState {
  final String error;
  WalletAuthError({required this.error});
}

class WalletWebViewAuth extends WalletAuthState {
  final String url;
  WalletWebViewAuth({
    required this.url,
  });
}

class WalletAuthenticated extends WalletAuthState {
  final User user;
  WalletAuthenticated({required this.user});
}

class WalletUnAuthenticated extends WalletAuthState {
  final AuthFlowOptions authFlow;
  WalletUnAuthenticated({this.authFlow = AuthFlowOptions.landing});
}
