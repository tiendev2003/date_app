import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../core/api/api.dart';
import '../../../core/config/config.dart';
import '../../../core/language/localization/app_localization.dart';
import '../../../core/model/profile_block_api_model.dart';
import '../../../core/model/report_api_model.dart';
import '../../../widget/bottom_bar.dart';
import '../../profile/data/model/details_model.dart';
import 'home_provier.dart';

class DetailProvider extends ChangeNotifier {
  final Api _api = Api();
  bool isLoading = true;
  late DetailModel detailModel;
  late HomeProvider homeProvider;

  int slider = 0;
  updateSlider(int value) {
    slider = value;
    notifyListeners();
  }

  bool isMatch = false;
  String status = "0";
  updateIsMatch(bool value) {
    isMatch = value;
    notifyListeners();
  }

  Future detailsApi(
      {required String uid,
      required String lat,
      required String long,
      required String profileId}) async {
    try {
      Map data = {
        "uid": uid,
        "profile_id": profileId,
        "lats": lat,
        "longs": long
      };

      var response = await _api.sendRequest
          .post("${Config.baseUrlApi}${Config.profileInfo}", data: data);

      if (response.statusCode == 200) {
        isLoading = false;
        detailModel = DetailModel.fromJson(response.data);
        notifyListeners();
      } else {
        return DetailModel.fromJson(response.data);
      }
    } catch (e) {
      rethrow;
    }
  }

  // ProfileBlock api

  late ProfileBlockUser profileblockuser;

  Future profileblockApi(
      {required context, required String profileblock}) async {
    Map data = {
      "uid": Provider.of<HomeProvider>(context, listen: false).uid,
      "profile_id": profileblock
    };

    try {
      var response = await _api.sendRequest
          .post("${Config.baseUrlApi}${Config.profileblock}", data: data);
      print(" + + + + + + + + : ---------  ${response.data}");
      if (response.statusCode == 200) {
        ProfileBlockUser.fromJson(response.data);
        if (response.data["Result"] == "true") {
       
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const BottomBar()),
              (route) => false);
          // Navigator.pushReplacement(context,MaterialPageRoute(builder:(context) => const BottomBar()),);
          Fluttertoast.showToast(msg: response.data["ResponseMsg"]);
          notifyListeners();
        } else {
          Fluttertoast.showToast(msg: response.data["ResponseMsg"]);
        }
      } else {
        // Fluttertoast.showToast(msg: "Something went Wrong....!!!".tr);
        Fluttertoast.showToast(
            msg: AppLocalizations.of(context)
                    ?.translate("Something went Wrong....!!!") ??
                "Something went Wrong....!!!");
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Something went Wrong....!!!")));
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  // ProfileReport api

  late Reportapi reportapi;

  Future profilereportApi(
      {required context,
      required String reportid,
      required String comment}) async {
    Map data = {
      "uid": Provider.of<HomeProvider>(context, listen: false).uid,
      "reporter_id": reportid,
      "comment": comment,
    };

    try {
      var response = await _api.sendRequest
          .post("${Config.baseUrlApi}${Config.reportapi}", data: data);
      print(" + + + + + + + + : ---------  ${response.data}");
      if (response.statusCode == 200) {
        Reportapi.fromJson(response.data);
        if (response.data["Result"] == "true") {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const BottomBar()),
              (route) => false);
          Fluttertoast.showToast(msg: response.data["ResponseMsg"]);
          notifyListeners();
        } else {
          Fluttertoast.showToast(msg: response.data["ResponseMsg"]);
        }
      } else {
        // Fluttertoast.showToast(msg: "Something went Wrong....!!!".tr);
        Fluttertoast.showToast(
            msg: AppLocalizations.of(context)
                    ?.translate("Something went Wrong....!!!") ??
                "Something went Wrong....!!!");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
