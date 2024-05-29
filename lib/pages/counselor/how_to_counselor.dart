// import 'package:counselor/api/api.dart';
// import 'package:counselor/model/how_to_res_model/how_to_res_model.dart';
// import 'package:counselor/pages/auth/sop_confirm.dart';
// import 'package:counselor/widget/button/button.dart';
// import 'package:counselor/widget/safe_area.dart';
// import 'package:counselor/widget/snack_bar.dart';
// import 'package:counselor/widget/space.dart';
// import 'package:counselor/widget/waiting.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:get/get.dart';
// import 'package:url_launcher/url_launcher.dart';

// class HowToCounselorPage extends StatelessWidget {
//   final _controller = Get.put(HowToCounselorController());

//   HowToCounselorPage({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return SAFE_AREA(
//       context: context,
//       child: GetBuilder<HowToCounselorController>(
//         initState: (state) async {
//           await _controller.getHowTo();
//         },
//         builder: (_) {
//           return Builder(
//             builder: (context) {
//               if (_.howtoResModel == null) {
//                 return Center(
//                   child: CustomWaiting().defaut(),
//                 );
//               } else {
//                 return ListView(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       child: Column(
//                         children: [
//                           SPACE(height: 10),
//                           Align(
//                             alignment: Alignment.center,
//                             child: Text(
//                               _.howtoResModel?.howToData?.name?.toUpperCase() ??
//                                   "",
//                               // style: TEXTSTYLE(
//                               //     fontWeight: FontWeight.w900, fontSize: 30, colors: BLUEKALM),
//                             ),
//                           ),
//                           SPACE(height: 10),
//                           Html(
//                             data: _.howtoResModel?.howToData?.description ?? "",
//                             // defaultTextStyle: TEXTSTYLE(),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SPACE(height: 20),
//                     CustomButton(
//                       heigth: 40,
//                       padHorizontal: 50,
//                       onPressed: () async {
//                         if (await canLaunch(KARS)) {
//                           launch(KARS);
//                         } else {
//                           snackBars(message: "can't open $KARS");
//                         }
//                       },
//                       title: "Buka KARS",
//                     ),
//                     CustomButton(
//                       heigth: 40,
//                       padHorizontal: 50,
//                       onPressed: () {
//                         Get.offAll(() => SopConfirmPage());
//                       },
//                       title: "Selanjutnya",
//                     ),
//                     SPACE(height: 20),
//                   ],
//                 );
//               }
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class HowToCounselorController extends GetxController {
//   HowToResModel? howtoResModel;
//   Future<void> getHowTo() async {
//     WrapResponse? _resData = await Api().GET(HOW_TO);
//     var _res = HowToResModel.fromJson(_resData?.data);
//     if (_res.status == 200) {
//       howtoResModel = _res;
//       update();
//     } else {
//       snackBars(message: "${_res.message}");
//     }
//   }

//   @override
//   void onInit() {
//     super.onInit();
//   }
// }
