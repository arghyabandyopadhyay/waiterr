import 'package:waiterr/Model/filter_item_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class SelectionCardResponsive extends StatelessWidget {
  const SelectionCardResponsive({Key? key, this.item, this.active, this.onTap})
      : super(key: key);
  final FilterItemModel? item;
  final bool? active;
  final onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: 70,
          margin: const EdgeInsets.only(top: 2, right: 2),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // ClipOval(
              //   clipBehavior: Clip.antiAliasWithSaveLayer,
              //   child:Container(
              //     height: 60,
              //       width: 60,
              //       child:item.image)),
              CircleAvatar(
                radius: active! ? 35 : 30,
                //Image(height:50,fit: BoxFit.fitHeight,image: Image.asset('assets/img/all_filter_icon.png').image,),
                backgroundColor: Colors.transparent,
                //child: Image(height:50,filterQuality:FilterQuality.high,fit: BoxFit.fitHeight,image: item.image.image,),
                child: item!.image != null && item!.image != ""
                    ? CachedNetworkImage(
                        imageUrl: item!.image!,
                        imageBuilder: (context, imageProvider) => Container(
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
                            Image.asset('assets/img/all_filter_icon.png').image,
                      ),
              ),
              Text(
                item!.stockGroup!,
                textAlign: TextAlign.center,
                maxLines: active! ? 1 : 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.openSans(fontSize: 11),
              ),
            ],
          )),
    );
  }
}
