
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class LoreamScreen extends StatefulWidget {
  const LoreamScreen(
      {super.key, required this.title, required this.discription});
  final String title;
  final String discription;
  @override
  State<LoreamScreen> createState() => _LoreamScreenState();
}

class _LoreamScreenState extends State<LoreamScreen> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).indicatorColor,
          ),
        ),
        title: Text(
         widget.title,
          style: Theme.of(context).textTheme.bodyLarge
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 20),
                child: Column(children: [
                  (widget.discription.isNotEmpty)
                      ? HtmlWidget(
                    widget.discription,
                    textStyle: TextStyle(
                        color: Theme.of(context).indicatorColor,
                        fontSize: MediaQuery.of(context).size.height / 50,
                        fontFamily: 'Gilroy Normal'),
                  )
                      : Text(
                    "",
                    style: TextStyle(
                        color: Theme.of(context).indicatorColor,
                        fontSize: MediaQuery.of(context).size.height / 50,
                        fontFamily: 'Gilroy Normal'),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
