import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../core/api/api.dart';
import '../../../core/config/config.dart';
import '../../../core/model/local_database.dart';
import '../../onboarding/bloc/onbording_provider.dart';
import '../../premium/bloc/premium_provider.dart';
import '../data/model/home_model.dart';
import 'home_provier.dart';
import 'home_state.dart';

class HomePageCubit extends Cubit<HomePageStates> {
  HomePageCubit() : super(HomeInitState());

  final Api _api = Api();

  initforHome(context) {
    emit(HomeLoadingState());
    try {
      double? lat = Provider.of<OnBordingProvider>(context, listen: false).lat;
      double? long =
          Provider.of<OnBordingProvider>(context, listen: false).long;
      Preferences.fetchUserDetails().then((value) {
        Map uid = jsonDecode(value);
        getHomeData(
            uid: uid["UserLogin"]["id"].toString(),
            lat: (lat).toString(),
            long: (long).toString(),
            context: context);
      });
    } catch (e) {
      if (e is DioException) {
        emit(HomeErrorState(e.response?.data["ResponseMsg"] ?? e.message));
      }
      emit(HomeErrorState(e.toString()));
    }
  }

  Future<HomeModel> getHomeData(
      {required String uid,
      required String lat,
      required String long,
      required context}) async {
    try {
      Map data = {"uid": uid, "lats": lat, "longs": long};

      Response response = await _api.sendRequest
          .post("${Config.baseUrlApi}${Config.homeData}", data: data);

      if (response.statusCode == 200) {
        HomeModel homeData = HomeModel.fromJson(response.data);
        Provider.of<HomeProvider>(context, listen: false).currency =
            homeData.currency;
        Preferences.setDatawithKeyFromLocal(
            key: "currency", data: response.data["currency"]);
        Provider.of<PremiumProvider>(context, listen: false).selectedPlan =
            int.parse(homeData.planId.toString());
        log(homeData.plandata!.amount!);
        emit(HomeCompleteState(homeData));

        return HomeModel.fromJson(response.data);
      } else {
        emit(HomeErrorState(response.data["ResponseMsg"]));
        return HomeModel.fromJson(response.data);
      }
    } catch (e) {
      if (e is DioException) {
        emit(HomeErrorState(e.response?.data["ResponseMsg"] ?? e.message));
      }
      emit(HomeErrorState(e.toString()));
      rethrow;
    }
  }

  Future delUnlikeApi(context) async {
    try {
      Map data = {
        "uid": Provider.of<HomeProvider>(context, listen: false).uid,
      };
      Response response = await _api.sendRequest
          .post("${Config.baseUrlApi}${Config.delUnlike}", data: data);
      if (response.statusCode == 200) {
        initforHome(context);
        Navigator.pop(context);
      }
    } catch (e) {
      if (e is DioException) {
        emit(HomeErrorState(e.response?.data["ResponseMsg"] ?? e.message));
      }
      emit(HomeErrorState(e.toString()));
      rethrow;
    }
  }

  Future profileLikeDislikeApi({
    required String uid,
    required String proId,
    required String action,
    lat,
    long,
  }) async {
    //"UNLIKE"
    //"LIKE"
    try {
      Map data = {"uid": uid, "profile_id": proId, "action": action};

      Response response = await _api.sendRequest
          .post("${Config.baseUrlApi}${Config.likeDislike}", data: data);

      if (response.statusCode == 200) {
        if (response.data["Result"] == "true") {
        } else {
          Fluttertoast.showToast(msg: response.data["ResponseMsg"]);
        }
      }
    } catch (e) {
      if (e is DioException) {
        emit(HomeErrorState(e.response?.data["ResponseMsg"] ?? e.message));
      }
      emit(HomeErrorState(e.toString()));
      rethrow;
    }
  }

  Future filterHome({
    required String uid,
    required String lat,
    required String long,
    required String radiusSearch,
    required String searchPreference,
    required String minage,
    required String maxage,
    required String relationGoal,
    required String interest,
    required String religion,
    required String language,
    required String isverify,
  }) async {
    try {
      Map data = {
        "uid": uid,
        "radius_search": radiusSearch,
        "search_preference": searchPreference,
        "lats": lat,
        "longs": long,
        "minage": minage,
        "maxage": maxage,
        "relation_goal": relationGoal,
        "interest": interest,
        "religion": religion,
        "language": language,
        "is_verify": isverify
      };

      Response response = await _api.sendRequest
          .post("${Config.baseUrlApi}${Config.filter}", data: data);

      if (response.statusCode == 200) {
        if (response.data["Result"] == "true") {
          HomeModel homeData = HomeModel.fromJson(response.data);
          emit(HomeCompleteState(homeData));
        } else {
          Fluttertoast.showToast(msg: response.data["ResponseMsg"]);
        }
      }
    } catch (e) {
      if (e is DioException) {
        emit(HomeErrorState(e.response?.data["ResponseMsg"] ?? e.message));
      }
      emit(HomeErrorState(e.toString()));
      rethrow;
    }
  }

  Future planDataApi(context, uid) async {
    Map data = {"uid": uid};
    try {
      Response response = await _api.sendRequest
          .post("${Config.baseUrlApi}${Config.userInfo}", data: data);
      if (response.statusCode == 200) {
        if (response.data["Result"] == "true") {
          return response.data["direct_chat"];
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
