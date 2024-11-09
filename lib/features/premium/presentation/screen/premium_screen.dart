import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vnpay_client/vnpay_client.dart';

import '../../../../core/config/config.dart';
import '../../../../core/language/localization/app_localization.dart';
import '../../../../core/theme/ui.dart';
import '../../../../main.dart';
import '../../../../widget/back_button.dart';
import '../../../../widget/main_button.dart';
import '../../../home/bloc/home_cubit.dart';
import '../../../home/bloc/home_provier.dart';
import '../../../home/bloc/home_state.dart';
import '../../bloc/premium_bloc.dart';
import '../../bloc/premium_provider.dart';
import '../../bloc/premium_state.dart';
import '../widget/vnpay.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<PremiumBloc>(context, listen: false)
        .planDataApi(context)
        .then((value) {
      BlocProvider.of<PremiumBloc>(navigatorKey.currentContext!, listen: false)
          .paymentGateway(navigatorKey.currentContext!)
          .then((value1) {
        BlocProvider.of<PremiumBloc>(navigatorKey.currentContext!)
            .completeApi(value.planData!, value1.paymentdata!);
      });
    });
  }

  late PremiumProvider premiumProvider;

  @override
  Widget build(BuildContext context) {
    premiumProvider = Provider.of<PremiumProvider>(context);
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: const BackButtons(),
        clipBehavior: Clip.none,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar:
          BlocBuilder<PremiumBloc, PremiumState>(builder: (context, state) {
        if (state is PremiumComplete) {
          return BlocBuilder<HomePageCubit, HomePageStates>(
              builder: (context, state1) {
            if (state1 is HomeCompleteState) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                        child: MainButton(
                      titleColor: state1.homeData.planId ==
                              premiumProvider.selectedPlan.toString()
                          ? AppColors.black
                          : AppColors.white,
                      bgColor: state1.homeData.planId ==
                              premiumProvider.selectedPlan.toString()
                          ? AppColors.borderColor
                          : AppColors.appColor,
                      title:
                          "FROM ${Provider.of<HomeProvider>(context, listen: false).currency}${premiumProvider.selectedPlanPrice}",
                      onTap: () {
                        if (premiumProvider.selectedPlan > 0) {
                          state1.homeData.planId ==
                                  premiumProvider.selectedPlan.toString()
                              ? null
                              : showModalBottomSheet(
                                  context: context,
                                  constraints: BoxConstraints(
                                      maxHeight:
                                          MediaQuery.of(context).size.height -
                                              300),
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(15)),
                                      child: Scaffold(
                                        floatingActionButtonAnimator:
                                            FloatingActionButtonAnimator
                                                .scaling,
                                        floatingActionButtonLocation:
                                            FloatingActionButtonLocation
                                                .centerDocked,
                                        floatingActionButton: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: MainButton(
                                                  bgColor: AppColors.appColor,
                                                  // title: "Continue".tr,onTap: () {
                                                  title: AppLocalizations.of(
                                                              context)
                                                          ?.translate(
                                                              "Continue") ??
                                                      "Continue",
                                                  onTap: () async {
                                                    if (premiumProvider
                                                            .selectedPayment ==
                                                        3) {
                                                      final paymentUrl =
                                                          VNPAYFlutter.instance
                                                              .generatePaymentUrl(
                                                        url:
                                                            'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html',

                                                        version: '2.0.1',
                                                        //version of VNPAY, default is 2.0.1
                                                        tmnCode: 'FMJEVP1P',
                                                        //vnpay tmn code, get from vnpay
                                                        txnRef: DateTime.now()
                                                            .millisecondsSinceEpoch
                                                            .toString(),
                                                        //ref code, default is timestamp
                                                        orderInfo:
                                                            'Pay ${premiumProvider.selectedPlanPrice} VND',
                                                        //order info, default is Pay Order
                                                        amount: premiumProvider
                                                            .selectedPlanPrice
                                                            .toDouble(),
                                                        //amount
                                                        returnUrl:
                                                            'https://20c5-116-110-90-32.ngrok-free.app/api/payment/return',

                                                        ipAdress:
                                                            '192.168.1.36',
                                                        //Your IP address
                                                        vnpayHashKey:
                                                            '13NZGTEYJKQ36F2BPFB5RWWYCCR0QRP1',

                                                        vnPayHashType:
                                                            'HmacSHA512',
                                                      );
                                                      
                                                    
                                                      showVNPayScreen(context,
                                                          paymentUrl:
                                                              paymentUrl,
                                                          onPaymentSuccess:
                                                              (data) {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Payment Success");

                                                        BlocProvider.of<PremiumBloc>(context).planPurchase(
                                                            planId:
                                                                premiumProvider
                                                                    .selectedPlan
                                                                    .toString(),
                                                            tranID: data[
                                                                    "vnp_TransactionNo"] ??
                                                                "",
                                                            pname: premiumProvider
                                                                .selectedPaymentName,
                                                            pMethodId:
                                                                premiumProvider
                                                                    .selectedPayment
                                                                    .toString(),
                                                            context: context);
                                                      }, onPaymentError:
                                                              (data) {
                                                        log('onPaymentError: $data');
                                                      });
                                                    }
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        body: Consumer<PremiumProvider>(
                                          builder: (BuildContext context, value,
                                              Widget? child) {
                                            return ListView.separated(
                                                clipBehavior: Clip.none,
                                                padding: const EdgeInsets.only(
                                                    top: 10.0,
                                                    bottom: 50,
                                                    right: 10,
                                                    left: 10),
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      // premiumProvider.selectedPayment = index;
                                                      value.updateSelectPayment(
                                                          int.parse(state
                                                              .payment[index].id
                                                              .toString()));
                                                      value.updateAttributes(
                                                          state.payment[index]
                                                              .attributes
                                                              .toString());
                                                      value.updatePaymentName(
                                                          state.payment[index]
                                                              .title
                                                              .toString());
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          border: Border.all(
                                                              color: value.selectedPayment ==
                                                                      int.parse(state
                                                                          .payment[
                                                                              index]
                                                                          .id
                                                                          .toString())
                                                                  ? AppColors
                                                                      .appColor
                                                                  : Theme.of(
                                                                          context)
                                                                      .dividerTheme
                                                                      .color!)),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                              height: 60,
                                                              width: 60,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  border: Border.all(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .dividerTheme
                                                                          .color!)),
                                                              child: Image.network(
                                                                  "${Config.baseUrl}${state.payment[index].img}")),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                            flex: 10,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                    state
                                                                        .payment[
                                                                            index]
                                                                        .title
                                                                        .toString(),
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyMedium!),
                                                                const SizedBox(
                                                                  height: 2,
                                                                ),
                                                                Text(
                                                                    state
                                                                        .payment[
                                                                            index]
                                                                        .subtitle
                                                                        .toString(),
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodySmall!),
                                                              ],
                                                            ),
                                                          ),
                                                          const Spacer(flex: 1),
                                                          Radio(
                                                            activeColor:
                                                                AppColors
                                                                    .appColor,
                                                            value: value.selectedPayment ==
                                                                    int.parse(state
                                                                        .payment[
                                                                            index]
                                                                        .id
                                                                        .toString())
                                                                ? true
                                                                : false,
                                                            groupValue: true,
                                                            onChanged:
                                                                (value1) {
                                                              value.updateSelectPayment(
                                                                  int.parse(state
                                                                      .payment[
                                                                          index]
                                                                      .id
                                                                      .toString()));
                                                              value.updateAttributes(
                                                                  state
                                                                      .payment[
                                                                          index]
                                                                      .attributes
                                                                      .toString());
                                                              value.updatePaymentName(
                                                                  state
                                                                      .payment[
                                                                          index]
                                                                      .title
                                                                      .toString());
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                separatorBuilder:
                                                    (context, index) {
                                                  return const SizedBox(
                                                    height: 10,
                                                  );
                                                },
                                                itemCount:
                                                    state.payment.length);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                        } else {
                          // Fluttertoast.showToast(msg: "Select Plan".tr);
                          Fluttertoast.showToast(
                              msg: AppLocalizations.of(context)
                                      ?.translate("Select Plan") ??
                                  "Select Plan");
                        }
                      },
                    ))
                  ],
                ),
              );
            } else {
              return const SizedBox();
            }
          });
        } else {
          return const SizedBox();
        }
      }),
      body: BlocConsumer<PremiumBloc, PremiumState>(listener: (context, state) {
        if (state is PremiumError) {
          Fluttertoast.showToast(msg: state.error);
        }
      }, builder: (context, state) {
        if (state is PremiumComplete) {
          return BlocBuilder<HomePageCubit, HomePageStates>(
            builder: (context, state1) {
              if (state1 is HomeCompleteState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          clipBehavior: Clip.none,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return state.planData[index].status == "1"
                                ? Stack(
                                    clipBehavior: Clip.none,
                                    alignment: Alignment.topCenter,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (int.parse(state1.homeData.planId
                                                  .toString()) <=
                                              int.parse(state.planData[index].id
                                                  .toString())) {
                                            premiumProvider.updateSelectPlan(
                                                int.parse(
                                                    state.planData[index].id!));
                                            premiumProvider
                                                .updateSelectPlanPrice(
                                                    int.parse(state
                                                        .planData[index].amt!));
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(20),
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          decoration: BoxDecoration(
                                              color:
                                                  Theme.of(context).cardColor,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                  color: premiumProvider
                                                              .selectedPlan ==
                                                          int.parse(state
                                                              .planData[index]
                                                              .id!)
                                                      ? AppColors.appColor
                                                      : Theme.of(context)
                                                          .dividerTheme
                                                          .color!,
                                                  width: premiumProvider
                                                              .selectedPlan ==
                                                          int.parse(state.planData[index].id!)
                                                      ? 3
                                                      : 2)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  state.planData[index]
                                                      .description
                                                      .toString(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: -10,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                              color: AppColors.appColor,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Text(
                                            "${state.planData[index].title} - ${state.planData[index].dayLimit} Days",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    color: AppColors.white),
                                          ),
                                        ),
                                      ),
                                      state1.homeData.planId ==
                                              state.planData[index].id
                                          ? Positioned(
                                              top: -10,
                                              right: 40,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                                decoration: BoxDecoration(
                                                    color: AppColors.appColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                // child: Text("Active".tr,style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.white,fontSize: 12),),
                                                child: Text(
                                                  AppLocalizations.of(context)
                                                          ?.translate(
                                                              "Active") ??
                                                      "Active",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                          color:
                                                              AppColors.white,
                                                          fontSize: 12),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                    ],
                                  )
                                : const SizedBox();
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 20,
                            );
                          },
                          itemCount: state.planData.length),
                    ],
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          );
        } else {
          return Center(
              child: CircularProgressIndicator(color: AppColors.appColor));
        }
      }),
    );
  }
}
