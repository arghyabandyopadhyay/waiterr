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
            padding: const EdgeInsets.symmetric(horizontal: 5),
            margin: const EdgeInsets.all(0),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width / 6.04,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 5),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.5,
                            child: Text(
                              waiter.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 22, height: 1),
                            ),
                          ),
                          Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                color:
                                    waiter.isActive ? Colors.green : Colors.red,
                              ))
                        ]),
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
                        IconButton(
                            onPressed: onCallClicked,
                            icon: const Icon(Icons.call, color: Colors.black)),
                        const SizedBox(
                          width: 5,
                        ),
                        IconButton(
                            onPressed: onDeleteClicked,
                            icon: const Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                            ))
                      ],
                    )
                  ],
                ),
              ),
            )));
  }
}
