 
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../core/theme/ui.dart';
import '../features/chatting/presentation/screen/chat_screen.dart';
import '../features/home/bloc/home_cubit.dart';
import '../features/home/bloc/home_provier.dart';
import '../features/home/bloc/home_state.dart';
import '../features/home/presentation/screen/home_screen.dart';
import '../features/likematch/presentation/screen/browser_screen.dart';
import '../features/map/presentation/screen/map_screen.dart';
import '../features/profile/presentation/screen/profile_screen.dart';

class BottomBar extends StatefulWidget {
  static const String bottomBarRoute = "/bottomBar";
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  List pages = [
    const HomeScreen(),
    const MapScreen(),
    const BrowserScreen(),
    const ChatScreen(),
    const ProfileScreen()
  ];
  List bottomItems = [
    "Home",
    "Maps",
    "Match",
    "Chats",
    "Profile",
  ];

  List bottomItemsIcons = [
    "assets/icons/Home.svg",
    "assets/icons/Discovery.svg",
    "assets/icons/Heart.svg",
    "assets/icons/Chat.svg",
    "assets/icons/Profile.svg",
  ];

  List bottomItemsIconsfill = [
    "assets/icons/Home-fill.svg",
    "assets/icons/Discovery-fill.svg",
    "assets/icons/Heart-fill.svg",
    "assets/icons/Chat-fill.svg",
    "assets/icons/Profile-fill.svg",
  ];

  late HomeProvider homeProvider;

  void _onItemTapped(int index) {
    setState(() {
      homeProvider.selectPageIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomePageCubit>(context, listen: false).initforHome(context);
  }

  @override
  Widget build(BuildContext context) {
    homeProvider = Provider.of<HomeProvider>(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent,
          bottomNavigationBar: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  height: 63,
                  margin: const EdgeInsets.only(
                      top: 10, bottom: 10, left: 15, right: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xff27262B),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      BlocBuilder<HomePageCubit, HomePageStates>(
                          builder: (context, state) {
                        if (state is HomeCompleteState) {
                          return ListView.builder(
                            clipBehavior: Clip.none,
                            itemCount: bottomItemsIcons.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: () {
                                    _onItemTapped(index);

                                    if (homeProvider.selectPageIndex == 2 &&
                                        state.homeData.likeMenu == "0") {
                                      homeProvider.setSelectPage(0);
                                      Navigator.pushNamed(
                                          context, "/premiumScreen");
                                    } else if (homeProvider.selectPageIndex ==
                                            3 &&
                                        (state.homeData.chat == "0")) {
                                      homeProvider.setSelectPage(0);
                                      Navigator.pushNamed(
                                          context, "/premiumScreen");
                                    }
                                  },
                                  child: Container(
                                    height: 45,
                                    // width: 50,
                                    width: constraints.maxWidth * 0.1833,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                      color:
                                          homeProvider.selectPageIndex == index
                                              ? AppColors.white
                                              : Colors.transparent,
                                      shape: BoxShape.circle,
                                    ),
                                    // color: Colors.red,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          homeProvider.selectPageIndex == index
                                              ? bottomItemsIconsfill[index]
                                              : bottomItemsIcons[index],
                                          width: 22,
                                          height: 22,
                                          colorFilter: ColorFilter.mode(
                                              homeProvider.selectPageIndex ==
                                                      index
                                                  ? AppColors.appColor
                                                  : AppColors.white,
                                              BlendMode.srcIn),
                                        ),
                                      ],
                                    ),
                                  ));
                            },
                          );
                        } else {
                          return ListView.builder(
                            clipBehavior: Clip.none,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: bottomItemsIcons.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Container(
                                height: 50,

                                width: constraints.maxWidth * 0.1833,
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                    color: homeProvider.selectPageIndex == index
                                        ? AppColors.white
                                        : Colors.transparent,
                                    shape: BoxShape.circle),
                                // color: Colors.red,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      homeProvider.selectPageIndex == index
                                          ? bottomItemsIconsfill[index]
                                          : bottomItemsIcons[index],
                                      width: 22,
                                      height: 22,
                                      colorFilter: ColorFilter.mode(
                                          homeProvider.selectPageIndex == index
                                              ? AppColors.appColor
                                              : AppColors.white,
                                          BlendMode.srcIn),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
          body: pages[homeProvider.selectPageIndex],
        );
      },
    );
  }
}
