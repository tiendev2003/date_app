 
import '../data/model/paymentmodel.dart';
import '../data/model/premium_model.dart';

class PremiumState{}
class PremiumInit extends PremiumState {}

class PremiumError  extends PremiumState{
  String error;
  PremiumError(this.error);
}

class PremiumComplete extends PremiumState{
  List<PlanDatum> planData;
  List<Paymentdatum> payment;
  PremiumComplete(this.planData,this.payment);
}