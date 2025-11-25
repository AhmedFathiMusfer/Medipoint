import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:diagno_bot/core/widgets/simpleButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ImagePickerWidget extends StatefulWidget {
  final Size size;
  final Color? iconColor;
  final Function(File) onSave;
  final VoidCallback onRemove;
  final String? image;
  final bool isLocale;

  const ImagePickerWidget({
    super.key,
    required this.size,
    required this.onSave,
    required this.onRemove,
    this.image,
    this.iconColor,
    this.isLocale = false,
  });

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  late File _file;
  bool _passFile = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          child: Container(
            padding: const EdgeInsets.all(6),
            height: widget.size.height,
            width: widget.size.width,
            clipBehavior: Clip.none,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: Colors.grey.shade400,
                style: BorderStyle.solid,
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  child:
                      _passFile
                          ? Image.file(
                            _file,
                            width: widget.size.width,
                            height: widget.size.height,
                            fit: BoxFit.cover,
                          )
                          : getCurrentImage(),
                ),
                if ((widget.image == null || widget.image!.isEmpty) &&
                    !_passFile)
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 50.r,
                      height: 50.r,
                      child: SvgPicture.asset(
                        'assets/icons/image_placeholder.svg',
                        height: 350,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return SafeArea(
                  child: Container(
                    height: 170,
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16).copyWith(bottom: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: Colors.grey.shade400,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Select Image Source',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SimpleButton(
                          text: 'Camera',
                          onPressed: () async {
                            await pickImage(ImageSource.camera);
                          },
                        ),
                        const SizedBox(height: 10),
                        SimpleButton(
                          text: 'Gallery',
                          onPressed: () async {
                            await pickImage(ImageSource.gallery);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              useSafeArea: true,
              isScrollControlled: false,
              enableDrag: false,
              isDismissible: true,
            );
          },
        ),
        if (_passFile || (widget.image != null && widget.image!.isNotEmpty))
          Positioned(
            top: -10.r,
            right: -10.r,
            child: InkWell(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.all(8.r),
                width: 40.r,
                height: 40.r,
                child: SvgPicture.asset(
                  'assets/icons/trash.svg',
                  color: Colors.white,
                ),
              ),
              onTap: () {
                setState(() {
                  _passFile = false;

                  // _file = null;
                  // widget.file = null;
                });
                widget.onRemove();
              },
            ),
          ),
      ],
    );
  }

  void _changeFileAppeared(XFile? file) {
    setState(() {
      if (file != null) {
        _file = File(file.path);
        _passFile = true;
      } else {
        _passFile = false;
      }
    });
  }

  Future<Uint8List> compressImage(Uint8List list) async {
    var result = await FlutterImageCompress.compressWithList(list, quality: 50);

    return result;
  }

  File? image;

  Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');
    var file = await File(imagePath).copy(image.path);
    widget.onSave(file);
    return file;
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(
        source: source,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500,
      );
      if (image == null) return;
      _changeFileAppeared(image);
      final imagePermanent = await saveImagePermanently(image.path);
    } on PlatformException catch (e) {
      print('Failed to pick a photo $e');
    }
  }

  Widget getCurrentImage() {
    if (widget.image == null || widget.image!.isEmpty) {
      return const SizedBox();
    } else {
      if (widget.isLocale) {
        return Image(
          image: Image.file(File(widget.image!)).image,
          width: widget.size.width,
          height: widget.size.height,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return widget.image != null && widget.image!.isNotEmpty
                ? Image(
                  image: CachedNetworkImageProvider(widget.image!),
                  width: widget.size.width,
                  height: widget.size.height,
                  fit: BoxFit.cover,
                )
                : const SizedBox();
          },
        );
      } else {
        return Image(
          image: CachedNetworkImageProvider(widget.image!),
          width: widget.size.width,
          height: widget.size.height,
          fit: BoxFit.cover,
        );
      }
    }
  }
}
