 
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../core/api/api.dart';
import '../../../core/config/config.dart';
import '../../../core/model/local_database.dart';
import '../../../core/model/user_model.dart';
import '../../home/bloc/home_provier.dart';
import '../../onboarding/data/firebase/auth_firebase.dart';
import 'editprofile_provider.dart';
import 'editprofile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditInitState());
  final Api _api = Api();

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
        emit(EditErrorState(e.response?.data["ResponseMsg"] ?? e.message));
      }
      emit(EditErrorState(e.toString()));
      rethrow;
    }
  }

  sendOtpFunction({required String number, context}) async {
    emit(EditInnerLoadingState());
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          emit(EditErrorState(e.toString()));
        },
        codeSent: (String verificationId, int? resendToken) {
          Provider.of<EditProfileProvider>(context, listen: false)
              .vericitionId = verificationId;
          Provider.of<EditProfileProvider>(context, listen: false)
              .otpBottomSheet(context);
          emit(EditSuccess());
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      if (e is DioException) {
        emit(EditErrorState(e.response?.data["ResponseMsg"] ?? e.message));
      }
      emit(EditErrorState(e.toString()));
    }
  }

  Future<UserModel> updateUserData(
      {required String name,
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
      required String gender,
      required String lat,
      required String long,
      required String religon,
      required String imlist,
      required String uid,
      required String height,
      required List images,
      required bool isOtp,
      context}) async {
    emit(EditInerLoadingState());
    try {
      FormData formData = FormData.fromMap({
        'name': name,
        'email': email,
        'mobile': mobile,
        'ccode': "+$ccode",
        'birth_date': bday,
        'search_preference': searchPreference,
        'radius_search': rediusSearch,
        'relation_goal': relationGoal,
        'profile_bio': profileBio,
        'interest': intrest,
        'language': language,
        'password': password,
        'gender': gender,
        'lats': lat,
        'longs': long,
        'imlist': imlist,
        'uid': uid,
        'religion': religon,
        'size': images.length,
        'height': height,
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
          .post("${Config.baseUrlApi}${Config.editProfile}", data: formData);

      if (response.statusCode == 200) {
        if (response.data["Result"] == "true") {
          emit(EditComplete());
          Preferences.saveUserDetails(response.data);
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
          Provider.of<HomeProvider>(context, listen: false).localData(context);
          Provider.of<EditProfileProvider>(context, listen: false)
              .dataTransfer(context);
          Fluttertoast.showToast(msg: response.data["ResponseMsg"]);
          if (isOtp) {
            Navigator.pop(context);
          }
          Navigator.pop(context);

          return UserModel.fromJson(response.data);
        } else {
          emit(EditErrorState(response.data["ResponseMsg"]));
          return UserModel.fromJson(response.data);
        }
      } else {
        emit(EditErrorState(response.data["ResponseMsg"]));
        return UserModel.fromJson(response.data);
      }
    } catch (e) {
      if (e is DioException) {
        emit(EditErrorState(e.response?.data["ResponseMsg"] ?? e.message));
      }
      emit(EditErrorState(e.toString()));
      rethrow;
    }
  }

  loadingState() {
    emit(EditLoadingState());
  }

  compeltDataTransfer() {
    emit(EditDataTransfer());
  }
}
