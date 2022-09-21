import 'package:waiterr/Model/drawer_action_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../global_class.dart';
import '../theme.dart';

class DrawerContent extends StatelessWidget {
  const DrawerContent(
      {Key? key, this.drawerItems, this.alternativeName, this.alternativeMno})
      : super(key: key);
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
                    color: GlobalTheme.primaryText,
                    blurRadius: 15.0, // soften the shadow
                    spreadRadius: 5.0, //extend the shadow
                    offset: Offset(
                      5.0, // Move to right 10  horizontally
                      0.0, // Move to bottom 10 Vertically
                    ),
                  ),
                ]
                //color: GlobalTheme.primaryColor,
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
                      textScaleFactor: 1,
                      style: const TextStyle(
                        fontSize: 26,
                        color: GlobalTheme.secondaryText,
                      ),
                    ),
                    Text(
                      UserDetail.userDetails.mobileNumber != null &&
                              UserDetail.userDetails.mobileNumber != ""
                          ? UserDetail.userDetails.mobileNumber
                          : alternativeMno!,
                      textScaleFactor: 1,
                      style: const TextStyle(
                        fontSize: 16,
                        color: GlobalTheme.secondaryText,
                      ),
                    )
                  ],
                ),
                CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: UserDetail.userDetails.profileUrl != null &&
                              UserDetail.userDetails.profileUrl != ""
                          ? CachedNetworkImage(
                              imageUrl: UserDetail.userDetails.profileUrl!,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                    //colorFilter:ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => SizedBox(
                                  width: double.infinity,
                                  child: Center(
                                    child: Shimmer.fromColors(
                                      baseColor:
                                          Colors.grey[300]!.withOpacity(0.3),
                                      highlightColor: Colors.white,
                                      enabled: true,
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            )
                          : Image(
                              height: 50,
                              width: 50,
                              fit: BoxFit.fitHeight,
                              image: Image.asset(
                                'assets/img/profile.png',
                              ).image),
                    )),
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
                  title: Text(drawerItems![index].title!, textScaleFactor: 1),
                  onTap: drawerItems![index].onTap,
                );
              }),
        ]);
  }
}
