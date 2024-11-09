import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'match_cubit.dart';

class MatchProvider extends ChangeNotifier {
  List menuData = ["New Match", "Like Me", "Favourite", "Passed"];

  int selectIndex = 0;

  updateIndex(int index) {
    selectIndex = index;
    notifyListeners();
  }

  matchInit(context) {
    MatchCubit matchCubit = BlocProvider.of<MatchCubit>(context, listen: false);
    matchCubit.loadingState();
    matchCubit.newMatchApi(context).then((newMatchApi) {
      matchCubit.favouriteApi(context).then((favoriteApi) {
        matchCubit.passedApi(context).then((passedApi) {
          matchCubit.likeMeApi(context).then((likeApi) {
            matchCubit.completeState(
                likeApi, newMatchApi, favoriteApi, passedApi);
            notifyListeners();
          });
        });
      });
    });
  }

  callAllApi(context) {
    MatchCubit matchCubit = BlocProvider.of<MatchCubit>(context, listen: false);
    matchCubit.newMatchApi(context).then((newMatchApi) {
      matchCubit.favouriteApi(context).then((favoriteApi) {
        matchCubit.passedApi(context).then((passedApi) {
          matchCubit.likeMeApi(context).then((likeApi) {
            matchCubit.completeState(
                likeApi, newMatchApi, favoriteApi, passedApi);
            notifyListeners();
          });
        });
      });
    });
  }
}
