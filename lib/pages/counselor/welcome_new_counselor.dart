// import 'package:counselor/pages/counselor/how_to_counselor.dart';
// import 'package:counselor/widget/button/button.dart';
// import 'package:counselor/widget/safe_area.dart';
// import 'package:counselor/widget/space.dart';
// import 'package:flutter/material.dart';

// import 'package:get/get.dart';

// class WelcomeNewCounselorPage extends StatelessWidget {
//   const WelcomeNewCounselorPage({Key? key}) : super(key: key);

//   String _illutrationImg(int i) {
//     return 'assets/images/kalm_illustration_00$i.png';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SAFE_AREA(
//         context: context,
//         child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 5),
//             child: ListView(
//               children: [
//                 SPACE(height: 40),
//                 Container(
//                   constraints: BoxConstraints(maxWidth: Get.size.width),
//                   child: Text(
//                     "Selamat Datang\nKalmselor!".toUpperCase(),
//                     textAlign: TextAlign.center,
//                     // style: TEXTSTYLE(fontSize: 25, fontWeight: FontWeight.w900, colors: BLUEKALM),
//                   ),
//                 ),
//                 SPACE(height: 30),
//                 GridView(
//                   physics: const NeverScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisSpacing: 10,
//                     mainAxisSpacing: 10,
//                     crossAxisCount: 2,
//                     childAspectRatio: 1.4,
//                   ),
//                   children: List.generate(4, (i) {
//                     return Image.asset(_illutrationImg(i));
//                   }),
//                 ),
//                 SPACE(height: 30),
//                 const Text(
//                   "Kami sangat senang Anda dapat bergabung dengan kami.\nSemoga platform KALM dapat memberikan keuntungan\nbagi Anda dan para Klien.",
//                   // style: TEXTSTYLE(fontSize: 14),
//                   textAlign: TextAlign.center,
//                 ),
//                 SPACE(height: 30),
//                 CustomButton(
//                     heigth: 40,
//                     title: "Selanjutnya",
//                     padHorizontal: 50,
//                     onPressed: () {
//                       Get.offAll(() => HowToCounselorPage());
//                     })
//               ],
//             )));
//   }
// }
