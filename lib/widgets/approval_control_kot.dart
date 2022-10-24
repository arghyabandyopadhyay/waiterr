import 'package:waiterr/Model/kot_model.dart';
import 'package:waiterr/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ApprovalControlKOT extends StatefulWidget {
  final KOTModel currentKot;
  final Function() onApproval;
  final Function() onDisapproval;
  const ApprovalControlKOT(this.currentKot, this.onApproval, this.onDisapproval,
      {super.key});
  @override
  ApprovalControlKOTState createState() => ApprovalControlKOTState();
}

class ApprovalControlKOTState extends State<ApprovalControlKOT> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[800],
                minimumSize: const Size(120, 50)),
            onPressed: widget.onApproval,
            child: const Text("Approve")),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, minimumSize: const Size(120, 50)),
            onPressed: widget.onDisapproval,
            child: const Text("Disapprove"))
      ],
    );
  }
}
