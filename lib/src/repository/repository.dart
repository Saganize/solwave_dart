import 'package:pinenacl/ed25519.dart';
import 'package:solana/dto.dart';
import 'package:solana/solana.dart';

import '../core/constants.dart';
import '../core/solwave_error.dart';
import '../models/api_request/initiate_sign_message_request.dart';
import '../models/api_request/initiate_transaction_request.dart';
import '../models/api_request/simulate_transaction_request.dart';
import '../models/api_response/initiate_auth_response.dart';
import '../models/api_response/initiate_sign_message_response.dart';
import '../models/api_response/intiate_transaction_response.dart';
import '../models/api_response/simulate_transaction_response.dart';
import '../models/base_response.dart';
import '../models/wallet.dart';
import 'api_repository.dart';
import 'local_storage_respository.dart';

class Repository {
  late final LocalStorageRepository _localStorageRepository;
  late final ApiRepository _apiRepository;

  late final SolanaClient _solanaRpc;

  Repository._() {
    _apiRepository = ApiRepository();
    _localStorageRepository = LocalStorageRepository();
    _solanaRpc = SolanaClient(
      rpcUrl: Uri.parse(SolanaRpc.devnet.rpc),
      websocketUrl: Uri.parse(SolanaRpc.devnet.wss),
    );
  }

  static final Repository _instance = Repository._();
  static Repository get instance => _instance;

  Future<WalletEntity?> getCurrentWallet() async {
    return _localStorageRepository.getCurrentWallet();
  }

  Future<bool> deleteWallet() async {
    return _localStorageRepository.deleteWallet();
  }

  Future<bool> addCurrentWallet({required WalletEntity wallet}) async {
    return _localStorageRepository.addWalletToStorage(wallet);
  }

  Future<bool> saveConnectedWallets(ConnectedWallets wallets) async {
    return _localStorageRepository.saveConnectedWallets(wallets);
  }

  Future<ConnectedWallets?> getConnectedWallets() async {
    return _localStorageRepository.getConnectedWallets();
  }

  Future<bool> saveKeypair(PrivateKey secretKey) async {
    return _localStorageRepository.saveKeypair(secretKey);
  }

  Future<PrivateKey?> getKeypair() async {
    return _localStorageRepository.getKeypair();
  }

  Future<(BaseResponse<InitiateAuthResponse?>?, SolwaveError?)> login() async {
    return _apiRepository.login();
  }

  Future<(BaseResponse<SimulateTransactionResponse>?, SolwaveError?)>
      simulateTransaction(
          {required SimulateTransactionRequest requestBody}) async {
    return _apiRepository.simulateTransaction(requestBody: requestBody);
  }

  Future<(BaseResponse<InitiateTransactionResponse>?, SolwaveError?)>
      initiateTransaction(
          {required InitiateTransactionRequest requestBody}) async {
    return _apiRepository.initiateTransaction(requestBody: requestBody);
  }

  Future<(BaseResponse<InitiateSignMessageResponse>?, SolwaveError?)>
      signMessage({required InitiateSignMessageRequest requestBody}) async {
    return _apiRepository.signMessage(requestBody: requestBody);
  }

  Future<(BaseResponse<InitiateAuthResponse?>?, SolwaveError?)>
      createUser() async {
    return _apiRepository.createUser();
  }

  Future<void> signOut() async {
    return _apiRepository.signOut();
  }

  Future<BalanceResult?> getBalance(String pubKey) async {
    try {
      final result = await _solanaRpc.rpcClient
          .getBalance(pubKey, commitment: Commitment.confirmed);
      return result;
    } catch (e) {
      return null;
    }
  }

  Future<LatestBlockhashResult?> getLatestBlockHash(String pubKey) async {
    try {
      final result = await _solanaRpc.rpcClient
          .getLatestBlockhash(commitment: Commitment.confirmed);
      return result;
    } catch (e) {
      return null;
    }
  }

  Future<SignatureStatusesResult?> getSignatureStatuses(
      List<String> signatures) async {
    try {
      final result =
          await _solanaRpc.rpcClient.getSignatureStatuses(signatures);

      return result;
    } catch (e) {
      return null;
    }
  }
}
