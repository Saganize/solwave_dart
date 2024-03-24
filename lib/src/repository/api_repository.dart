import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/api_response/initiate_sign_message_response.dart';

import '../core/constants.dart';
import '../core/solwave_error.dart';
import '../models/api_request/initiate_sign_message_request.dart';
import '../models/api_request/initiate_transaction_request.dart';
import '../models/api_request/intiaite_auth_request.dart';
import '../models/api_request/simulate_transaction_request.dart';
import '../models/api_response/initiate_auth_response.dart';
import '../models/api_response/intiate_transaction_response.dart';
import '../models/api_response/simulate_transaction_response.dart';
import '../models/base_response.dart';

class ApiRepository {
  late final Dio _dio;

  ApiRepository() {
    _dio = Dio();
    _dio.options.baseUrl = "https://staging.saganize.com/api/v1/";
    _dio.options.headers = {
      'api': ApiKeyConstants.apiKey,
    };
    _dio.options.connectTimeout = const Duration(seconds: 5);
  }

  Future<(BaseResponse<InitiateAuthResponse?>?, SolwaveError?)> login() async {
    try {
      final (idToken, email) = await singInWithGoogle();

      if (idToken != null && email != null) {
        final authTx = InitiateAuthRequest(
          verifyToken: idToken,
          email: email,
        );

        final response = await _dio.post(
          ApiPaths.initiateLogin.path,
          data: authTx.toJson(),
        );

        final success = BaseResponse<InitiateAuthResponse>.fromJson(
          response.data,
          (json) => InitiateAuthResponse.fromJson(json),
        );
        return (success, null);
      } else {
        await signOut();
        final failure =
            SolwaveError.createError(SolwaveErrorCodes.initLoginUserError);
        return (null, failure);
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        final failure =
            SolwaveError.createError(SolwaveErrorCodes.firebaseError);
        return (null, failure);
      } else if (e is DioException) {
        await signOut();
        final failure = SolwaveError.fromJson(e.response?.data);
        return (null, failure);
      } else {
        return (null, SolwaveError.createError(SolwaveErrorCodes.genericError));
      }
    }
  }

  Future<(BaseResponse<InitiateAuthResponse?>?, SolwaveError?)>
      createUser() async {
    try {
      final (idToken, email) = await singInWithGoogle();

      if (idToken != null && email != null) {
        final authTx = InitiateAuthRequest(
          verifyToken: idToken,
          email: email,
        );

        final response = await _dio.post(
          ApiPaths.initiateAccountCreation.path,
          data: authTx.toJson(),
        );

        final success = BaseResponse<InitiateAuthResponse>.fromJson(
          response.data,
          (json) => InitiateAuthResponse.fromJson(json),
        );
        return (success, null);
      }
      await signOut();
      final failure =
          SolwaveError.createError(SolwaveErrorCodes.initCreateUserError);
      return (null, failure);
    } catch (e) {
      debugPrint("createUser $e");
      if (e is FirebaseAuthException) {
        final failure =
            SolwaveError.createError(SolwaveErrorCodes.firebaseError);
        return (null, failure);
      } else if (e is DioException) {
        await signOut();
        final failure = SolwaveError.fromJson(e.response?.data);
        return (null, failure);
      } else {
        return (null, SolwaveError.createError(SolwaveErrorCodes.genericError));
      }
    }
  }

  Future<(String?, String?)> singInWithGoogle(
      {bool refreshToken = false}) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleSignInAuthentication =
          await googleSignInAccount?.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication?.accessToken,
        idToken: googleSignInAuthentication?.idToken,
      );

      final firebaseUser =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final idToken = await firebaseUser.user!.getIdToken(refreshToken);

      return (idToken, firebaseUser.user?.email);
    } catch (e) {
      debugPrint("Error linking with Google: $e");
      return (null, null);
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "no-such-provider":
          debugPrint("The user isn't linked to the provider or the provider "
              "doesn't exist.");
          break;
        default:
          debugPrint("Unkown error.");
      }
    }
  }

  Future<(BaseResponse<InitiateTransactionResponse>?, SolwaveError?)>
      initiateTransaction(
          {required InitiateTransactionRequest requestBody}) async {
    try {
      final response = await _dio.post(
        ApiPaths.initiateTransaction.path,
        data: requestBody.toJson(),
      );

      final success = BaseResponse<InitiateTransactionResponse>.fromJson(
        response.data,
        (json) => InitiateTransactionResponse.fromJson(json),
      );

      return (success, null);
    } catch (e) {
      if (e is DioException) {
        final failure = SolwaveError.fromJson(e.response?.data);
        return (null, failure);
      }
      return (
        null,
        SolwaveError.createError(
          SolwaveErrorCodes.initiateTransactionError,
        )
      );
    }
  }

  Future<(BaseResponse<SimulateTransactionResponse>?, SolwaveError?)>
      simulateTransaction(
          {required SimulateTransactionRequest requestBody}) async {
    try {
      final response = await _dio.post(
        ApiPaths.simulateTransaction.path,
        data: requestBody.toJson(),
      );

      final success = BaseResponse<SimulateTransactionResponse>.fromJson(
        response.data,
        (json) => SimulateTransactionResponse.fromJson(json),
      );

      return (success, null);
    } catch (e) {
      if (e is DioException) {
        final failure = SolwaveError.fromJson(e.response?.data);
        return (null, failure);
      }
      return (null, SolwaveError.createError(SolwaveErrorCodes.genericError));
    }
  }

  Future<(BaseResponse<InitiateSignMessageResponse>?, SolwaveError?)>
      signMessage({required InitiateSignMessageRequest requestBody}) async {
    try {
      final response = await _dio.post(
        ApiPaths.signMessage.path,
        data: requestBody.toJson(),
      );

      final success = BaseResponse<InitiateSignMessageResponse>.fromJson(
        response.data,
        (json) => InitiateSignMessageResponse.fromJson(json),
      );

      return (success, null);
    } catch (e) {
      if (e is DioException) {
        final failure = SolwaveError.fromJson(e.response?.data);
        return (null, failure);
      }
      return (null, SolwaveError.createError(SolwaveErrorCodes.genericError));
    }
  }
}
