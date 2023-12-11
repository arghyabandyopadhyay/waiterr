import 'package:waiterr/Model/drawer_action_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../global_class.dart';
import '../theme.dart';

class EndDrawerContent extends StatelessWidget {
  const EndDrawerContent(
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
                  bottomLeft: Radius.circular(30),
                ),
                boxShadow: const [
                  //background color of box
                  GlobalTheme.boxShadow,
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
                      UserClientAllocationData.clientName != null &&
                              UserClientAllocationData.clientName != ""
                          ? UserClientAllocationData.clientName!.split(" ")[0]
                          : alternativeName!,
                      style: const TextStyle(
                        fontSize: 26,
                        color: GlobalTheme.drawerDetailText,
                      ),
                    ),
                    Text(
                      UserClientAllocationData.dataExchangeVia != null &&
                              UserClientAllocationData.dataExchangeVia != ""
                          ? UserClientAllocationData.dataExchangeVia!
                          : alternativeMno!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: GlobalTheme.drawerDetailText,
                      ),
                    )
                  ],
                ),
                CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.transparent,
                    child: UserClientAllocationData.logoURL != null &&
                            UserClientAllocationData.logoURL != ""
                        ? CachedNetworkImage(
                            imageUrl: UserClientAllocationData.logoURL!,
                            imageBuilder: (context, imageProvider) => Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.contain,
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
                            ).image)),
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
                      textScaler: const TextScaler.linear(1)),
                  onTap: drawerItems![index].onTap,
                );
              }),
        ]);
  }
}
