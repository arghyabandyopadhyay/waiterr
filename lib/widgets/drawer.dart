import 'package:waiterr/Model/drawer_action_model.dart';
import 'package:flutter/material.dart';
import '../global_class.dart';
import '../theme.dart';
import 'profile_image_widget.dart';

class DrawerContent extends StatelessWidget {
  const DrawerContent(
      {super.key, this.drawerItems, this.alternativeName, this.alternativeMno});
  final List<DrawerActionModel>? drawerItems;
  final String? alternativeName;
  final String? alternativeMno;
  @override
  Widget build(BuildContext context) {
    return ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: GlobalTheme.primaryGradient2),
                borderRadius: const BorderRadius.only(
                  //bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: const [
                  //background color of box
                  BoxShadow(
                    color: GlobalTheme.borderColor,
                    blurRadius: 15.0, // soften the shadow
                    spreadRadius: 5.0, //extend the shadow
                    offset: Offset(
                      5.0, // Move to right 10  horizontally
                      0.0, // Move to bottom 10 Vertically
                    ),
                  ),
                ]
                //color: GlobalTheme.waiterrPrimaryColor,
                ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      UserDetail.userDetails.name != null &&
                              UserDetail.userDetails.name != ""
                          ? UserDetail.userDetails.name!.split(" ")[0]
                          : alternativeName!,
                      style: GlobalTextStyles.waiterrTextStyleAppBar,
                    ),
                    Text(
                      UserDetail.userDetails.mobileNumber != ""
                          ? UserDetail.userDetails.mobileNumber
                          : alternativeMno!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: GlobalTheme.drawerDetailText,
                      ),
                    )
                  ],
                ),
                const ProfileImageWidget(
                    radius: 30,
                    size: Size(50, 50),
                    isImageUploader: false,
                    scaffoldMessengerKey: null),
              ],
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: drawerItems!.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Icon(drawerItems![index].iconData),
                  title: Text(drawerItems![index].title!,
                      textScaler: const TextScaler.linear(1),
                      style: Theme.of(context).textTheme.bodyMedium),
                  onTap: drawerItems![index].onTap,
                );
              }),
        ]);
  }
}
