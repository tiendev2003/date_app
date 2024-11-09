import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/language/localization/app_localization.dart';
import '../../../../widget/indicator_widget.dart';
import '../../../../widget/main_button.dart';
import '../../bloc/onbording_provider.dart';

class OnBoardingScreen extends StatefulWidget {
  static const String onBoardingScreenRoute = "/OnBoardingScreen";
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late OnBordingProvider onBordingProvider;
  @override
  Widget build(BuildContext context) {
    onBordingProvider = Provider.of<OnBordingProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
              controller: onBordingProvider.onbordingScroll,
              onPageChanged: (value) {
                onBordingProvider.updateOnboradingCurrent(value);
              },
              itemCount: onBordingProvider.onBordingData.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(onBordingProvider
                              .onBordingData[index]["image"]))),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                );
              }),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(
                height: 25,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...List.generate(onBordingProvider.onBordingData.length,
                        (index) {
                      return IndicatorWidget(
                        isActive: onBordingProvider.onboradingCurrent == index
                            ? true
                            : false,
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                  AppLocalizations.of(context)?.translate(onBordingProvider
                          .onBordingData[onBordingProvider.onboradingCurrent]
                              ["title"]
                          .toString()) ??
                      "",
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                  maxLines: 2),
              const SizedBox(
                height: 20,
              ),
              onBordingProvider.onboradingCurrent ==
                      onBordingProvider.onBordingData.length - 1
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // MainButton(title: "Let's Start".tr,radius: 80,onTap: () {
                        Expanded(
                            child: InkWell(
                                onTap: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, "/authScreen", (route) => false);
                                },
                                // child: Text("Skip".tr,style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w700),textAlign: TextAlign.center,))),
                                child: Text(
                                  AppLocalizations.of(context)
                                          ?.translate("Skip") ??
                                      "Skip",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.center,
                                ))),
                        Expanded(
                          child: MainButton(
                            title: AppLocalizations.of(context)
                                    ?.translate("Let's Start") ??
                                "Let's Start",
                            radius: 80,
                            onTap: () {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, "/authScreen", (route) => false);
                            },
                          ),
                        ),
                      ],
                    )
                  : Row(children: [
                      Expanded(
                          child: InkWell(
                              onTap: () {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, "/authScreen", (route) => false);
                              },
                              child: Text(
                                AppLocalizations.of(context)
                                        ?.translate("Skip") ??
                                    "Skip",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center,
                              ))),
                      Expanded(
                          child: MainButton(
                        title:
                            AppLocalizations.of(context)?.translate("Next") ??
                                "Next",
                        radius: 80,
                        onTap: () {
                          onBordingProvider.onbordingScroll.jumpToPage(
                              onBordingProvider.onboradingCurrent + 1);
                        },
                      )),
                    ]),
            ]),
          ),
        ],
      ),
    );
  }
}
