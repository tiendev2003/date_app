import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/language/localization/app_localization.dart';
import '../../../../core/theme/ui.dart';
import '../../../../widget/back_button.dart';
import '../../../../widget/main_button.dart';
import '../../../home/bloc/home_cubit.dart';
import '../../../home/bloc/home_provier.dart';
import '../../../home/bloc/home_state.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                // child: MainButton(title: "Upgrade".tr,onTap: () {
                child: MainButton(
                  title: AppLocalizations.of(context)?.translate("Upgrade") ??
                      "Upgrade",
                  onTap: () {
                    Navigator.pushNamed(context, "/premiumScreen");
                  },
                ),
              ),
            ],
          ),
        ),
        body: BlocBuilder<HomePageCubit, HomePageStates>(
            builder: (context, state) {
          if (state is HomeCompleteState) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            BackButtons(),
                          ]),
                      const SizedBox(
                        height: 10,
                      ),
                      // Text("You're Activated Membership!".tr,style: Theme.of(context).textTheme.headlineMedium,textAlign: TextAlign.center),
                      Text(
                          AppLocalizations.of(context)
                                  ?.translate("You're Activated Membership!") ??
                              "You're Activated Membership!",
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center),
                      const SizedBox(
                        height: 15,
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: AppColors.appColor, width: 3)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    state.homeData.plandata!.planDescription
                                        .toString(),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                              ],
                            ),
                          ),
                          Positioned(
                            top: -10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  color: AppColors.appColor,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(
                                state.homeData.plandata!.planTitle.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: AppColors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(children: [
                        // Text("Payment method".tr,style: Theme.of(context).textTheme.bodySmall),
                        Text(
                            AppLocalizations.of(context)
                                    ?.translate("Payment method") ??
                                "Payment method",
                            style: Theme.of(context).textTheme.bodySmall),
                        const Spacer(),
                        Text(state.homeData.plandata!.pName.toString(),
                            style: Theme.of(context).textTheme.bodyMedium),
                      ]),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(children: [
                        // Text("transaction id".tr,style: Theme.of(context).textTheme.bodySmall),
                        Text(
                            AppLocalizations.of(context)
                                    ?.translate("transaction id") ??
                                "transaction id",
                            style: Theme.of(context).textTheme.bodySmall),
                        const Spacer(),
                        Text(state.homeData.plandata!.transId.toString(),
                            style: Theme.of(context).textTheme.bodyMedium),
                      ]),
                      Divider(
                        height: 20,
                        color: Theme.of(context).dividerTheme.color!,
                      ),
                      Row(children: [
                        // Text("Date of Purchase".tr,style: Theme.of(context).textTheme.bodySmall),
                        Text(
                            AppLocalizations.of(context)
                                    ?.translate("Date of Purchase") ??
                                "Date of Purchase",
                            style: Theme.of(context).textTheme.bodySmall),
                        const Spacer(),
                        Text(
                            DateFormat('dd/MM/yyyy').format(
                                DateTime.parse(state
                                    .homeData.plandata!.planStartDate
                                    .toString())),
                            style: Theme.of(context).textTheme.bodyMedium),
                      ]),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(children: [
                        // Text("Date of Expiry".tr,style: Theme.of(context).textTheme.bodySmall),
                        Text(
                            AppLocalizations.of(context)
                                    ?.translate("Date of Expiry") ??
                                "Date of Expiry",
                            style: Theme.of(context).textTheme.bodySmall),
                        const Spacer(),
                        Text(
                          DateFormat('dd/MM/yyyy').format(
                                DateTime.parse(state
                                    .homeData.plandata!.planEndDate
                                    .toString()))
                            
                                 ,
                            style: Theme.of(context).textTheme.bodyMedium),
                      ]),
                      Divider(
                        height: 20,
                        color: Theme.of(context).dividerTheme.color!,
                      ),
                      Row(children: [
                        Text(
                            AppLocalizations.of(context)
                                    ?.translate("Membership Amount") ??
                                "Membership Amount",
                            style: Theme.of(context).textTheme.bodySmall),
                        const Spacer(),
                        Text(
                            "${Provider.of<HomeProvider>(context, listen: false).currency}${state.homeData.plandata!.amount.toString()}",
                            style: Theme.of(context).textTheme.bodyMedium),
                      ]),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Center(
                child: CircularProgressIndicator(color: AppColors.appColor));
          }
        }));
  }
}
