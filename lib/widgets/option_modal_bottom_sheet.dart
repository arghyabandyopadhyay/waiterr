import 'package:flutter/material.dart';

import '../Model/model_option_model.dart';

class OptionModalBottomSheet extends StatelessWidget {
  final String appBarText;
  final IconData appBarIcon;
  final List<ModalOptionModel> list;
  const OptionModalBottomSheet(
      {super.key,
      required this.list,
      required this.appBarText,
      required this.appBarIcon});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(appBarText,
            maxLines: 1, style: Theme.of(context).textTheme.bodyLarge),
        leading: IconButton(
          icon: Icon(appBarIcon),
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    list[index].particulars,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  leading: Icon(
                    list[index].icon,
                    color: list[index].iconColor,
                  ),
                  onTap: list[index].onTap,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
