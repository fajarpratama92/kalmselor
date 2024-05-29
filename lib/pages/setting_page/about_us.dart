import 'dart:developer';

import 'package:counselor/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/model/about_res_model/about_data.dart';
import 'package:counselor/utilities/html_style.dart';
import 'package:counselor/widget/safe_area.dart';
import 'package:counselor/widget/social_share.dart';
import 'package:counselor/widget/text.dart';

class AboutUsPage extends StatelessWidget {
  final _controller = Get.put(AboutUsController());

  AboutUsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AboutUsController>(
      builder: (_) {
        log(_.data()?.description.toString() ?? "");
        return SAFE_AREA(
          context: context,
          child: ListView(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Column(
                  children: [
                    TEXT(_.data()?.name?.toUpperCase(), style: titleApp24),
                    // HTML_VIEW(_.data()?.description),
                    HTML_VIEW(
                        '<p style="text-align: center; font-weight: bold; color: #586B87; font-size: 18;">Our Vision:</p> <p><strong>A world with no more broken people​.</strong></p> <p style="text-align: center; font-weight: bold; color: #586B87; font-size: 18;">Our Mission:</p> <p> <strong >To help people get the help they need, one significant conversation at a time.</strong > </p> <p> KALM adalah platform konseling online berpusat di Indonesia. Kami ingin memberikan tempat yang aman untuk Anda bebas bercerita dan mencari jalan keluar dari masalah apapun yang Anda alami. Kami bertujuan untuk terus menyediakan suatu cara yang privat, praktis, dan terjangkau untuk siapapun mendapatkan akses kepada konselor profesional. </p> <p> Melalui KALM, Anda bisa mendapatkan konseling profesional kapanpun, dimanapun, hanya dengan sentuhan jari Anda. </p> <p>Untuk informasi lebih lanjut, kunjungi User dan Kalmselor</p>',
                        style: MY_HTML_STYLE()),
                    SOCIAL_SHARE()
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class AboutUsController extends GetxController {
  AboutData? data() {
    return PRO.aboutResModel?.aboutData;
  }
}
