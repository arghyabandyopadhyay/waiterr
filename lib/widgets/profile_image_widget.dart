import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:waiterr/Modules/api_fetch_module.dart';
import 'package:waiterr/Pages/Restaurant/Management/add_image_page.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../Modules/firebase_storage_module.dart';
import '../Modules/universal_module.dart';
import '../global_class.dart';

firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

class ProfileImageWidget extends StatefulWidget {
  final double radius;
  final Size size;
  final bool isImageUploader;
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  const ProfileImageWidget(
      {Key? key,
      required this.radius,
      required this.size,
      required this.isImageUploader,
      this.scaffoldMessengerKey})
      : super(key: key);
  @override
  State<ProfileImageWidget> createState() => _ProfileImageWidgetState();
}

class _ProfileImageWidgetState extends State<ProfileImageWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: CircleAvatar(
          radius: widget.radius,
          backgroundColor: Colors.transparent,
          child: ClipOval(
            child: UserDetail.userDetails.profileUrl != null &&
                    UserDetail.userDetails.profileUrl != ""
                ? CachedNetworkImage(
                    imageUrl: UserDetail.userDetails.profileUrl!,
                    imageBuilder: (context, imageProvider) => Container(
                      height: widget.size.height,
                      width: widget.size.width,
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
                    height: widget.size.height,
                    width: widget.size.width,
                    fit: BoxFit.fitHeight,
                    image: Image.asset(
                      'assets/img/profile.png',
                    ).image),
          )),
      onTap: () {
        if (widget.isImageUploader) {
          Navigator.of(context).push(CupertinoPageRoute<void>(
            title: "Profile Page",
            builder: (context) => AddImagePage(callback: uploadFile),
          ));
        }
      },
    );
  }

  double progressValue = 0;
  bool isUploading = false;
  Future<void> uploadFile(String filePath) async {
    try {
      progressValue = 0;
      String profileThumbnailDirectory =
          'ProfilePictures/${UserDetail.userDetails.id}';
      setState(() {
        isUploading = true;
      });
      File thumbnailFile = File(filePath);
      firebase_storage.UploadTask task = storage
          .ref(profileThumbnailDirectory)
          .putFile(thumbnailFile, firebase_storage.SettableMetadata());
      task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
        if (mounted) {
          setState(() {
            progressValue = (snapshot.bytesTransferred / snapshot.totalBytes);
          });
        }
      }, onError: (e) {
        // The final snapshot is also available on the task via `.snapshot`,
        // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
        globalShowInSnackBar(
            e.toString(),
            null,
            widget.scaffoldMessengerKey ?? GlobalKey<ScaffoldMessengerState>(),
            null,
            null);
        if (e.code == 'permission-denied') {
          globalShowInSnackBar(
              'User does not have permission to upload to this reference.',
              null,
              widget.scaffoldMessengerKey ??
                  GlobalKey<ScaffoldMessengerState>(),
              null,
              null);
        }
      });
      await task;
      UserDetail.userDetails.profileUrl =
          await downloadURL(profileThumbnailDirectory);
      await putRegistrationDetails(UserDetail.userDetails);
      globalShowInSnackBar(
          "Upload complete!!",
          null,
          widget.scaffoldMessengerKey ?? GlobalKey<ScaffoldMessengerState>(),
          null,
          null);
      if (mounted) {
        setState(() {
          isUploading = false;
        });
      }
    } on firebase_core.FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        globalShowInSnackBar(
            'User does not have permission to upload to this reference.',
            null,
            widget.scaffoldMessengerKey ?? GlobalKey<ScaffoldMessengerState>(),
            null,
            null);
      }
      // ...
    }
  }
}
