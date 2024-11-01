import '../data/model/favoritelist_model.dart';
import '../data/model/likeme_model.dart';
import '../data/model/newmatch_model.dart';
import '../data/model/passed_model.dart';

class MatchStates {}

class MatchInitState extends MatchStates {}

class MatchLoadingState extends MatchStates {}

class MatchErrorState extends MatchStates {
  String error;
  MatchErrorState(this.error);
}

class MatchCompleteState extends MatchStates {
  NewMatchModel newMatchModel;
  FavlistModel favListModel;
  LikeMeModel likeMeModel;
  PassedModel passedModel;
  MatchCompleteState(this.likeMeModel, this.newMatchModel, this.favListModel,
      this.passedModel);
}
