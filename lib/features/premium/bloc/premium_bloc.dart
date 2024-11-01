import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../core/api/api.dart';
import '../../../core/config/config.dart';
import '../../home/bloc/home_provier.dart';
import '../data/model/paymentmodel.dart';
import '../data/model/premium_model.dart';
import 'premium_state.dart';
 

class PremiumBloc extends Cubit<PremiumState> {
  PremiumBloc() : super(PremiumInit());

  final Api _api = Api();

  Future<PremiumModel> planDataApi(context) async {
    Map data = {
      "uid": Provider.of<HomeProvider>(context, listen: false).uid,
    };
    try {
      Response response = await _api.sendRequest
          .get("${Config.baseUrlApi}${Config.plan}", data: data);
      PremiumModel premiumModel = PremiumModel.fromJson(response.data);
      if (response.statusCode == 200) {
        if (response.data["Result"] == "true") {
          return premiumModel;
        } else {
          emit(PremiumError(response.data["ResponseMsg"]));
          return premiumModel;
        }
      } else {
        emit(PremiumError(response.data["ResponseMsg"]));
        return premiumModel;
      }
    } catch (e) {
      if (e is DioException) {
        emit(PremiumError(e.response?.data["ResponseMsg"] ?? e.message));
      }
      emit(PremiumError(e.toString()));
      rethrow;
    }
  }

  Future<PaymentModel> paymentGateway(context) async {
    try {
      Response response = await _api.sendRequest
          .get("${Config.baseUrlApi}${Config.paymentGateway}");
      PaymentModel premiumModel = PaymentModel.fromJson(response.data);
      if (response.statusCode == 200) {
        if (response.data["Result"] == "true") {
          return premiumModel;
        } else {
          emit(PremiumError(response.data["ResponseMsg"]));
          return premiumModel;
        }
      } else {
        emit(PremiumError(response.data["ResponseMsg"]));
        return premiumModel;
      }
    } catch (e) {
      if (e is DioException) {
        emit(PremiumError(e.response?.data["ResponseMsg"] ?? e.message));
      }
      emit(PremiumError(e.toString()));
      rethrow;
    }
  }

  Future planPurchase(
      {required String planId,
      required String tranID,
      required String pname,
      required String pMethodId,
      required context}) async {
    Map data = {
      "plan_id": planId,
      "transaction_id": tranID,
      "uid": Provider.of<HomeProvider>(context, listen: false).uid,
      "pname": pname,
      "p_method_id": pMethodId
    };
    try {
      Response response = await _api.sendRequest
          .post("${Config.baseUrlApi}${Config.planPurchase}", data: data);

      if (response.statusCode == 200) {
        if (response.data["Result"] == "true") {
          Provider.of<HomeProvider>(context, listen: false).setSelectPage(0);
          Fluttertoast.showToast(msg: response.data["ResponseMsg"]);
          Navigator.pushNamedAndRemoveUntil(
              context, "/bottombar", (route) => false);
        } else {
          Fluttertoast.showToast(msg: response.data["ResponseMsg"]);
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (e is DioException) {
        emit(PremiumError(e.response?.data["ResponseMsg"] ?? e.message));
      }
      emit(PremiumError(e.toString()));
    }
  }

  completeApi(List<PlanDatum> planData, List<Paymentdatum> paymet) {
    emit(PremiumComplete(planData, paymet));
  }
}
