import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/config/config.dart';
import '../../../../core/language/localization/app_localization.dart';
import '../../../../main.dart';
import 'chat_page.dart';
import 'pick_up_audio_screen.dart';

class AudioCallingScreen extends StatefulWidget {
  const AudioCallingScreen(
      {super.key, required this.userData, required this.channel});
  final Map userData;
  final String channel;
  @override
  State<AudioCallingScreen> createState() => _AudioCallingScreenState();
}

class _AudioCallingScreenState extends State<AudioCallingScreen> {
  @override
  void initState() {
    super.initState();
    print(widget.userData);
    print(widget.channel);
    // isAudio(widget.userData["Audio"], true);
    FirebaseFirestore.instance
        .collection("chat_rooms")
        .doc(widget.channel)
        .collection("isVcAvailable")
        .doc(widget.channel)
        .snapshots()
        .listen((event) {
      Map data = event.data()!;
      print(data);
      if (data["Audio"] == true) {
        print(" 0 0 0 0 0 0 0 0 0 0 $data");
        Navigator.pop(navigatorKey.currentContext!);
        Navigator.push(
            navigatorKey.currentContext!,
            MaterialPageRoute(
              builder: (context) => PickUpAudioScreen(
                  channel: widget.channel, userData: widget.userData),
            ));
        // });
      } else if (data["Audio"] == false) {
        Navigator.pop(navigatorKey.currentContext!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [
            0.1,
            0.2,
            0.4,
            0.6,
            0.7,
          ],
          colors: [
            Color(0xff62e2f4),
            Color(0xff8290f4),
            Color(0xfff269cf),
            Color(0xffef5b5e),
            Color(0xfff07f51),
            // Colors.red,
            // Colors.indigo,
            // Colors.teal,
          ],
        )),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Spacer(),
          CircleAvatar(
            radius: 70,
            backgroundImage:
                NetworkImage("${Config.baseUrl}${widget.userData["pro_pic"]}"),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.userData["name"],
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: Colors.white),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            AppLocalizations.of(context)?.translate("Ringing..") ?? "Ringing..",
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.white),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  isAudio(widget.channel, false);
                },
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.red),
                  child: Center(
                      child: SvgPicture.asset("assets/icons/Call Missed.svg",
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn))),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }
}
