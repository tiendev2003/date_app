import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../core/api/api.dart';
import '../../../core/config/config.dart';
import '../../home/bloc/home_provier.dart';
import '../data/model/favoritelist_model.dart';
import '../data/model/likeme_model.dart';
import '../data/model/newmatch_model.dart';
import '../data/model/passed_model.dart';
import 'match_states.dart';

class MatchCubit extends Cubit<MatchStates> {
  MatchCubit() : super(MatchInitState());

  final Api _api = Api();

  Future<LikeMeModel> likeMeApi(context) async {
    try {
      Map data = {
        "uid": Provider.of<HomeProvider>(context, listen: false).uid,
        "lats": Provider.of<HomeProvider>(context, listen: false).lat,
        "longs": Provider.of<HomeProvider>(context, listen: false).long
      };
      Response response = await _api.sendRequest
          .post("${Config.baseUrlApi}${Config.likeMe}", data: data);

      if (response.statusCode == 200) {
        if (response.data["Result"] == "true") {
          return LikeMeModel.fromJson(response.data);
        } else {
          // emit(MatchErrorState(response.data["Result"]));
          return LikeMeModel.fromJson(response.data);
        }
      } else {
        emit(MatchErrorState(response.data["Result"]));

        return LikeMeModel.fromJson(response.data);
      }
    } catch (e) {
      if (e is DioException) {
        emit(MatchErrorState(e.response?.data["ResponseMsg"] ?? e.message));
      }
      
      rethrow;
    }
  }

  Future<FavlistModel> favouriteApi(context) async {
    try {
      Map data = {
        "uid": Provider.of<HomeProvider>(context, listen: false).uid,
        "lats": Provider.of<HomeProvider>(context, listen: false).lat,
        "longs": Provider.of<HomeProvider>(context, listen: false).long
      };

      Response response = await _api.sendRequest
          .post("${Config.baseUrlApi}${Config.favourite}", data: data);
      if (response.statusCode == 200) {
        if (response.data["Result"] == "true") {
          return FavlistModel.fromJson(response.data);
        } else {
          // emit(MatchErrorState(response.data["ResponseMsg"]));
          return FavlistModel.fromJson(response.data);
        }
      } else {
        emit(MatchErrorState(response.data["ResponseMsg"]));
        return FavlistModel.fromJson(response.data);
      }
    } catch (e) {
      if (e is DioException) {
        emit(MatchErrorState(e.response?.data["ResponseMsg"] ?? e.message));
      }
      emit(MatchErrorState(e.toString()));
      rethrow;
    }
  }

  Future<PassedModel> passedApi(context) async {
    try {
      Map data = {
        "uid": Provider.of<HomeProvider>(context, listen: false).uid,
        "lats": Provider.of<HomeProvider>(context, listen: false).lat,
        "longs": Provider.of<HomeProvider>(context, listen: false).long
      };
      Response response = await _api.sendRequest
          .post("${Config.baseUrlApi}${Config.passed}", data: data);

      if (response.statusCode == 200) {
        if (response.data["Result"] == "true") {
          return PassedModel.fromJson(response.data);
        } else {
          // emit(MatchErrorState(response.data["Result"]));
          return PassedModel.fromJson(response.data);
        }
      } else {
        emit(MatchErrorState(response.data["Result"]));
        return PassedModel.fromJson(response.data);
      }
    } catch (e) {
      if (e is DioException) {
        emit(MatchErrorState(e.response?.data["ResponseMsg"] ?? e.message));
         rethrow;
      }
      emit(MatchErrorState(e.toString()));
      rethrow;
    }
  }

  Future<NewMatchModel> newMatchApi(context) async {
    try {
      Map data = {
        "uid": Provider.of<HomeProvider>(context, listen: false).uid,
        "lats": Provider.of<HomeProvider>(context, listen: false).lat,
        "longs": Provider.of<HomeProvider>(context, listen: false).long
      };
      Response response = await _api.sendRequest
          .post("${Config.baseUrlApi}${Config.newMatch}", data: data);

      if (response.statusCode == 200) {
        if (response.data["Result"] == "true") {
          return NewMatchModel.fromJson(response.data);
        } else {
          // emit(MatchErrorState(response.data["Result"]));
          return NewMatchModel.fromJson(response.data);
        }
      } else {
        emit(MatchErrorState(response.data["Result"]));
        return NewMatchModel.fromJson(response.data);
      }
    } catch (e) {
      if (e is DioException) {
        emit(MatchErrorState(e.response?.data["ResponseMsg"] ?? e.message));
      }
      emit(MatchErrorState(e.toString()));
      rethrow;
    }
  }

  Future profileLikeDislikeApi({
    required String uid,
    required String proId,
    required String action,
  }) async {
    //"UNLIKE"
    //"LIKE"
    try {
      Map data = {"uid": uid, "profile_id": proId, "action": action};

      Response response = await _api.sendRequest
          .post("${Config.baseUrlApi}${Config.likeDislike}", data: data);

      if (response.statusCode == 200) {
        if (response.data["Result"] == "true") {
          return response.data["Result"];
        } else {
          Fluttertoast.showToast(msg: response.data["ResponseMsg"]);
        }
      }
    } catch (e) {
      if (e is DioException) {
        emit(MatchErrorState(e.response?.data["ResponseMsg"] ?? e.message));
      }
      emit(MatchErrorState(e.toString()));
      rethrow;
    }
  }

  loadingState() {
    emit(MatchLoadingState());
  }

  completeState(likeMeModel, newMatchModel, favListModel, passedModel) {
    emit(MatchCompleteState(
        likeMeModel, newMatchModel, favListModel, passedModel));
  }
}
