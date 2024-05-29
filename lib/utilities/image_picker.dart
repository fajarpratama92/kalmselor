import 'package:counselor/color/colors.dart';
import 'package:counselor/widget/snack_bar.dart';
import 'package:counselor/widget/space.dart';
import 'package:counselor/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

Future<XFile?> IMAGE_PICKER({
  Widget? anotherOption,
}) async {
  XFile? _x;
  await Get.bottomSheet(Container(
    height: Get.height / 4.5,
    decoration: BoxDecoration(
      image: const DecorationImage(
          image: AssetImage('assets/wave/wave.png'), fit: BoxFit.fitWidth),
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: InkWell(
              onTap: () async {
                _x = await _PICK_IMAGE(imageSource: ImageSource.gallery);
                double? _imageSize = await IMAGE_SIZE(_x);
                Get.back();
                if (_imageSize != null && _imageSize > 2) {
                  ERROR_SNACK_BAR("Perhatian", "File Maksimal 2Mb");
                  _x = null;
                }
              },
              child: Row(
                children: [
                  const Icon(Icons.photo_outlined, size: 50, color: BLUEKALM),
                  SPACE(),
                  TEXT("Gallery", style: titleApp20),
                ],
              ),
            ),
          ),
          const Divider(thickness: 1),
          Expanded(
            child: InkWell(
              onTap: () async {
                _x = await _PICK_IMAGE(imageSource: ImageSource.camera);
                double? _imageSize = await IMAGE_SIZE(_x);
                Get.back();
                if (_imageSize != null && _imageSize > 2) {
                  ERROR_SNACK_BAR("Perhatian", "File Maksimal 2Mb");
                  _x = null;
                }
              },
              child: Row(
                children: [
                  const Icon(Icons.camera_alt, size: 50, color: BLUEKALM),
                  SPACE(),
                  TEXT("Camera", style: titleApp20),
                ],
              ),
            ),
          ),
          const Divider(thickness: 1),
          if (anotherOption != null) anotherOption
        ],
      ),
    ),
  ));
  return _x;
}

Future<double?> IMAGE_SIZE(XFile? _x) async {
  try {
    var _imageByte = await _x?.readAsBytes();
    var _imageSize = (_imageByte!.lengthInBytes / 1024) / 1024;
    return _imageSize;
  } catch (e) {
    return null;
  }
}

Future<XFile?> _PICK_IMAGE({ImageSource? imageSource}) async {
  try {
    var _picker = ImagePicker();
    var _picked = await _picker.pickImage(
        source: imageSource ?? ImageSource.gallery, imageQuality: 10);
    return _picked;
  } catch (e) {
    ERROR_SNACK_BAR("Perhatian", "$e");
    return null;
  }
}

class ImagePickModel {
  XFile? xFile;
  double? imageSize;
  ImagePickModel({this.xFile, this.imageSize});

  ImagePickModel.fromJson(Map<String, dynamic> json) {
    xFile = json['xFile'];
    imageSize = json['imageSize'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = xFile;
    data['imageSize'] = imageSize;
    return data;
  }
}
