import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:counselor/api/api.dart';
import 'package:counselor/color/colors.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/model/user_model/user_data.dart';
import 'package:counselor/model/user_model/user_model.dart';
import 'package:counselor/pages/auth/login.dart';
import 'package:counselor/pages/counselor/approval_mandatory.dart';
import 'package:counselor/widget/avatar-image.dart';
import 'package:counselor/widget/button/button.dart';
import 'package:counselor/widget/dialog.dart';
import 'package:counselor/widget/loading.dart';
import 'package:counselor/widget/persistent_tab/persistent_tab_util.dart';
import 'package:counselor/widget/safe_area.dart';
import 'package:counselor/widget/snack_bar.dart';
import 'package:counselor/widget/space.dart';
import 'package:counselor/widget/waiting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CounselorUploadMandatoryPage extends StatelessWidget {
  final _controller = Get.put(CounselorUploadMandatoryController());

  CounselorUploadMandatoryPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (STATE(context).userData?.status == 1) {
      return _body(context);
    }
    return POP_SCREEN_DIALOG(
      content: "Apakah Anda yakin ingin keluar dari halaman ini?",
      onConfirm: PRO.userData?.status == 1
          ? () => Navigator.canPop(context)
          : () async {
              await PRO.removeTempCode();
              await Get.offAll(() => LoginPage());
            },
      child: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return SAFE_AREA(
      // harusnya 7
      bottomPadding: PRO.userData?.status == 1 ? null : 0,
      context: context,
      canBack: true,
      useNotification: PRO.userData?.status == 1 ? true : false,
      // useLogo: PRO.userData?.status == 1 ? true : false,
      onBackPressed: PRO.userData?.status == 1
          ? null
          : () async {
              await SHOW_DIALOG(
                  "Apakah Anda yakin ingin keluar dari halaman ini?",
                  onAcc: () async {
                await PRO.removeTempCode();
                await Get.offAll(() => LoginPage());
              });
              // await PRO.removeTempCode();
              // await Get.offAll(() => LoginPage());
            },
      // useAppBar: false,
      child: GetBuilder<CounselorUploadMandatoryController>(
        initState: (st) async {
          await _controller.initState();
        },
        builder: (_) {
          return Builder(
            builder: (context) {
              return Builder(
                builder: (context) {
                  if (_.counselorFile.isEmpty) {
                    return CustomWaiting().defaut();
                  } else {
                    final _data = _.counselorFile;
                    final _mandatoryFile = _.counselorFile
                        .where((e) => !e.name!.contains("Optional"))
                        .toList();
                    final _optionalFile = _.counselorFile
                        .where((e) => e.name!.contains("Optional"))
                        .toList();
                    return ListView(
                      children: [
                        SPACE(height: 10),
                        const Align(
                          alignment: Alignment.center,
                          child: Text(
                            "KELENGKAPAN DATA",
                            style: TextStyle(
                                fontSize: 25,
                                color: BLUEKALM,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                        const Divider(thickness: 3),
                        SPACE(height: 20),
                        Column(
                          children: [
                            _gridView(_mandatoryFile, _),
                            SPACE(height: 20),
                            const Text(
                              "KREDENSIAL TAMBAHAN",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: BLUEKALM,
                                  fontWeight: FontWeight.w900),
                            ),
                            SPACE(height: 20),
                            if (_.counselorFile.length > 6)
                              _gridView(_optionalFile, _),
                          ],
                        ),
                        _credentialOptional(context, _, _data)
                      ],
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  double _mainAxisExtentGrid(List<CounselorMandatoryFiles> _data) {
    // if (_data == null) return 130;

    var _optional = _data.map((e) => e.name?.contains("Optional"));
    switch (_optional.contains(true)) {
      case true:
        return 130;
      case false:
        return 130;
      default:
        return 130;
    }
  }

  String _credentialName(String name) {
    if (name.contains("Optional")) {
      return name;
    } else {
      return name;
    }
  }

  GridView _gridView(List<CounselorMandatoryFiles> _data,
      CounselorUploadMandatoryController _) {
    return GridView.builder(
      itemCount: _data.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: _mainAxisExtentGrid(_data),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, i) {
        // print(_data[i].file);
        return Column(
          children: [
            _pickImage(i, _, data: _data, context: context),
            SPACE(height: 5),
            if (_data[i].file == null)
              Text(
                _credentialName("${_data[i].name}"),
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w700),
              )
          ],
        );
      },
    );
  }

  String _submitBtn() {
    if (PRO.userData?.status == 1) {
      return "Perbarui";
    } else {
      return "Selanjutnya";
    }
  }

  Column _credentialOptional(
      BuildContext context,
      CounselorUploadMandatoryController _,
      List<CounselorMandatoryFiles> _data) {
    return Column(
      children: [
        SPACE(height: 20),
        GestureDetector(
          onTap: () => _.addOptionalFile(_data.last.id),
          child: Container(
            decoration:
                const BoxDecoration(shape: BoxShape.circle, color: BLUEKALM),
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Icon(
                  Icons.add_outlined,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        SPACE(height: 20),
        CustomButton(
          title: _submitBtn(),
          onPressed: _.submitValidation() ? () => _.submit(context) : null,
          padHorizontal: 80,
        ),
        SPACE(height: 20),
      ],
    );
  }

  Expanded _pickImage(i, CounselorUploadMandatoryController _,
      {required List<CounselorMandatoryFiles> data,
      required BuildContext context}) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _bottomSheet(_, i, data, context: context),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity:
                  (imgPickbase64(data[i].file) != null || data[i].file != null)
                      ? 0.3
                      : 1,
              child: Avatar2(
                nullImg: "assets/others/null_img.png",
                imgFilePick: imgPickbase64(data[i].file),
                imgUrl: (data[i].file != null)
                    ? (COUNSELOR_IMAGE_URL + data[i].file!)
                    : null,
              ),
            ),
            if (data[i].file != null)
              Text(
                "${data[i].name}\n${(data[i].imgSize != null) ? "${data[i].imgSize}" : ""}",
                style: const TextStyle(fontWeight: FontWeight.w900),
                textAlign: TextAlign.center,
              ),
            Positioned(
              right: 10,
              top: 10,
              child: _statusFileIcon(
                ((data[i].file != null) && data[i].file!.contains("cons"))
                    ? data[i].status!
                    : 666,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _bottomSheet(CounselorUploadMandatoryController _, i,
      List<CounselorMandatoryFiles> data,
      {required BuildContext context}) {
    return Get.bottomSheet(Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(_.wave()), fit: BoxFit.fill),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
                onPressed: () {
                  if (data[i].name!.contains("Optional")) {
                    if (i == 0) {
                      _.openPickImage(6, data[i].id, ImageSource.camera,
                          isOptional: true, context: context);
                    } else {
                      _.openPickImage((i + 6), data[i].id, ImageSource.camera,
                          isOptional: true, context: context);
                    }
                  } else {
                    _.openPickImage(i, data[i].id, ImageSource.camera,
                        context: context);
                  }
                },
                child: Row(
                  children: [
                    const Icon(Icons.camera_alt_outlined, color: BLUEKALM),
                    SPACE(),
                    const Text(
                      "Use Camera",
                      style: TextStyle(
                          fontWeight: FontWeight.w900, color: BLUEKALM),
                    ),
                  ],
                )),
            const Divider(thickness: 2),
            TextButton(
                onPressed: () {
                  if (data[i].name!.contains("Optional")) {
                    if (i == 0) {
                      _.openPickImage(6, data[i].id, ImageSource.gallery,
                          isOptional: true, context: context);
                    } else {
                      _.openPickImage((i + 6), data[i].id, ImageSource.gallery,
                          isOptional: true, context: context);
                    }
                  } else {
                    _.openPickImage(i, data[i].id, ImageSource.gallery,
                        context: context);
                  }
                },
                child: Row(
                  children: [
                    const Icon(Icons.image_outlined, color: BLUEKALM),
                    SPACE(),
                    const Text(
                      "Choose from Gallery",
                      style: TextStyle(
                          fontWeight: FontWeight.w900, color: BLUEKALM),
                    ),
                  ],
                )),
            Builder(builder: (context) {
              if (data[i].name!.contains("Optional") &&
                  (data[i].status != 5 && data[i].status != 1)) {
                return Column(
                  children: [
                    const Divider(thickness: 2),
                    TextButton(
                        onPressed: () {
                          if (i == 0) {
                            _.removeOptionalFile((6));
                          } else {
                            _.removeOptionalFile((i + 6));
                          }
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.delete_forever_sharp,
                                color: BLUEKALM),
                            SPACE(),
                            const Text(
                              "Cancel",
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: BLUEKALM,
                              ),
                            ),
                          ],
                        )),
                  ],
                );
              } else {
                return Container();
              }
            }),
            SPACE(),
          ],
        ),
      ),
    ));
  }

  String? imgPickbase64(String? url) {
    switch ((url != null) && url.contains('cons')) {
      case true:
        return null;
      case false:
        return url;
      default:
        return null;
    }
  }

  Widget _statusFileIcon(int status) {
    switch (status) {
      case 5:
        return const Icon(Icons.access_time_outlined);
      case 1:
        return const Icon(
          Icons.check_outlined,
          color: Colors.green,
        );
      case 0:
        return const Icon(
          Icons.dangerous,
          color: Colors.red,
        );
      default:
        return Container();
    }
  }
}

//controller ---------------------------------------------------------------------------------------
//controller ---------------------------------------------------------------------------------------
//controller ---------------------------------------------------------------------------------------
//controller ---------------------------------------------------------------------------------------
//controller ---------------------------------------------------------------------------------------
//controller ---------------------------------------------------------------------------------------
//controller ---------------------------------------------------------------------------------------
//controller ---------------------------------------------------------------------------------------
//controller ---------------------------------------------------------------------------------------
//controller ---------------------------------------------------------------------------------------
//controller ---------------------------------------------------------------------------------------
//controller ---------------------------------------------------------------------------------------

String base64Img(_imgByte) =>
    ('data:image/jpeg;base64,' + base64Encode(_imgByte));
String base64Image(String _imgByte) => ('data:image/jpeg;base64,' +
    base64Encode(File(_imgByte).readAsBytesSync()));

class CounselorUploadMandatoryController extends GetxController {
  math.Random random = math.Random();
  List<CounselorMandatoryFiles> counselorFile = [];
  String wave() {
    int _ran = random.nextInt(3);
    if (_ran == 0) {
      return "assets/wave/wave.png";
    }
    return "assets/wave/wave$_ran.png";
  }

  bool submitValidation() {
    return counselorFile
            .where((e) => (e.file != null && e.isMandatory == 1))
            .length >=
        6;
  }

  String _fileName(int i) {
    switch (i) {
      case 0:
        return "FOTO PROFIL";
      case 1:
        return "KTP/PASPOR";
      case 2:
        return "IJAZAH S1";
      case 3:
        return "IJAZAH S2";
      case 4:
        return "SKCK/SIP";
      case 5:
        return "NPWP";
      default:
        return "";
    }
  }

  Future<bool> imagePicker(ImageSource imageSource, int i) async {
    try {
      final _picker = ImagePicker();
      final _filePath = await _picker.pickImage(
          source: imageSource, imageQuality: 80,);
      if (_filePath == null) return false;
      counselorFile[i].file = _filePath.path;
      update();
      return true;
    } catch (e) {
      snackBars(message: "$e");
      return false;
    }
  }

  Future imageRotation(String imagePath) async {
    return await FlutterExifRotation.rotateAndSaveImage(path: imagePath);
  }

  Future<void> openPickImage(int i, int? imgId, ImageSource imageSource,
      {bool isOptional = false, required BuildContext context}) async {
    if (await imagePicker(imageSource, i)) {
      Get.back();
      var _path = await uploadImageDialog(
        isOptionalFile: isOptional,
        barrierDismissible: false,
        customBottomWidget: true,
        imgPath: counselorFile[i].file,
        imageSource: imageSource,
        buttonTitle: "Simpan",
        context: context,
      );
      if (_path != null) {
        var _imgPath = await _path[0] as File;
        var _fixImgrotation = await imageRotation(_imgPath.path);
        var _size = (await _path[0].readAsBytesSync()).lengthInBytes;
        final kb = await _size / 1024;
        final mb = await kb / 1024;
        if (mb > 2 || kb > 2000) {
          counselorFile[i].file = null;
          counselorFile[i].id = null;
          counselorFile[i].status = null;
          update();
          snackBars(message: "Ukuran file terlalu besar");
          return;
        } else {
          counselorFile[i].file = await _fixImgrotation.path;
          // counselorFile[i].file = _path[0].path;
          counselorFile[i].id = imgId;
          counselorFile[i].imgSize = ((kb > 1000 || mb > 1)
              ? "${await mb.toStringAsFixed(2)} MB"
              : "${await kb.toStringAsFixed(1)} KB");
          if (isOptional) {
            counselorFile[i].name = "Optional\n${_path[1]}#";
          }
          update();
        }
      } else {
        counselorFile[i].file = null;
        counselorFile[i].id = null;
        counselorFile[i].status = null;
        update();
        return;
      }
    } else {
      print("cancel");
      return;
    }
  }

  Future<void> retrieveLostData() async {
    final LostData response = await ImagePicker().getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      // setState(() {
      //   if (response.type == RetrieveType.video) {
      //     _handleVideo(response.file);
      //   } else {
      //     _handleImage(response.file);
      //   }
      // });
    } else {
      // _handleError(response.exception);
    }
  }

  CredentialPayload _patchpayload() {
    return CredentialPayload(
        id: counselorFile
            .where((w) =>
                w.status != null &&
                w.id != null &&
                (w.file != null && !w.file!.contains('cons')))
            .map((e) => e.id!)
            .toList(),
        isMandatory: counselorFile
            .where((w) =>
                w.status != null &&
                w.id != null &&
                (w.file != null && !w.file!.contains('cons')))
            .map((e) => e.isMandatory!)
            .toList(),
        names: counselorFile
            .where((w) =>
                w.status != null &&
                w.id != null &&
                (w.file != null && !w.file!.contains('cons')))
            .map((e) => e.name!)
            .toList(),
        documents: counselorFile
            .where((w) =>
                w.status != null && w.file != null && !w.file!.contains('cons'))
            .map((e) => base64Image(e.file!))
            .toList());
  }

  CredentialPayload _patchpayloads() {
    return CredentialPayload(
      documents: counselorFile
          .where((e) => e.status != null && !e.file!.contains('cons'))
          .map((e) => e.file!)
          .toList(),
      isMandatory: counselorFile
          .where((e) => e.status != null && !e.file!.contains('cons'))
          .map((e) => e.isMandatory!)
          .toList(),
      names: counselorFile
          .where((e) => e.status != null && !e.file!.contains('cons'))
          .map((e) => e.name!)
          .toList(),
      id: counselorFile
          .where((w) =>
              w.status != null &&
              w.id != null &&
              (w.file != null && !w.file!.contains('cons')))
          .map((e) => e.id!)
          .toList(),
    );
  }

  CredentialPayload _insertingpayload() {
    return CredentialPayload(
      documents: counselorFile.where((e) => e.id == null).map((e) {
        try {
          return base64Image(e.file!);
        } catch (e) {
          return null;
        }
      }).toList(),
      isMandatory: counselorFile
          .where((e) => e.id == null)
          .map((e) => e.isMandatory!)
          .toList(),
      names:
          counselorFile.where((e) => e.id == null).map((e) => e.name!).toList(),
      id: counselorFile
          .where((w) =>
              w.status != null &&
              w.id != null &&
              (w.file != null && !w.file!.contains('cons')))
          .map((e) => e.id!)
          .toList(),
    );
  }

  CredentialPayload _payload() {
    return CredentialPayload(
        isMandatory: counselorFile.map((e) => e.isMandatory).toList(),
        names: counselorFile.map((e) => e.name).toList(),
        documents: counselorFile.where((e) => e.id == null).map((e) {
          if (e.file == null) {
            return null;
          } else if (e.file!.contains("cons")) {
            return null;
          } else {
            return base64Image(e.file!);
          }
        }).toList(),
        id: []);
  }

  Future<void> submit(context) async {
    if (PRO.userData?.counselorMandatoryFiles != null &&
        PRO.userData?.counselorMandatoryFiles?.isNotEmpty == true) {
      if (_patchpayload().documents!.isEmpty && _payload().documents!.isEmpty) {
        if (PRO.userData?.status == 1) return;
        Get.offAll(() => ApprovalMandatoryPage());
      } else if (_insertingpayload().documents!.isNotEmpty &&
          _patchpayload().id!.isEmpty) {
        print("only insert file");
        if (_insertingpayload().documents!.contains(null)) {
          snackBars(
              message:
                  "Maaf Anda harus mengisi data secara lengkap untuk melanjutkan");
          return;
        }
        var _insertOnly = await _insert(_insertingpayload(), context);
        if (_insertOnly[0]) {
          if (PRO.userData?.status == 1) {
            popScreen(context);
            snackBars(message: "${_insertOnly[1]}");
            Loading.hide();
          } else {
            Get.offAll(() => ApprovalMandatoryPage());
            snackBars(message: "${_insertOnly[1]}");
          }
        } else {
          snackBars(message: "${_insertOnly[1]}");
          Loading.hide();
        }
      } else {
        // print("updating file");
        if (_insertingpayload().documents!.contains(null)) {
          snackBars(
              message:
                  "Maaf Anda harus mengisi data secara lengkap untuk melanjutkan");
          return;
        }
        var _update = await _updatingFile();
        if (_update[0]) {
          print("Success updating");
          if (PRO.userData?.status == 1) {
            popScreen(context);
            snackBars(message: "${_update[1]}");
          } else {
            Get.offAll(() => ApprovalMandatoryPage());
            snackBars(message: "${_update[1]}");
          }
        } else {
          snackBars(message: "${_update[1]}");
          Loading.hide();
        }
      }
    } else {
      // print("upload first time");
      if (_payload().documents!.contains(null)) {
        snackBars(
            message:
                "Maaf Anda harus mengisi data secara lengkap untuk melanjutkan");
        return;
      }
      var _insertings = await _insert(_payload(), context);
      if (_insertings[0]) {
        Get.offAll(() => ApprovalMandatoryPage());
        snackBars(message: "${_insertings[1]}");
      } else {
        snackBars(message: "${_insertings[1]}");
        Loading.hide();
      }
    }
  }

  Future<List<dynamic>> _updatingFile() async {
    print("UPDATING...");
    // Cms().loadingWithProgress(true);
    var _update = await _updating(_patchpayload().toJson());
    if (_update[0]) {
      print("GET STATUS..");
      var _getStatusFile = await getStatus();
      if (_getStatusFile[0]) {
        if (_insertingpayload().documents!.isNotEmpty) {
          print("INSERTING AFTER UPDATING..");
          var _insert = await _inserting(_insertingpayload().toJson());
          if (_insert[0]) {
            print("GET STATUS..");
            var _getStatusFile = await getStatus();
            if (_getStatusFile[0]) {
              // Cms().loadingWithProgress(false);
              // PROGRES_CONTROLLER().resetProgress();
              return [true, _insert[1]];
            } else {
              // Cms().loadingWithProgress(false);
              // PROGRES_CONTROLLER().resetProgress();
              return [false, _insert[1]];
            }
          } else {
            // Cms().loadingWithProgress(false);
            // PROGRES_CONTROLLER().resetProgress();
            snackBars(message: "${_insert[1]}");
            return [false, _insert[1]];
          }
        } else {
          // Cms().loadingWithProgress(false);
          // PROGRES_CONTROLLER().resetProgress();
          return [true, _update[1]];
        }
      } else {
        // Cms().loadingWithProgress(false);
        // PROGRES_CONTROLLER().resetProgress();
        return [false, _update[1]];
      }
    } else {
      // Cms().loadingWithProgress(false);
      // PROGRES_CONTROLLER().resetProgress();
      return [false, _update[1]];
    }
  }

  Future<List<dynamic>> _insert(CredentialPayload payload, BuildContext context) async {
    // Cms().loadingWithProgress(true);
    Loading.show(context: context);
    var _insert = await _inserting(payload.toJson());
    if (_insert[0]) {
      print("GET STATUS..");
      var _getStatusFile = await getStatus();
      if (_getStatusFile[0]) {
        Loading.hide();
        // Cms().loadingWithProgress(false);
        // PROGRES_CONTROLLER().resetProgress();
        return [true, _insert[1]];
      } else {
        Loading.hide();
        // Cms().loadingWithProgress(false);
        return [false, _insert[1]];
      }
    } else {
      Loading.hide();
      // Cms().loadingWithProgress(false);
      // PROGRES_CONTROLLER().resetProgress();
      return [false, _insert[1]];
    }
  }

  Future<List> _inserting(Map<String, dynamic> payload) async {
    WrapResponse? _resData =
        await Api().POST(MANDATORY_FILES, payload, useToken: true,connectTimeout: 400000);
    var _res = UserModel.fromJson(_resData?.data);
    if (_res.status == 201 || _res.status == 200) {
      Loading.hide();
      return [true, "${_res.message}"];
    } else {
      Loading.hide();
      return [false, "${_res.message}"];
    }
  }

  Future<List> _updating(Map<String, dynamic> payload) async {
    WrapResponse? _resData =
        await Api().PATCH(MANDATORY_FILES, payload, useToken: true);
    var _res = UserModel.fromJson(_resData?.data);
    if (_res.status == 201 || _res.status == 200) {
      Loading.hide();

      return [true, "${_res.message}"];
    } else {
      Loading.hide();

      return [false, "${_res.message}"];
    }
  }

  Future<List> getStatus() async {
    var _resData = await Api().GET(APPROVAL_MANDATORY_FILES, useToken: true);
    // User ganti ke UserModel
    UserModel? _res = UserModel.fromJson(_resData?.data);
    if (_res.status == 200) {
      Loading.hide();

      await PRO.setUserSession(data: _res);
      return [true, "${_res.message}"];
    } else {
      Loading.hide();

      return [false, "${_res.message}"];
    }
  }

  void addOptionalFile(int? id) async {
    try {
      var _counOptionalFile =
          counselorFile.where((e) => e.isMandatory == 0).length;

      var _currentLength = (_counOptionalFile + 1);
      if (_currentLength == 10) {
        return;
      }
      // var _optionalName = await Cms().dialogFieldValue();
      counselorFile.add(
          CounselorMandatoryFiles(name: "Optional#", isMandatory: 0, id: null));
      update();
    } catch (e) {
      print(e.toString() + "PAGE UPLOAD MENDATORY 779");
    }
  }

  void removeOptionalFile(int i) {
    counselorFile.removeAt(i);
    update();
    Get.back();
  }

  Future<void> initState() async {
    await PRO.getStatusFileMandatory();
    List<CounselorMandatoryFiles?>? _data =
        PRO.userData?.counselorMandatoryFiles;
    if ((_data != null) && _data.isNotEmpty) {
      print("GET CURRENT DATA");
      counselorFile = List.generate(_data.length,
          (i) => CounselorMandatoryFiles.fromJson(_data[i]!.toJson()));
      update();
    } else {
      print("CURRENT DATA DEFAULT");

      counselorFile = List.generate(6,
          (i) => CounselorMandatoryFiles(name: _fileName(i), isMandatory: 1));
      // print(counselorFile);
      update();
    }
  }
}

class CredentialPayload {
  List<int?>? id;
  List<int?>? isMandatory;
  List<String?>? names;
  List<String?>? documents;

  CredentialPayload({
    required this.id,
    required this.isMandatory,
    required this.names,
    required this.documents,
  });

  factory CredentialPayload.fromJson(Map<String, dynamic> json) {
    // id = json['id'].cast<int>();
    // isMandatory = json['is_mandatory'].cast<int>();
    // names = json['names'].cast<String>();
    // documents = json['documents'].cast<String>();
    return CredentialPayload(
      id: json['id'].cast<int>(),
      isMandatory: json['is_mandatory'].cast<int>(),
      names: json['names'].cast<String>(),
      documents: json['documents'].cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['is_mandatory'] = isMandatory;
    data['names'] = names;
    data['documents'] = documents;
    return data;
  }
}
