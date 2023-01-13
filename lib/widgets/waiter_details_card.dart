import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waiterr/Model/waiter_details_model.dart';

class WaiterDetailsCard extends StatelessWidget {
  const WaiterDetailsCard(
      {Key? key,
      required this.waiter,
      required this.onMiddleTap,
      required this.onDeleteClicked,
      required this.onCallClicked})
      : super(key: key);
  final WaiterDetailsModel waiter;
  final Function() onMiddleTap;
  final Function() onDeleteClicked;
  final Function() onCallClicked;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onMiddleTap,
        child: Container(
            padding: const EdgeInsets.all(5),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width / 6.04,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  boxShadow: [
                    BoxShadow(
                      color: waiter.isActive
                          ? Colors.green.withOpacity(0.4)
                          : Colors.red.withOpacity(0.4),
                      offset: const Offset(2.0, 3.0),
                      blurRadius: 5,
                      spreadRadius: 5,
                    ), //BoxShadow
                  ],
                  color: Colors.white,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 5),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: Text(
                        waiter.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 22, height: 1),
                      ),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      child: Text(
                        waiter.mobileNumber,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Text(
                            "Last Login: ${DateFormat('MMMM d, y', 'en_US').format(DateTime.parse(waiter.lastLogin))}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          alignment: Alignment.bottomRight,
                          child: Text(
                              waiter.ucaRoleId == 4
                                  ? "Admin"
                                  : waiter.ucaRoleId == 3
                                      ? "Manager"
                                      : waiter.ucaRoleId == 2
                                          ? "Chef"
                                          : "Waiter",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 15, height: 1)),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(40, 25)),
                            onPressed: onCallClicked,
                            child: const Icon(Icons.call)),
                        const SizedBox(
                          width: 5,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                minimumSize: const Size(40, 25)),
                            onPressed: onDeleteClicked,
                            child: const Icon(Icons.delete_forever_outlined))
                      ],
                    )
                  ],
                ),
              ),
            )));
  }
}
