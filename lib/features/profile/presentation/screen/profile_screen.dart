import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/config/config.dart';
import '../../../../core/language/localization/app_localization.dart';
import '../../../../core/model/local_database.dart';
import '../../../../core/theme/ui.dart';
import '../../../../main.dart';
import '../../../../widget/app_bar_custom.dart';
import '../../../../widget/bottom_bar.dart';
import '../../../../widget/main_button.dart';
import '../../../../widget/size_box_custom.dart';
import '../../../home/bloc/home_cubit.dart';
import '../../../home/bloc/home_provier.dart';
import '../../../home/bloc/home_state.dart';
import '../../../language/bloc/language_cubit.dart';
import '../../../onboarding/bloc/onbording_provider.dart';
import '../../../theme/bloc/lite_dark_cubit.dart';
import '../../bloc/profile_provider.dart';
import 'loream_screen.dart';
import 'profile_privacy_screen.dart';

List<CameraDescription> cameras = [];

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static const profilePageRoute = "/profilePage";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late HomeProvider homeProvider;
  late ProfileProvider profileProvider;
  late OnBordingProvider onBordingProvider;
  late CameraController imagecontroller;
  late HomePageCubit homePageCubit;
  late HomeCompleteState homeCompleteState;

  late Future<void> _initializeControllerFuture;
  late BuildContext ancestorContext;

  @override
  void initState() {
    super.initState();
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    profileProvider.faqApi(context);
    profileProvider.pageListApi(context);
    profileProvider.getPackage();
    getTheme().then((value) {
      setState(() {
        if (value == "dark") {
          profileProvider.isDartMode = true;
        } else {
          profileProvider.isDartMode = false;
        }
      });
    });
    BlocProvider.of<HomePageCubit>(context).getHomeData(
        uid: homeProvider.uid,
        lat: homeProvider.lat.toString(),
        long: homeProvider.long.toString(),
        context: context);

    imagecontroller = CameraController(
      cameras[0],
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = imagecontroller.initialize();
    getdata();
    fun();
  }

  @override
  void dispose() {
    imagecontroller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ancestorContext = context;
  }

  String networkImage = "";
  XFile? selectImageprofile;
  XFile? selectImageprofilevaridfy;
  ImagePicker picker = ImagePicker();
  ImagePicker pickervaridfy = ImagePicker();
  String? base64String;
  String? base64Stringverfy;

  bool _isFrontCamera = false;

  void _toggleCamera() async {
    CameraDescription newCameraDescription;
    if (_isFrontCamera) {
      newCameraDescription = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back);
    } else {
      newCameraDescription = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front);
    }

    if (imagecontroller.value.isRecordingVideo) {
      return;
    }

    // if (imagecontroller != null) {
    //   await imagecontroller.dispose();
    // }
    imagecontroller = CameraController(
      newCameraDescription,
      ResolutionPreset.medium,
    );

    setState(() {
      _isFrontCamera = !_isFrontCamera;
      _initializeControllerFuture = imagecontroller.initialize();
    });
  }

  int value = 0;

  List languageimage = [
    'assets/icons/L-VietNam.png',
    'assets/icons/L-English.png',
    'assets/icons/L-Korea.png',
    'assets/icons/L-Japan.png',
  ];

  List languagetext = [
    'Vietnamese',
    'English',
    'Korean',
    'Japanese',
  ];

  fun() async {
    for (int a = 0; a < languagetext.length; a++) {
      if (languagetext[a].toString().compareTo(Get.locale.toString()) == 0) {
        setState(() {
          value = a;
        });
      } else {}
    }
  }

  getdata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    value = preferences.getInt("valuelangauge")?? 0;
  }

  @override
  Widget build(BuildContext context) {
    homeProvider = Provider.of<HomeProvider>(context);
    profileProvider = Provider.of<ProfileProvider>(context);
    onBordingProvider = Provider.of<OnBordingProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: appBarCustom(context,
          AppLocalizations.of(context)?.translate("Profile") ?? "Profile"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: BlocBuilder<HomePageCubit, HomePageStates>(
                builder: (context1, state) {
              if (state is HomeCompleteState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            state.homeData.profilelist!.isEmpty
                                ? const SizedBox()
                                : SizedBox(
                                    height: 70,
                                    width: 70,
                                    child: CircularProgressIndicator(
                                        strokeCap: StrokeCap.round,
                                        strokeWidth: 4,
                                        // backgroundColor: Colors.red,
                                        valueColor: AlwaysStoppedAnimation(
                                            AppColors.appColor),
                                        value: (double.parse(state
                                                .homeData
                                                .profilelist![
                                                    homeProvider.currentIndex]
                                                .matchRatio
                                                .toString()
                                                .split(".")
                                                .first) /
                                            100)),
                                  ),
                            homeProvider.userlocalData.userLogin!.profilePic !=
                                    null
                                ? Container(
                                    height: 66,
                                    width: 66,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "${Config.baseUrl}${homeProvider.userlocalData.userLogin!.profilePic}"),
                                          fit: BoxFit.cover),
                                    ))
                                : selectImageprofile == null
                                    ? CircleAvatar(
                                        backgroundColor:
                                            Colors.grey.withOpacity(0.2),
                                        maxRadius: 33,
                                        child: Center(
                                            child: Text(
                                          "${homeProvider.userlocalData.userLogin!.name?[0]}",
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      )
                                    : Container(
                                        height: 70,
                                        width: 70,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: FileImage(File(
                                                  selectImageprofile!.path)),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                            state.homeData.planId != "0"
                                ? Positioned(
                                    top: -10,
                                    child: Image.asset(
                                      "assets/icons/tajicon.png",
                                      height: 25,
                                      width: 25,
                                    ),
                                  )
                                : const SizedBox(),
                            state.homeData.profilelist!.isEmpty
                                ? const SizedBox()
                                : Positioned(
                                    bottom: -10,
                                    child: Container(
                                      height: 22,
                                      width: 35,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 3),
                                        // color: AppColors.appColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Container(
                                        height: 22,
                                        width: 35,
                                        decoration: BoxDecoration(
                                          // border: Border.all(color: Colors.white,width: 0.2),
                                          color: AppColors.appColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "${state.homeData.profilelist![homeProvider.currentIndex].matchRatio.toString().split(".").first}%",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    color: Colors.white,
                                                    fontSize: 9,
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                          ],
                        ),
                        const SizBoxW(size: 0.02),
                        BlocBuilder<HomePageCubit, HomePageStates>(
                            builder: (context, state) {
                          if (state is HomeCompleteState) {
                            return Expanded(
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      "${homeProvider.userlocalData.userLogin!.name}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  state.homeData.isVerify == "0"
                                      ? InkWell(
                                          onTap: () {
                                            showDialog<String>(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                elevation: 0,
                                                insetPadding:
                                                    const EdgeInsets.only(
                                                        left: 10, right: 10),
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .scaffoldBackgroundColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                title: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Center(
                                                        child: Icon(
                                                            Icons.camera_alt,
                                                            color: AppColors
                                                                .appColor,
                                                            size: 30)),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),

                                                    Center(
                                                        child: Text(
                                                      AppLocalizations.of(
                                                                  context)
                                                              ?.translate(
                                                                  "Get Photo Verified") ??
                                                          "Get Photo Verified",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineSmall!
                                                          .copyWith(
                                                              fontSize: 22),
                                                    )),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    // Text("We want to know it`s really you.".tr,style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 16),),
                                                    Text(
                                                      AppLocalizations.of(
                                                                  context)
                                                              ?.translate(
                                                                  "We want to know it`s really you.") ??
                                                          "We want to know it`s really you.",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineSmall!
                                                          .copyWith(
                                                              fontSize: 16),
                                                    ),
                                                    // const SizedBox(height: 10,),
                                                    ListTile(
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      title: Text(
                                                        AppLocalizations.of(
                                                                    context)
                                                                ?.translate(
                                                                    "Tack a quick video selfie") ??
                                                            "Tack a quick video selfie",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headlineSmall!
                                                            .copyWith(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                      subtitle: Text(
                                                        AppLocalizations.of(
                                                                    context)
                                                                ?.translate(
                                                                    "Confirm you`re the person in your photos.") ??
                                                            "Confirm you`re the person in your photos.",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headlineSmall!
                                                            .copyWith(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .grey),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    MainButton(
                                                        bgColor:
                                                            AppColors.appColor,
                                                        titleColor:
                                                            Colors.white,
                                                        // title: "Continue".tr,
                                                        title: AppLocalizations
                                                                    .of(context)
                                                                ?.translate(
                                                                    "Continue") ??
                                                            "Continue",
                                                        onTap: () {
                                                          showDialog<String>(
                                                            barrierDismissible:
                                                                false,
                                                            context: context,
                                                            builder: (BuildContext
                                                                    context) =>
                                                                AlertDialog(
                                                              elevation: 0,
                                                              insetPadding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 10,
                                                                      right:
                                                                          10),
                                                              backgroundColor:
                                                                  Theme.of(
                                                                          context)
                                                                      .scaffoldBackgroundColor,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                              ),
                                                              title: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Center(
                                                                      child:
                                                                          Text(
                                                                    AppLocalizations.of(context)
                                                                            ?.translate("Before you continue...") ??
                                                                        "Before you continue...",
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .headlineSmall!
                                                                        .copyWith(
                                                                            fontSize:
                                                                                22),
                                                                  )),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  ListTile(
                                                                    isThreeLine:
                                                                        true,
                                                                    contentPadding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    leading:
                                                                        Container(
                                                                      height:
                                                                          20,
                                                                      width: 20,
                                                                      decoration: BoxDecoration(
                                                                          color: AppColors
                                                                              .appColor,
                                                                          borderRadius:
                                                                              BorderRadius.circular(65)),
                                                                      child: const Center(
                                                                          child: Icon(
                                                                        Icons
                                                                            .check,
                                                                        color: Colors
                                                                            .white,
                                                                        size:
                                                                            12,
                                                                      )),
                                                                    ),
                                                                    // title: Transform.translate(offset: const Offset(-10, -3),child: Text("Prep your lighting".tr,style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 18,fontWeight: FontWeight.bold),)),
                                                                    title: Transform
                                                                        .translate(
                                                                            offset: const Offset(-10,
                                                                                -3),
                                                                            child:
                                                                                Text(
                                                                              AppLocalizations.of(context)?.translate("Prep your lighting") ?? "Prep your lighting",
                                                                              style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                                                                            )),
                                                                    subtitle:
                                                                        Transform
                                                                            .translate(
                                                                      offset:
                                                                          const Offset(
                                                                              -10,
                                                                              0),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          // SizedBox(height: 5,),

                                                                          Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(top: 7.0),
                                                                                child: Container(
                                                                                  height: 7,
                                                                                  width: 7,
                                                                                  decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                                                                                ),
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 5,
                                                                              ),
                                                                              Flexible(
                                                                                  child: Text(
                                                                                AppLocalizations.of(context)?.translate("Choose a well-lit environment") ?? "Choose a well-lit environment",
                                                                                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                                                                      fontSize: 16,
                                                                                      color: Colors.grey,
                                                                                    ),
                                                                                maxLines: 2,
                                                                              ))
                                                                            ],
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(top: 7.0),
                                                                                child: Container(
                                                                                  height: 7,
                                                                                  width: 7,
                                                                                  decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                                                                                ),
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 5,
                                                                              ),
                                                                              // Flexible(child: Text("Turn up your brightness".tr,style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 16,color: Colors.grey,),maxLines: 2,))
                                                                              Flexible(
                                                                                  child: Text(
                                                                                AppLocalizations.of(context)?.translate("Turn up your brightness") ?? "Turn up your brightness",
                                                                                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                                                                      fontSize: 16,
                                                                                      color: Colors.grey,
                                                                                    ),
                                                                                maxLines: 2,
                                                                              ))
                                                                            ],
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(top: 7.0),
                                                                                child: Container(
                                                                                  height: 7,
                                                                                  width: 7,
                                                                                  decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                                                                                ),
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 5,
                                                                              ),
                                                                              Flexible(
                                                                                  child: Text(
                                                                                "Avoid ${homeProvider.userlocalData.userLogin!.name} glare and backlighting",
                                                                                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                                                                      fontSize: 16,
                                                                                      color: Colors.grey,
                                                                                    ),
                                                                                maxLines: 2,
                                                                              ))
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  ListTile(
                                                                    isThreeLine:
                                                                        true,
                                                                    contentPadding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    leading:
                                                                        Container(
                                                                      height:
                                                                          20,
                                                                      width: 20,
                                                                      decoration: BoxDecoration(
                                                                          color: AppColors
                                                                              .appColor,
                                                                          borderRadius:
                                                                              BorderRadius.circular(65)),
                                                                      child: const Center(
                                                                          child: Icon(
                                                                        Icons
                                                                            .check,
                                                                        color: Colors
                                                                            .white,
                                                                        size:
                                                                            12,
                                                                      )),
                                                                    ),
                                                                    // title: Transform.translate(offset: Offset(-10, -3),child: Text("Show your face".tr,style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 18,fontWeight: FontWeight.bold),)),
                                                                    title: Transform
                                                                        .translate(
                                                                            offset: const Offset(-10,
                                                                                -3),
                                                                            child:
                                                                                Text(
                                                                              AppLocalizations.of(context)?.translate("Show your face") ?? "Show your face",
                                                                              style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                                                                            )),
                                                                    subtitle:
                                                                        Transform
                                                                            .translate(
                                                                      offset:
                                                                          const Offset(
                                                                              -10,
                                                                              0),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(top: 7.0),
                                                                                child: Container(
                                                                                  height: 7,
                                                                                  width: 7,
                                                                                  decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                                                                                ),
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 5,
                                                                              ),
                                                                              Flexible(
                                                                                  child: Text(
                                                                                AppLocalizations.of(context)?.translate("Face the camera directly") ?? "Face the camera directly",
                                                                                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                                                                      fontSize: 16,
                                                                                      color: Colors.grey,
                                                                                    ),
                                                                                maxLines: 2,
                                                                              ))
                                                                            ],
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(top: 7.0),
                                                                                child: Container(
                                                                                  height: 7,
                                                                                  width: 7,
                                                                                  decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                                                                                ),
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 5,
                                                                              ),
                                                                              // Flexible(child: Text("Remove hats, sunglasses, and face coverings".tr,style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 16,color: Colors.grey,),maxLines: 2,))
                                                                              Flexible(
                                                                                  child: Text(
                                                                                AppLocalizations.of(context)?.translate("Remove hats, sunglasses, and face coverings") ?? "Remove hats, sunglasses, and face coverings",
                                                                                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                                                                      fontSize: 16,
                                                                                      color: Colors.grey,
                                                                                    ),
                                                                                maxLines: 2,
                                                                              ))
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  MainButton(
                                                                      bgColor:
                                                                          AppColors
                                                                              .appColor,
                                                                      titleColor:
                                                                          Colors
                                                                              .white,
                                                                      title: AppLocalizations.of(context)?.translate(
                                                                              "Continue") ??
                                                                          "Continue",
                                                                      onTap:
                                                                          () async {
                                                                        showModalBottomSheet(
                                                                            isScrollControlled:
                                                                                true,
                                                                            backgroundColor: Theme.of(context)
                                                                                .scaffoldBackgroundColor,
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (c) {
                                                                              return StatefulBuilder(
                                                                                builder: (context, setState) {
                                                                                  return Container(
                                                                                    padding: const EdgeInsets.all(15),
                                                                                    decoration: BoxDecoration(
                                                                                      color: Theme.of(context).scaffoldBackgroundColor,
                                                                                      borderRadius: BorderRadius.circular(16),
                                                                                    ),
                                                                                    child: SafeArea(
                                                                                      child: Scaffold(
                                                                                        resizeToAvoidBottomInset: false,
                                                                                        body: SingleChildScrollView(
                                                                                          child: Column(
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              const SizedBox(
                                                                                                height: 30,
                                                                                              ),
                                                                                              InkWell(
                                                                                                  onTap: () {
                                                                                                    Navigator.pop(context);
                                                                                                  },
                                                                                                  child: const Icon(Icons.close)),
                                                                                              const SizedBox(
                                                                                                height: 10,
                                                                                              ),
                                                                                              // Center(child: Text("Get ready for".tr,style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 24,fontWeight: FontWeight.bold))),
                                                                                              Center(child: Text(AppLocalizations.of(context)?.translate("Get ready for") ?? "Get ready for", style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 24, fontWeight: FontWeight.bold))),
                                                                                              // Center(child: Text("your image selfie".tr,style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 24,fontWeight: FontWeight.bold))),
                                                                                              Center(child: Text(AppLocalizations.of(context)?.translate("your image selfie") ?? "your image selfie", style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 24, fontWeight: FontWeight.bold))),
                                                                                              const SizedBox(
                                                                                                height: 10,
                                                                                              ),
                                                                                              Center(
                                                                                                child: ClipOval(
                                                                                                  child: SizedBox(
                                                                                                    height: 350,
                                                                                                    width: 230,
                                                                                                    child: selectImageprofilevaridfy == null
                                                                                                        ? GestureDetector(
                                                                                                            onDoubleTap: () {
                                                                                                              setState(() {
                                                                                                                _toggleCamera();
                                                                                                              });
                                                                                                            },
                                                                                                            child: FutureBuilder<void>(
                                                                                                              future: _initializeControllerFuture,
                                                                                                              builder: (context, snapshot) {
                                                                                                                if (snapshot.connectionState == ConnectionState.done) {
                                                                                                                  return CameraPreview(imagecontroller);
                                                                                                                } else {
                                                                                                                  return Center(
                                                                                                                      child: CircularProgressIndicator(
                                                                                                                    color: AppColors.appColor,
                                                                                                                  ));
                                                                                                                }
                                                                                                              },
                                                                                                            ),
                                                                                                          )
                                                                                                        : Image.file(File(selectImageprofilevaridfy!.path), fit: BoxFit.cover),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              // selectImageprofilevaridfy == null ? Container(height: 20,width: 20,color: Colors.yellow,) : Image.file(File(selectImageprofilevaridfy!.path),),
                                                                                              const SizedBox(
                                                                                                height: 10,
                                                                                              ),
                                                                                              // Center(child: Text("Make sure to frame your face in the oval, then tap  'i`m ready'!".tr,style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 16,fontWeight: FontWeight.bold),maxLines: 2,textAlign: TextAlign.center,)),
                                                                                              Center(
                                                                                                  child: Text(
                                                                                                AppLocalizations.of(context)?.translate("Make sure to frame your face in the oval, then tap  'I am Ready'!") ?? "Make sure to frame your face in the oval, then tap  'I am Ready'!",
                                                                                                style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                                                                                                maxLines: 2,
                                                                                                textAlign: TextAlign.center,
                                                                                              )),
                                                                                              const SizedBox(
                                                                                                height: 10,
                                                                                              ),
                                                                                              MainButton(
                                                                                                bgColor: AppColors.appColor, titleColor: Colors.white,
                                                                                                // title: "i m ready".tr,
                                                                                                title: AppLocalizations.of(context)?.translate("I am Ready") ?? "I am Ready",
                                                                                                onTap: () async {
                                                                                                  try {
                                                                                                    await _initializeControllerFuture;
                                                                                                    selectImageprofilevaridfy = await imagecontroller.takePicture();
                                                                                                    List<int> imageByte = File(selectImageprofilevaridfy!.path).readAsBytesSync();
                                                                                                    base64Stringverfy = base64Encode(imageByte);

                                                                                                    profileProvider.identiverifyApi(context: navigatorKey.currentContext!, img: base64Stringverfy.toString()).then((value) {
                                                                                                      Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const BottomBar()), (route) => false);
                                                                                                      setState(() {});
                                                                                                    });
                                                                                                  } catch (e) {
                                                                                                    log('Error taking picture: $e');
                                                                                                  }

                                                                                                  setState(() {});
                                                                                                },
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              );
                                                                            });
                                                                      }),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      //  tắt hết các dialog

                                                                      Navigator.of(
                                                                              context)
                                                                          .popUntil((route) =>
                                                                              route.isFirst);
                                                                    },
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        AppLocalizations.of(context)?.translate("Maybe Later") ??
                                                                            "Maybe Later",
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headlineSmall!
                                                                            .copyWith(fontSize: 18),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        })
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.only(top: 4.0),
                                            child: Image(
                                                image: AssetImage(
                                                    "assets/icons/newverfy.png"),
                                                height: 22,
                                                width: 22),
                                          ),
                                        )
                                      : state.homeData.isVerify == "1"
                                          ? InkWell(
                                              onTap: () {
                                                showDialog<String>(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                    elevation: 0,
                                                    insetPadding:
                                                        const EdgeInsets.only(
                                                            left: 10,
                                                            right: 10),
                                                    backgroundColor: Theme.of(
                                                            context)
                                                        .scaffoldBackgroundColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    title: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          height: 100,
                                                          width: 100,
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              image: DecorationImage(
                                                                  image: NetworkImage(
                                                                      "${Config.baseUrl}/${homeProvider.userlocalData.userLogin!.identityPicture}"),
                                                                  fit: BoxFit
                                                                      .cover)),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),

                                                        Center(
                                                            child: Text(
                                                          AppLocalizations.of(
                                                                      context)
                                                                  ?.translate(
                                                                      "verification Under") ??
                                                              "verification Under",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headlineSmall!
                                                              .copyWith(
                                                                  fontSize: 22),
                                                        )),
                                                        Center(
                                                            child: Text(
                                                          'Review',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headlineSmall!
                                                              .copyWith(
                                                                  fontSize: 22),
                                                        )),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 15,
                                                                  right: 15),
                                                          child: Text(
                                                              AppLocalizations.of(
                                                                          context)
                                                                      ?.translate(
                                                                          "We are currently reviewing your selfies and will get back to you shortly!") ??
                                                                  "We are currently reviewing your selfies and will get back to you shortly!",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headlineSmall!
                                                                  .copyWith(
                                                                      fontSize:
                                                                          16),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center),
                                                        ),
                                                        // const SizedBox(height: 10,),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        MainButton(
                                                            bgColor: AppColors
                                                                .appColor,
                                                            titleColor:
                                                                Colors.white,
                                                            // title: "OKAY".tr,
                                                            title: AppLocalizations.of(
                                                                        context)
                                                                    ?.translate(
                                                                        "OKAY") ??
                                                                "OKAY",
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            }),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: const Padding(
                                                padding:
                                                    EdgeInsets.only(top: 4.0),
                                                child: Image(
                                                  image: AssetImage(
                                                      "assets/icons/progressicon.png"),
                                                  height: 22,
                                                  width: 22,
                                                ),
                                              ),
                                            )
                                          : const Padding(
                                              padding:
                                                  EdgeInsets.only(top: 4.0),
                                              child: Image(
                                                image: AssetImage(
                                                    "assets/icons/approveicon.png"),
                                                height: 22,
                                                width: 22,
                                              ),
                                            ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        }),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                              ),
                              builder: (context) {
                                return _buildImageSelectionModal(context);
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.appColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  AppLocalizations.of(context)
                                          ?.translate("Edit") ??
                                      "Edit",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(color: AppColors.white),
                                ),
                                const SizedBox(width: 5),
                                SvgPicture.asset("assets/icons/edit.svg"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: () {
                        state.homeData.planId != "0"
                            ? Navigator.pushNamed(
                                context,
                                "/planScreen",
                              )
                            : Navigator.pushNamed(
                                context,
                                "/premiumScreen",
                              );
                      },
                      child: Container(
                        // height: 110,
                        width: MediaQuery.of(context).size.width,
                        // padding: const EdgeInsets.all(12),

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.appColor,
                          image: const DecorationImage(
                              image: AssetImage("assets/Image/profileBg.png"),
                              fit: BoxFit.cover),
                        ),

                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        state.homeData.planId != "0"
                                            ? AppLocalizations.of(context)
                                                    ?.translate(
                                                        "You're Activated Membership!") ??
                                                "You're Activated Membership!"
                                            : AppLocalizations.of(context)
                                                    ?.translate(
                                                        "Join Our Membership Today!") ??
                                                "Join Our Membership Today!",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                                color: AppColors.white,
                                                fontWeight: FontWeight.w700),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                        state.homeData.planId != "0"
                                            ? AppLocalizations.of(context)
                                                    ?.translate(
                                                        "Enjoy  premium and match anywhere.") ??
                                                "Enjoy  premium and match anywhere."
                                            : AppLocalizations.of(context)
                                                    ?.translate(
                                                        "Checkout GoMeet Premium") ??
                                                "Checkout GoMeet Premium",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                                color: AppColors.white,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 8),
                                decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Text(
                                    state.homeData.planId != "0"
                                        ? AppLocalizations.of(context)
                                                ?.translate("Active") ??
                                            "Active"
                                        : AppLocalizations.of(context)
                                                ?.translate("Go") ??
                                            "Go",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: AppColors.appColor)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizBoxH(size: 0.01),
                    ListView.builder(
                        clipBehavior: Clip.none,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (c, i) {
                          return i == 2
                              ? profileProvider.isLoading
                                  ? ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoreamScreen(
                                                          title: profileProvider
                                                              .privacyPolicy
                                                              .pagelist![index]
                                                              .title
                                                              .toString(),
                                                          discription:
                                                              profileProvider
                                                                  .privacyPolicy
                                                                  .pagelist![
                                                                      index]
                                                                  .description
                                                                  .toString()),
                                                ));
                                          },
                                          dense: true,
                                          contentPadding: EdgeInsets.zero,
                                          leading: SizedBox(
                                            height: 30,
                                            width: 30,
                                            child: Center(
                                              child: SvgPicture.asset(
                                                "assets/icons/clipboard-text.svg",
                                                colorFilter: ColorFilter.mode(
                                                    Theme.of(context)
                                                        .indicatorColor,
                                                    BlendMode.srcIn),
                                                // height: 25,
                                                // width: 25,
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            profileProvider.privacyPolicy
                                                .pagelist![index].title
                                                .toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!,
                                          ),
                                          trailing: SvgPicture.asset(
                                            "assets/icons/Arrow - Right 2.svg",
                                            colorFilter: ColorFilter.mode(
                                                Theme.of(context)
                                                    .indicatorColor,
                                                BlendMode.srcIn),
                                          ),
                                        );
                                      },
                                      itemCount: profileProvider
                                          .privacyPolicy.pagelist!.length)
                                  : const SizedBox()
                              : ListTile(
                                  onTap: () async {
                                    if (i == 0) {
                                      Navigator.pushNamed(context, "/editPage");
                                    } else if (i == 3) {
                                      Navigator.pushNamed(context, "/faqPage");
                                    } else if (i == 4) {
                                      profileProvider
                                          .blocklistaApi(context)
                                          .then((value) {
                                        Navigator.push(
                                            navigatorKey.currentContext!,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ProfilePrivacyScreen(),
                                            ));
                                        setState(() {});
                                      });
                                    } else if (i == 5) {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (context) {
                                          return Container(
                                            height: 400,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(15),
                                                      topLeft:
                                                          Radius.circular(15)),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15, right: 15, top: 10),
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    ListView.builder(
                                                      shrinkWrap: true,
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      itemCount: 4,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return GestureDetector(
                                                          onTap: () async {
                                                            SharedPreferences
                                                                preferences =
                                                                await SharedPreferences
                                                                    .getInstance();

                                                            setState(() {
                                                              value = index;
                                                              preferences.setInt(
                                                                  "valuelangauge",
                                                                  value);
                                                            });

                                                            switch (index) {
                                                              case 0:
                                                                BlocProvider.of<
                                                                            LanguageCubit>(
                                                                        navigatorKey
                                                                            .currentContext!)
                                                                    .toVietNamese();
                                                                Navigator.pop(
                                                                    navigatorKey
                                                                        .currentContext!);
                                                                break;
                                                              case 1:
                                                                BlocProvider.of<
                                                                            LanguageCubit>(
                                                                        navigatorKey
                                                                            .currentContext!)
                                                                    .toEnglish();
                                                                Navigator.pop(
                                                                    navigatorKey
                                                                        .currentContext!);
                                                                break;
                                                              case 2:
                                                                BlocProvider.of<
                                                                            LanguageCubit>(
                                                                        navigatorKey
                                                                            .currentContext!)
                                                                    .toKorea();
                                                                Navigator.pop(
                                                                    navigatorKey
                                                                        .currentContext!);
                                                                break;
                                                              case 3:
                                                                BlocProvider.of<
                                                                            LanguageCubit>(
                                                                        navigatorKey
                                                                            .currentContext!)
                                                                    .toJapan();
                                                                Navigator.pop(
                                                                    navigatorKey
                                                                        .currentContext!);
                                                                break;
                                                            }
                                                          },
                                                          child: Container(
                                                            height: 60,
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        7),
                                                            decoration:
                                                                BoxDecoration(
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: value ==
                                                                              index
                                                                          ? AppColors
                                                                              .appColor
                                                                          : Colors
                                                                              .transparent,
                                                                    ),
                                                                    color: Theme.of(
                                                                            context)
                                                                        .scaffoldBackgroundColor,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                            child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        height:
                                                                            45,
                                                                        width:
                                                                            60,
                                                                        margin: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                10),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Colors.transparent,
                                                                          borderRadius:
                                                                              BorderRadius.circular(100),
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                32,
                                                                            width:
                                                                                32,
                                                                            decoration: BoxDecoration(
                                                                                image: DecorationImage(
                                                                              image: AssetImage(languageimage[index]),
                                                                            )),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              10),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                              languagetext[index],
                                                                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 14)),
                                                                        ],
                                                                      ),
                                                                      const Spacer(),
                                                                      checkboxListTile(
                                                                          index),
                                                                      const SizedBox(
                                                                        width:
                                                                            15,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]),
                                                          ),
                                                        );
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    } else if (i ==
                                        profileProvider.menuList.length - 2) {
                                      profileProvider
                                          .deleteButtomSheet(context);
                                    } else if (i ==
                                        profileProvider.menuList.length - 3) {
                                      Share.share(
                                        "Hey! 👋've found this awesome dating app called ${profileProvider.appName} and thought you might be interested too! 😊.Check it out:${Platform.isAndroid ? 'https://play.google.com/store/apps/details?id=${profileProvider.packageName}' : Platform.isIOS ? 'https://apps.apple.com/us/app/${profileProvider.appName}/id${profileProvider.packageName}' : ""}",
                                      );
                                    } else if (i ==
                                        profileProvider.menuList.length - 1) {
                                      isUserLogOut(Provider.of<HomeProvider>(
                                              context,
                                              listen: false)
                                          .uid);
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        "/authScreen",
                                        (route) => false,
                                      );
                                      homeProvider.setSelectPage(0);
                                      Preferences.clear();
                                      await GoogleSignIn().signOut();
                                    }
                                  },
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  leading: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: Center(
                                      child: SvgPicture.asset(
                                        "${profileProvider.menuList[i]["icon"]}",
                                        colorFilter: ColorFilter.mode(
                                            profileProvider.menuList[i]
                                                        ["iconShow"] ==
                                                    "0"
                                                ? Colors.red
                                                : Theme.of(context)
                                                    .indicatorColor,
                                            BlendMode.srcIn),
                                        // height: 25,
                                        // width: 25,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    AppLocalizations.of(context)?.translate(
                                            "${profileProvider.menuList[i]["title"]}") ??
                                        "${profileProvider.menuList[i]["title"]}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: profileProvider.menuList[i]
                                                        ["iconShow"] ==
                                                    "0"
                                                ? Colors.red
                                                : null),
                                  ),
                                  trailing: profileProvider.menuList[i]
                                              ["iconShow"] ==
                                          "2"
                                      ? SizedBox(
                                          height: 40,
                                          width: 30,
                                          child: Transform.scale(
                                              scale: 0.7,
                                              child: Switch(
                                                  value: profileProvider
                                                      .isDartMode,
                                                  onChanged: (r) async {
                                                    profileProvider
                                                        .changeMode();

                                                    if (r) {
                                                      BlocProvider.of<
                                                                  ThemeBloc>(
                                                              context)
                                                          .addTheme(ThemeEvent
                                                              .toggleDark);
                                                      setThemeData('dark');
                                                    } else {
                                                      BlocProvider.of<
                                                                  ThemeBloc>(
                                                              context)
                                                          .addTheme(ThemeEvent
                                                              .toggleLight);
                                                      setThemeData('lite');
                                                    }
                                                  })),
                                        )
                                      : profileProvider.menuList[i]
                                                  ["iconShow"] ==
                                              "1"
                                          ? SvgPicture.asset(
                                              "${profileProvider.menuList[i]["traling"]}",
                                              colorFilter: ColorFilter.mode(
                                                  Theme.of(context)
                                                      .indicatorColor,
                                                  BlendMode.srcIn),
                                            )
                                          : const SizedBox(),
                                );
                        },
                        itemCount: profileProvider.menuList.length),
                    // SizedBox(height: 100,)
                  ],
                );
              } else {
                return Center(
                    child:
                        CircularProgressIndicator(color: AppColors.appColor));
              }
            }),
          ),
        ),
      ),
    );
  }

  setThemeData(String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString("ThemeData", value);
  }

  Widget checkboxListTile(int index) {
    return SizedBox(
      height: 24,
      width: 24,
      child: ElevatedButton(
        onPressed: () async {
          value = index;
          SharedPreferences preferences = await SharedPreferences.getInstance();
          setState(() {
            value = index;
            preferences.setInt("valuelangauge", value);

            switch (index) {
              case 0:
                BlocProvider.of<LanguageCubit>(context).toVietNamese();
                Navigator.pop(context);
                break;
              case 1:
                BlocProvider.of<LanguageCubit>(context).toEnglish();
                Navigator.pop(context);
                break;
              case 2:
                BlocProvider.of<LanguageCubit>(context).toKorea();
                Navigator.pop(context);
                break;
              case 3:
                BlocProvider.of<LanguageCubit>(context).toJapan();
                Navigator.pop(context);
                break;
            }
          });
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xffEEEEEE),
          side: BorderSide(
            color: (value == index) ? Colors.transparent : Colors.transparent,
            width: (value == index) ? 2 : 2,
          ),
          padding: const EdgeInsets.all(0),
        ),
        child: Center(
            child: Icon(
          Icons.check,
          color: value == index ? Colors.black : Colors.transparent,
          size: 18,
        )),
      ),
    );
  }

  Widget _buildImageSelectionModal(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context)?.translate(
                      "From where do you want to take the photo?") ??
                  "From where do you want to take the photo?",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: MainButton(
                    bgColor: AppColors.appColor,
                    titleColor: Colors.white,
                    title: AppLocalizations.of(context)?.translate("Gallery") ??
                        "Gallery",
                    onTap: () => _selectImageFromGallery(context),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: MainButton(
                    bgColor: AppColors.appColor,
                    titleColor: Colors.white,
                    title: AppLocalizations.of(context)?.translate("Camera") ??
                        "Camera",
                    onTap: () => _selectImageFromCamera(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Future<void> _selectImageFromGallery(BuildContext context) async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      _processSelectedImage(navigatorKey.currentContext!, picked.path);
    } else {
      log("No image selected!");
    }
  }

  Future<void> _selectImageFromCamera(BuildContext context) async {
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      _processSelectedImage(navigatorKey.currentContext!, picked.path);
    } else {
      log("No image selected!");
    }
  }

  void _processSelectedImage(BuildContext context, String imagePath) {
    final image = File(imagePath);

    profileProvider.profilepicApi(context: context, img: image).then((value) {
      Navigator.of(navigatorKey.currentContext!).pop();
      setState(() {
        // Update UI if necessary
        picker = ImagePicker();
      });
    });
  }
}