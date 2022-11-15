//ConfirmationDialog

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme.dart';

class ConfirmationDialog extends StatelessWidget {
  final onTap_Yes;
  final onTap_No;
  final question;
  final headerText;
  // This widget is the root of your application.
  const ConfirmationDialog(
      {Key? key, this.onTap_Yes, this.onTap_No, this.question, this.headerText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)), //this right here
      child: Container(
        height: 160,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  headerText,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: Text(
                  question,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 17),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      onTap_No();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                            color: GlobalTheme.borderColor,
                            width: 1.5,
                            style: BorderStyle.solid),
                      ),
                      alignment: Alignment.center,
                      height: 40,
                      width: 80,
                      child: const Text(
                        "No",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      onTap_Yes();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                            color: GlobalTheme.borderColorHighlight,
                            width: 1.5,
                            style: BorderStyle.solid),
                      ),
                      child: const Text(
                        "Yes",
                        style: TextStyle(
                            fontSize: 20,
                            color: GlobalTheme.waiterrPrimaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
