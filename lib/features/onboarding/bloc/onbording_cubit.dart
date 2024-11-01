import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/api/api.dart';
import '../../../core/config/config.dart';
import '../../../core/model/interest_model.dart';
import '../../../core/model/language_model.dart';
import '../../../core/model/local_database.dart';
import '../../../core/model/relation_goal_model.dart';
import '../../../core/model/religion_model.dart';
import '../../../core/model/user_model.dart';
import '../../../core/notification/push_notification_function.dart';
import '../data/firebase/auth_firebase.dart';
import 'onbording_provider.dart';
import 'onbording_state.dart';

class OnbordingCubit extends Cubit<OnbordingState> {
  OnbordingCubit() : super(InitState());

  final Api _api = Api();

  sendOtpFunction(
      {required String number, context, required bool isForgot}) async {
    emit(LoadingState());
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          emit(ErrorState(e.toString()));
        },
        codeSent: (String verificationId, int? resendToken) {
          Provider.of<OnBordingProvider>(context, listen: false).vericitionId =
              verificationId;
          emit(otpComplete());
          Provider.of<OnBordingProvider>(context, listen: false)
              .otpBottomSheet(context, isForgot);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      if (e is DioException) {
        emit(ErrorState(e.response?.data["ResponseMsg"] ?? e.message));
      }
      emit(ErrorState(e.toString()));
    }
  }

  Future mobileCheckApi({required String number, required String ccode}) async {
    try {
      Map body = {"mobile": number, "ccode": "+$ccode"};

      Response response = await _api.sendRequest
          .post("${Config.baseUrlApi}${Config.mobileCheck}", data: body);

      if (response.data["Result"] == "false") {
        Fluttertoast.showToast(msg: response.data["ResponseMsg"]);
      }

      return response.data["Result"];
    } catch (e) {
      if (e is DioException) {
        emit(ErrorState(e.response?.data["ResponseMsg"] ?? e.message));
        return e.response?.data["Result"];
      }
      emit(ErrorState(e.toString()));
      rethrow;
    }
  }

  Future<RelationGoalModel> relationGoalListApi() async {
    try {
      Response response = await _api.sendRequest
          .get("${Config.baseUrlApi}${Config.relationGoalList}");

      if (response.statusCode == 200) {
        return RelationGoalModel.fromJson(response.data);
      } else {
        emit(ErrorState(response.statusMessage.toString()));
        return RelationGoalModel.fromJson(response.data);
      }
    } catch (e) {
      if (e is DioException) {
        emit(ErrorState(e.response?.data["ResponseMsg"] ?? e.message));
      }
      emit(ErrorState(e.toString()));
      rethrow;
    }
  }

  Future<InterestModel> getInterestApi() async {
    try {
      Response response = await _api.sendRequest
          .get("${Config.baseUrlApi}${Config.getInterestList}");
      log(response.data.toString());
      if (response.statusCode == 200) {
        log(response.data.toString());
        return InterestModel.fromJson(response.data);
      } else {
        emit(ErrorState(response.statusMessage.toString()));
        return InterestModel.fromJson(response.data);
      }
    } catch (e) {
      if (e is DioException) {
        emit(ErrorState(e.response?.data["ResponseMsg"] ?? e.message));
      }
      emit(ErrorState(e.toString()));
      rethrow;
    }
  }

  Future<LanguageModel> languagelistApi() async {
    try {
      Response response = await _api.sendRequest
          .get("${Config.baseUrlApi}${Config.languagelist}");

      if (response.statusCode == 200) {
        return LanguageModel.fromJson(response.data);
      } else {
        emit(ErrorState(response.statusMessage.toString()));
        return LanguageModel.fromJson(response.data);
      }
    } catch (e) {
      if (e is DioException) {
        emit(ErrorState(e.response?.data["ResponseMsg"] ?? e.message));
      }
      emit(ErrorState(e.toString()));
      rethrow;
    }
  }

  Future<ReligionModel> religionApi() async {
    try {
      Response response = await _api.sendRequest
          .get("${Config.baseUrlApi}${Config.religionlist}");

      if (response.statusCode == 200) {
        return ReligionModel.fromJson(response.data);
      } else {
        emit(ErrorState(response.statusMessage.toString()));
        return ReligionModel.fromJson(response.data);
      }
    } catch (e) {
      if (e is DioException) {
        emit(ErrorState(e.response?.data["ResponseMsg"] ?? e.message));
      }
      emit(ErrorState(e.toString()));
      rethrow;
    }
  }

  Future<UserModel> registerUserApi({
    required String name,
    required String email,
    required String mobile,
    required String ccode,
    required String bday,
    required String searchPreference,
    required String rediusSearch,
    required String relationGoal,
    required String profileBio,
    required String intrest,
    required String language,
    required String password,
    required String refCode,
    required String gender,
    required String lat,
    required String long,
    required String religon,
    required List images,
    required context,
  }) async {
    emit(LoadingState());
    try {
      FormData formData = FormData.fromMap({
        'name': name,
        'email': email,
        'mobile': mobile,
        'ccode': ccode,
        'birth_date': bday,
        'search_preference': searchPreference,
        'radius_search': rediusSearch,
        'relation_goal': relationGoal,
        'profile_bio': profileBio,
        'interest': intrest,
        'language': language,
        'password': password,
        'refercode': refCode,
        'gender': gender,
        'lats': lat,
        'longs': long,
        'religion': religon,
        'size': images.length,
      });
      for (var image in images) {
        formData.files.add(
          MapEntry(
            'otherpic',
            await MultipartFile.fromFile(image.path,
                filename: image.path.split('/').last),
          ),
        );
      }

      Response response = await _api.sendRequest
          .post("${Config.baseUrlApi}${Config.regiseruser}", data: formData);

      if (response.statusCode == 200) {
        if (response.data["Result"] == "true") {
          emit(CompletSteps());
          Preferences.saveUserDetails(response.data);
          await initPlatformState();
          OneSignal.shared
              .sendTag("user_id", response.data["UserLogin"]["id"].toString());
          setUpFirebase(context,
              email: response.data["UserLogin"]["email"],
              uid: response.data["UserLogin"]["id"].toString(),
              proPic: response.data["UserLogin"]["profile_pic"]
                  .toString()
                  .split("\$;")
                  .first,
              number: response.data["UserLogin"]["mobile"].toString(),
              name: response.data["UserLogin"]["name"]);
          return UserModel.fromJson(response.data);
        } else {
          emit(ErrorState(response.data["ResponseMsg"]));
          return UserModel.fromJson(response.data);
        }
      } else {
        emit(ErrorState(response.data["ResponseMsg"]));
        return UserModel.fromJson(response.data);
      }
    } catch (e) {
      if (e is DioException) {
        emit(ErrorState(e.response?.data["ResponseMsg"] ?? e.message));
      }
      emit(ErrorState(e.toString()));
      rethrow;
    }
  }

  setUpFirebase(context,
      {required String email,
      required String name,
      required String number,
      required String uid,
      required String proPic}) {
    try {
      Provider.of<FirebaseAuthService>(context, listen: false).singUpAndStore(
          email: email,
          uid: uid,
          proPicPath: proPic,
          name: name,
          number: number);
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future loginWithEmailPass(
      {required String mobile,
      required String password,
      required String ccode,
      required context}) async {
    emit(LoadingState());
    try {
      Map data = {"mobile": mobile, "password": password, "ccode": ccode};
      Response response = await _api.sendRequest
          .post("${Config.baseUrlApi}${Config.userLogin}", data: data);
      if (response.statusCode == 200) {
        if (response.data["Result"] == "true") {
          emit(CompletSteps());
          Preferences.saveUserDetails(response.data);
          OneSignal.shared.sendTag("user_id", response.data["UserLogin"]["id"]);
          initPlatformState();
          Provider.of<FirebaseAuthService>(context, listen: false)
              .singInAndStoreData(
                  email: response.data["UserLogin"]["email"],
                  uid: response.data["UserLogin"]["id"].toString(),
                  number: response.data["UserLogin"]["mobile"],
                  name: response.data["UserLogin"]["name"],
                  proPicPath: response.data["UserLogin"]["other_pic"]
                      .toString()
                      .split("\$;")
                      .first);
          return UserModel.fromJson(response.data);
        } else {
          emit(ErrorState(response.data["ResponseMsg"]));
        }
      } else {
        emit(ErrorState(response.data["ResponseMsg"]));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 404) {
          emit(ErrorState(e.response?.data["ResponseMsg"]));
        } else {
          emit(ErrorState(e.response?.data["ResponseMsg"] ?? e.message));
        }
      } else {
        emit(ErrorState(e.toString()));
      }
      rethrow;
    }
  }

  Future forgotPassApi(
      {required String mobile,
      required String password,
      required String ccode,
      required context}) async {
    try {
      Map data = {"mobile": mobile, "password": password, "ccode": "+$ccode"};
      Response response = await _api.sendRequest
          .post("${Config.baseUrlApi}${Config.forgetPassword}", data: data);
      if (response.statusCode == 200) {
        if (response.data["Result"] == "true") {
          Navigator.pushNamedAndRemoveUntil(
              context, "/authScreen", (route) => false);
          emit(ErrorState(response.data["ResponseMsg"]));
        } else {
          Navigator.pop(context);
          Navigator.pop(context);
          emit(ErrorState(response.data["ResponseMsg"]));
        }
      } else {
        emit(ErrorState(response.data["ResponseMsg"]));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
      rethrow;
    }
  }
}
