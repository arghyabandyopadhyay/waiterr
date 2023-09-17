import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../global_class.dart';

class ProfileImageWidget extends StatelessWidget {
  final double radius;
  final Size size;
  const ProfileImageWidget({Key? key, required this.radius, required this.size})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: CircleAvatar(
          radius: radius,
          backgroundColor: Colors.transparent,
          child: ClipOval(
            child: UserDetail.userDetails.profileUrl != null &&
                    UserDetail.userDetails.profileUrl != ""
                ? CachedNetworkImage(
                    imageUrl: UserDetail.userDetails.profileUrl!,
                    imageBuilder: (context, imageProvider) => Container(
                      height: size.height,
                      width: size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
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
                    height: size.height,
                    width: size.width,
                    fit: BoxFit.fitHeight,
                    image: Image.asset(
                      'assets/img/profile.png',
                    ).image),
          )),
      onTap: () {
        if (kDebugMode) print("profile");
      },
    );
  }
}
