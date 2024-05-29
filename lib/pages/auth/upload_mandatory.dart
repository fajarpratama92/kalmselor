// import 'dart:convert';
// import 'dart:io';
// import 'package:counselor/api/api.dart';
// import 'package:counselor/color/colors.dart';
// import 'package:counselor/controller/global/user_controller.dart';
// import 'package:counselor/model/user_model/user_data.dart';
// import 'package:counselor/model/user_model/user_model.dart';
// import 'package:counselor/pages/counselor/approval_mandatory.dart';
// import 'package:counselor/utilities/image_picker.dart';
// import 'package:counselor/widget/box_border.dart';
// import 'package:counselor/widget/button.dart';
// import 'package:counselor/widget/loading.dart';
// import 'package:counselor/widget/persistent_tab/persistent_tab_util.dart';
// import 'package:counselor/widget/safe_area.dart';
// import 'package:counselor/widget/snack_bar.dart';
// import 'package:counselor/widget/space.dart';
// import 'package:counselor/widget/text.dart';
// import 'package:counselor/widget/waiting.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class UploadMandatoryPage extends StatelessWidget {
//   final _controller = Get.put(UploadMandatoryController());

//   UploadMandatoryPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<UploadMandatoryController>(initState: (st) async {
//       await _controller.initFile();
//     }, builder: (_) {
//       return SAFE_AREA(
//           context: context,
//           bottomPadding: 0,
//           useNotification: false,
//           // appBar: PreferredSize(
//           //     child: SizedBox(
//           //       child: Center(
//           //         child: Row(
//           //           children: [
//           //             IconButton(
//           //                 onPressed: () {
//           //                   Navigator.pop(context);
//           //                 },
//           //                 icon: const Icon(Icons.arrow_back_ios_new_outlined))
//           //           ],
//           //         ),
//           //       ),
//           //     ),
//           //     preferredSize: const Size(0, 50)),
//           child: Builder(builder: (context) {
//             if (_.counselorFile == null) {
//               return CustomWaiting().defaut();
//               // return Center(
//               //     child: SizedBox(
//               //         height: 100,
//               //         width: 100,
//               //         child: Loading().LOADING_ICON(context)));
//             } else {
//               return ListView(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 10),
//                     child: Column(
//                       children: [
//                         SPACE(),
//                         _files(
//                             _,
//                             "KELENGKAPAN DATA",
//                             _.counselorFile
//                                 ?.where((e) => e.isMandatory == 1)
//                                 .toList()),
//                         SPACE(height: 20),
//                         Column(
//                           children: [
//                             _files(
//                                 _,
//                                 "KREDENSIAL TAMBAHAN",
//                                 _.counselorFile
//                                     ?.where((e) => e.isMandatory == 0)
//                                     .toList()),
//                             SPACE(),
//                             InkWell(
//                               onTap: () async => await _.addedOptionalFile(),
//                               child: const CircleAvatar(
//                                 backgroundColor: BLUEKALM,
//                                 radius: 60,
//                                 child: Icon(Icons.add,
//                                     color: Colors.white, size: 60),
//                               ),
//                             ),
//                           ],
//                         ),
//                         SPACE(height: 20),
//                         SizedBox(
//                           width: Get.width / 1.5,
//                           child: BUTTON("Selanjutnya",
//                               onPressed: !_.validationFile
//                                   ? null
//                                   : () async =>
//                                       await _.submit(context: context),
//                               verticalPad: 15,
//                               circularRadius: 30),
//                         ),
//                         SPACE(),
//                       ],
//                     ),
//                   ),
//                 ],
//               );
//             }
//           }));
//     });
//   }

//   // @override
//   // Widget build(BuildContext context) {
//   //   return GetBuilder<UploadMandatoryController>(initState: (st) async {
//   //     await _controller.initFile();
//   //   }, builder: (_) {
//   //     return SAFE_AREA(
//   //         context: context,
//   //         // bottomPadding: 0,
//   //         useNotification: false,
//   //         // appBar: PreferredSize(
//   //         //     child: SizedBox(
//   //         //       child: Center(
//   //         //         child: Row(
//   //         //           children: [
//   //         //             IconButton(
//   //         //                 onPressed: () {
//   //         //                   Navigator.pop(context);
//   //         //                 },
//   //         //                 icon: const Icon(Icons.arrow_back_ios_new_outlined))
//   //         //           ],
//   //         //         ),
//   //         //       ),
//   //         //     ),
//   //         //     preferredSize: const Size(0, 50)),
//   //         child: Builder(builder: (context) {
//   //           if (_.counselorFile == null) {
//   //             return Center(
//   //                 child: SizedBox(
//   //                     height: 100,
//   //                     width: 100,
//   //                     child: Loading().LOADING_ICON(context)));
//   //           } else {
//   //             return ListView(
//   //               children: [
//   //                 Padding(
//   //                   padding: const EdgeInsets.symmetric(horizontal: 10),
//   //                   child: Column(
//   //                     children: [
//   //                       SPACE(),
//   //                       _files(
//   //                           _,
//   //                           "KELENGKAPAN DATA",
//   //                           _.counselorFile
//   //                               ?.where((e) => e.isMandatory == 1)
//   //                               .toList()),
//   //                       SPACE(height: 20),
//   //                       Column(
//   //                         children: [
//   //                           _files(
//   //                               _,
//   //                               "KREDENSIAL TAMBAHAN",
//   //                               _.counselorFile
//   //                                   ?.where((e) => e.isMandatory == 0)
//   //                                   .toList()),
//   //                           SPACE(),
//   //                           InkWell(
//   //                             onTap: () async => await _.addedOptionalFile(),
//   //                             child: const CircleAvatar(
//   //                               backgroundColor: BLUEKALM,
//   //                               radius: 60,
//   //                               child: Icon(Icons.add,
//   //                                   color: Colors.white, size: 60),
//   //                             ),
//   //                           ),
//   //                         ],
//   //                       ),
//   //                       SPACE(height: 20),
//   //                       SizedBox(
//   //                         width: Get.width / 1.5,
//   //                         child: BUTTON("Selanjutnya",
//   //                             onPressed: !_.validationFile
//   //                                 ? null
//   //                                 : () async =>
//   //                                     await _.submit(context: context),
//   //                             verticalPad: 15,
//   //                             circularRadius: 30),
//   //                       ),
//   //                       SPACE(),
//   //                     ],
//   //                   ),
//   //                 ),
//   //               ],
//   //             );
//   //           }
//   //         }));
//   //   });
//   // }

//   Column _files(
//     UploadMandatoryController _,
//     String title,
//     List<CounselorMandatoryFiles>? counselorFile,
//   ) {
//     return Column(
//       children: [
//         BOX_BORDER(Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Center(child: TEXT(title, style: Get.textTheme.headline2)),
//         )),
//         SPACE(height: 20),
//         GridView(
//           physics: const NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               mainAxisSpacing: 20,
//               crossAxisCount: 2,
//               mainAxisExtent:
//                   (counselorFile != null && counselorFile.isNotEmpty)
//                       ? 150
//                       : 0),
//           children: List.generate(counselorFile?.length ?? 0, (i) {
//             var _data = counselorFile![i];
//             return Column(
//               children: [
//                 InkWell(
//                   onTap: () async {
//                     var _index = _.counselorFile
//                         ?.indexWhere((e) => e.name == _data.name);
//                     await _.pickImage(_index!, _data);
//                   },
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(60),
//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         _localFileImage(_data),
//                         if (_data.status != null) _statusFileIcon(_data.status),
//                         if (_data.imgSize != null)
//                           TEXT("${_data.imgSize} Mb",
//                               style: COSTUM_TEXT_STYLE(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold)),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SPACE(height: 5),
//                 TEXT(_data.name, style: Get.textTheme.headline1)
//               ],
//             );
//           }),
//         )
//       ],
//     );
//   }

//   Container _localFileImage(CounselorMandatoryFiles _data) {
//     return Container(
//       color: BLUEKALM,
//       height: 120,
//       width: 120,
//       child: Builder(builder: (context) {
//         if (_data.file != null) {
//           if (_data.file!.contains("cons")) {
//             return Opacity(
//                 opacity: 0.6,
//                 child: Image.network(_data.file!, fit: BoxFit.fill));
//           } else {
//             return Opacity(
//                 opacity: _data.imgSize != null ? 0.3 : 1,
//                 child: Image.file(File(_data.file!), fit: BoxFit.fill));
//           }
//         } else {
//           return Image.asset('assets/icon/null_img.png',
//               scale: 2.5, color: Colors.white);
//         }
//       }),
//     );
//   }

//   Widget _statusFileIcon(int? status) {
//     try {
//       switch (status) {
//         case 5:
//           return const Icon(
//             Icons.access_time_outlined,
//             color: Colors.white,
//           );
//         case 1:
//           return const Icon(
//             Icons.check_circle_outline_outlined,
//             color: Colors.white,
//           );
//         case 0:
//           return const Icon(
//             Icons.dangerous,
//             color: Colors.white,
//           );
//         default:
//           return Container();
//       }
//     } catch (e) {
//       return Container();
//     }
//   }
// }

// class UploadMandatoryController extends GetxController {
//   List<CounselorMandatoryFiles>? counselorFile;

//   Future<void> addedOptionalFile() async {
//     var _name = await _optionalFileNamed();
//     if (_name == null) {
//       return;
//     }
//     counselorFile!.add(CounselorMandatoryFiles(name: _name, isMandatory: 0));
//     update();
//   }

//   Future<String?> _optionalFileNamed() async {
//     TextEditingController _opName = TextEditingController();
//     await Get.dialog(
//       BOX_BORDER(
//         Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               BOX_BORDER(
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Material(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           TEXT("Nama Kredensial wajib diisi*",
//                               style: COSTUM_TEXT_STYLE(
//                                   color: Colors.red,
//                                   fontStyle: FontStyle.italic)),
//                           SPACE(),
//                           SizedBox(
//                             height: 40,
//                             child: CupertinoTextField(
//                                 textCapitalization:
//                                     TextCapitalization.characters,
//                                 controller: _opName,
//                                 placeholder: "Nama Kredensial Tambahan"),
//                           ),
//                           SPACE(),
//                           SizedBox(
//                             width: Get.width / 2,
//                             // height: Get.height /1,
//                             child: BUTTON("Selesai", onPressed: () async {
//                               Get.back();
//                             }),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   height: Get.height / 5,
//                   width: Get.width / 1.5,
//                   fillColor: Colors.white),
//             ],
//           ),
//         ),
//       ),
//     );
//     return _opName.text.isEmpty ? null : _opName.text;
//   }

//   void removeOptionalFile(String? name) {
//     counselorFile?.removeWhere((e) => e.name == name);
//     update();
//   }

//   CredentialPayload? get payload {
//     return CredentialPayload(
//         id: null,
//         documents: counselorFile?.where((e) {
//           return e.id == null;
//         }).map((e) {
//           return base64Image(e.file);
//         }).toList(),
//         names: counselorFile?.where((e) {
//           return e.id == null;
//         }).map((e) {
//           return e.name;
//         }).toList(),
//         isMandatory: counselorFile?.where((e) {
//           return e.id == null;
//         }).map((e) {
//           return e.isMandatory;
//         }).toList());
//   }

//   CredentialPayload? get patchPayload {
//     var _data = counselorFile?.where((e) {
//       return !e.file!.contains("cons") && e.id != null;
//     }).toList();
//     return CredentialPayload(
//         id: _data?.where((e) => e.id != null).map((e) => e.id).toList(),
//         documents: _data?.map((e) {
//           return base64Image(e.file);
//         }).toList(),
//         names: _data?.where((e) => e.id != null).map((e) => e.name).toList(),
//         isMandatory: _data
//             ?.where((e) => e.id != null)
//             .map((e) => e.isMandatory)
//             .toList());
//   }

//   void updatePayload(int i, CounselorMandatoryFiles data) {
//     counselorFile![i] = data;
//     update();
//   }

//   String fileName(int i) {
//     switch (i) {
//       case 0:
//         return "FOTO PROFIL";
//       case 1:
//         return "KTP/PASPOR";
//       case 2:
//         return "IJAZAH S1";
//       case 3:
//         return "IJAZAH S2";
//       case 4:
//         return "SKCK/SIP";
//       case 5:
//         return "NPWP";
//       default:
//         return "";
//     }
//   }

//   String? base64Image(String? _imgByte) {
//     try {
//       return ('data:image/jpeg;base64,' +
//           base64Encode(File(_imgByte!).readAsBytesSync()));
//     } catch (e) {
//       return null;
//     }
//   }

//   bool get validationFile {
//     try {
//       return !payload!.documents!.contains(null);
//     } catch (e) {
//       return false;
//     }
//   }

//   Future<void> submit({required BuildContext context}) async {
//     // print(patchPayload?.isMandatory);
//     // print(patchPayload?.id);
//     // print(payload?.isMandatory);
//     // return;
//     var _nullMandatory = counselorFile!
//             .where((e) => e.isMandatory == 1)
//             .where((e) => e.file == null)
//             .length >
//         1;
//     if (_nullMandatory) {
//       ERROR_SNACK_BAR(
//           "Perhatian", "Pastikan Anda melengkapi Data terlebih dahulu");
//       return;
//     } else {
//       if (payload!.documents!.isNotEmpty) {
//         await _inserting();
//         if (patchPayload!.documents!.isNotEmpty) {
//           await _patching();
//         }
//       } else if (patchPayload!.documents!.isNotEmpty) {
//         await _patching();
//       } else {
//         // Get.to(ApprovalMandatoryPage());
//         pushNewScreen(context, screen: ApprovalMandatoryPage());
//         return;
//       }
//       await getStatus();
//       // Get.to(ApprovalMandatoryPage());
//       pushNewScreen(context, screen: ApprovalMandatoryPage());
//     }
//   }

//   Future<void> _patching() async {
//     print("PATCH");
//     var _res = await Api().PATCH(MANDATORY_FILES, patchPayload?.toJson(),
//         useToken: true, connectTimeout: 200000);
//     if (_res?.statusCode == 201) {
//       await PRO.saveLocalUser(UserModel.fromJson(_res?.data).data);
//     } else {
//       Loading.hide();
//       return;
//     }
//   }

//   Future<void> _inserting() async {
//     print("UPLOAD");
//     var _res = await Api().POST(MANDATORY_FILES, payload?.toJson(),
//         useToken: true, connectTimeout: 200000);
//     if (_res?.statusCode == 201) {
//       await PRO.saveLocalUser(UserModel.fromJson(_res?.data).data);
//     } else {
//       Loading.hide();
//       return;
//     }
//   }

//   Future<void> getStatus() async {
//     var _approval = await Api()
//         .GET(APPROVAL_MANDATORY_FILES, useToken: true, useLoading: false);
//     // PR(_approval?.data);
//     if (_approval?.statusCode == 200) {
//       await PRO.saveLocalUser(UserModel.fromJson(_approval?.data).data);
//       Loading.hide();
//     } else {
//       Loading.hide();
//     }
//   }

//   Future<void> pickImage(int i, CounselorMandatoryFiles _data) async {
//     var _x = await IMAGE_PICKER(
//         anotherOption: (_data.isMandatory != 0 || _data.id != null)
//             ? null
//             : _romoveOptionalOption(_data.name));
//     var _size = await IMAGE_SIZE(_x);
//     if (_x == null) {
//       return;
//     } else {
//       if (await previewImage(_x.path, i, _data)) {
//         updatePayload(
//             i,
//             CounselorMandatoryFiles(
//                 file: _x.path,
//                 name: _data.name,
//                 imgSize: _size.toString(),
//                 isMandatory: _data.isMandatory,
//                 id: _data.id));
//       } else {
//         return;
//       }
//     }
//   }

//   Widget _romoveOptionalOption(String? name) {
//     return InkWell(
//       onTap: () {
//         removeOptionalFile(name);
//         Get.back();
//       },
//       child: Row(
//         children: [
//           const Icon(Icons.delete_forever, size: 50, color: BLUEKALM),
//           SPACE(),
//           TEXT("Remove", style: Get.textTheme.headline1),
//         ],
//       ),
//     );
//   }

//   Future<bool> previewImage(
//       String imgPath, int i, CounselorMandatoryFiles _data) async {
//     bool _okay = false;
//     await Get.dialog(Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           BOX_BORDER(
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   children: [
//                     Expanded(
//                         child: Image.file(
//                       File(imgPath),
//                       fit: BoxFit.cover,
//                     )),
//                     BUTTON("Simpan", onPressed: () {
//                       _okay = true;
//                       Get.back();
//                     }),
//                     BUTTON("Ulangi Pengambilan Foto", onPressed: () async {
//                       Get.back();
//                       await pickImage(i, _data);
//                     })
//                   ],
//                 ),
//               ),
//               height: Get.height / 2.5,
//               width: Get.width / 1.2,
//               fillColor: Colors.white),
//         ],
//       ),
//     ));
//     return _okay;
//   }

//   Future<void> initFile() async {
//     if (PRO.userData?.counselorMandatoryFiles != null) {
//       await getStatus();
//       counselorFile = List.generate(
//           PRO.userData?.counselorMandatoryFiles?.length ?? 0, (i) {
//         var _data = PRO.userData!.counselorMandatoryFiles![i]!;
//         return CounselorMandatoryFiles(
//             id: _data.id,
//             name: _data.name,
//             isMandatory: _data.isMandatory,
//             status: _data.status,
//             file: (COUNSELOR_IMAGE_URL + _data.file!));
//       });
//     } else {
//       counselorFile = List.generate(6, (i) {
//         return CounselorMandatoryFiles(name: fileName(i), isMandatory: 1);
//       });
//     }
//     update();
//   }
// }
