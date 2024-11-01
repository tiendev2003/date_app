 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/language/localization/app_localization.dart';
import '../../../../widget/back_button.dart';
import '../../bloc/profile_provider.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  late ProfileProvider profileProvider;
  @override
  Widget build(BuildContext context) {
    profileProvider = Provider.of<ProfileProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: const BackButtons(),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        title: Text(
          AppLocalizations.of(context)?.translate("Faq") ?? "Faq",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ExpansionTile(
                    title: Text(
                        profileProvider.faqModel.faqData![index].question
                            .toString(),
                        style: Theme.of(context).textTheme.bodyMedium),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                            profileProvider.faqModel.faqData![index].answer
                                .toString(),
                            style: Theme.of(context).textTheme.bodySmall),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemCount: profileProvider.faqModel.faqData!.length)
          ],
        ),
      ),
    );
  }
}
