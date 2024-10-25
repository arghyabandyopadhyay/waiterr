import 'package:waiterr/Model/user_restraunt_allocation_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class VendorCardMini extends StatelessWidget {
  const VendorCardMini({super.key, required this.item, required this.onTap});
  final UserRestrauntAllocationModel item;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Container(
            alignment: Alignment.center,
            width: 100,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            padding: const EdgeInsets.only(left: 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 35,
                  //Image(height:50,fit: BoxFit.fitHeight,image: Image.asset('assets/img/all_filter_icon.png').image,),
                  backgroundColor: Colors.transparent,
                  //child: Image(height:50,filterQuality:FilterQuality.high,fit: BoxFit.fitHeight,image: item.image.image,),
                  child: item.logoURL != null && item.logoURL != ""
                      ? CachedNetworkImage(
                          imageUrl: item.logoURL!,
                          imageBuilder: (context, imageProvider) => Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
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
                                  baseColor: Colors.grey[300]!.withOpacity(0.3),
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
                          fit: BoxFit.fitHeight,
                          image:
                              Image.asset('assets/img/waiter_icon.png').image,
                        ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                    child: Text(
                  item.clientName!,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ))
              ],
            )),
      ),
    );
  }
}
