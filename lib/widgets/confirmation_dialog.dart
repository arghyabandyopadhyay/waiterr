//ConfirmationDialog

import 'package:flutter/material.dart';
import '../theme.dart';

class ConfirmationDialog extends StatelessWidget {
  final Function() onTapYes;
  final Function() onTapNo;
  final String question;
  final String headerText;
  // This widget is the root of your application.
  const ConfirmationDialog(
      {Key? key,
      required this.onTapYes,
      required this.onTapNo,
      required this.question,
      required this.headerText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)), //this right here
      child: SizedBox(
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
                      onTapNo();
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
                      onTapYes();
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
