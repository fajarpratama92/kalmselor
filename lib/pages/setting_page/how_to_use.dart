// import 'dart:developer';

// import 'package:counselor/pages/auth/how_to_use_auth.dart';
// import 'package:counselor/pages/auth/sop_confirm.dart';
// import 'package:counselor/widget/button.dart';
// import 'package:counselor/widget/persistent_tab/persistent_tab_util.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:counselor/controller/global/user_controller.dart';
// import 'package:counselor/utilities/html_style.dart';
// import 'package:counselor/widget/safe_area.dart';
// import 'package:counselor/widget/space.dart';
// import 'package:counselor/widget/text.dart';

// class HowToUsePage extends StatelessWidget {
//   final _controller = Get.put(HowToUseController());

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<HowToUseController>(
//       builder: (_) {
//         return SAFE_AREA(
//           context: context,
//           child: ListView(
//             children: [
//               Column(
//                 children: [
//                   SPACE(),
//                   TEXT(PRO.howToResModel?.howToData?.name,
//                       style: Get.textTheme.headline2),
//                   SPACE(),
//                   Stack(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 10),
//                         child: HTML_VIEW(
//                             PRO.howToResModel?.howToData?.description,
//                             wordSpace: 0),
//                       ),
//                       Positioned(
//                         width: Get.width,
//                         bottom: 0,
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: Get.width / 8, vertical: 10),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               BUTTON("Buka KARS",
//                                   onPressed: () async =>
//                                       await HowToUseAuthController()
//                                           .openKars()),
//                               Visibility(
//                                 visible:
//                                     PRO.userData?.status == 1 ? false : true,
//                                 child: BUTTON(
//                                   "Selanjutnya",
//                                   onPressed: () async {
//                                     // Get.to(SopConfirmPage());
//                                     pushNewScreen(context,
//                                         screen: SopConfirmPage());
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SPACE(height: 20),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// class HowToUseController extends GetxController {}
