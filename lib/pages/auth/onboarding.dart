import 'package:carousel_slider/carousel_slider.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/pages/auth/intro.dart';
import 'package:counselor/widget/persistent_tab/persistent_tab_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:counselor/api/api.dart';
import 'package:counselor/color/colors.dart';
import 'package:counselor/model/onboarding_res_model/onboarding_res_model.dart';
import 'package:counselor/widget/image_cache.dart';
import 'package:counselor/widget/loading.dart';
import 'package:counselor/widget/safe_area.dart';
import 'package:counselor/widget/space.dart';
import 'package:counselor/widget/text.dart';

class OnBoardingPage extends StatelessWidget {
  final _controller = Get.put(OnboardingController());

  OnBoardingPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardingController>(
      initState: (st) async {
        await _controller.getFlashData();
      },
      builder: (_) {
        return NON_MAIN_SAFE_AREA(
          bottomPadding: 0,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(_.wave())),
              CarouselSlider(
                  items: _.onboardingResModel?.data?.map((e) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: ListView(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IMAGE_CACHE(IMAGE_URL + 'flash-pages/' + e.file!,
                                  height: 250, width: 300),
                              SPACE(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TEXT(e.name,
                                      style: COSTUM_TEXT_STYLE(
                                          fontWeight: FontWeight.w800,
                                          fonstSize: 25,
                                          color: BLUEKALM)),
                                  SPACE(),
                                  TEXT(e.description),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    onPageChanged: (i, r) => _.onChangeIndex(i),
                    height: Get.height / 1.5,
                    viewportFraction: 0.99,
                    enableInfiniteScroll: false,
                  )),
              Positioned(
                bottom: 50,
                child: SizedBox(
                  width: Get.width,
                  child: Column(
                    children: [
                      InkWell(
                        // onTap: () => Get.to(IntroPage()),
                        onTap: () =>
                            pushNewScreen(context, screen: IntroPage()),
                        child: TEXT(_.skipNext(),
                            style: COSTUM_TEXT_STYLE(
                                fontWeight: FontWeight.bold,
                                color: ORANGEKALM)),
                      ),
                      SPACE(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: List.generate(
                            _.onboardingResModel?.data?.length ?? 0, (i) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: Container(
                              width: 30,
                              height: 8,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: _.indexFlash == i
                                      ? ORANGEKALM
                                      : Colors.grey),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class OnboardingController extends GetxController {
  OnboardingResModel? onboardingResModel;
  int indexFlash = 0;
  String skipNext() {
    try {
      return indexFlash == (onboardingResModel!.data!.length - 1)
          ? "Mulai"
          : "Skip";
    } catch (e) {
      return "";
    }
  }

  void onChangeIndex(int i) {
    indexFlash = i;
    update();
    // print("${indexFlash == (onboardingResModel!.data!.length - 1)}");
  }

  Future<void> getFlashData() async {
    var _res = await Api().GET(FLASHPAGE);
    if (_res?.statusCode == 200) {
      onboardingResModel = OnboardingResModel.fromJson(_res?.data);
      Loading.hide();
      update();
    } else {
      Loading.hide();
      return;
    }
  }

  String wave() {
    switch (indexFlash) {
      case 0:
        return 'assets/wave/wave1.png';
      case 1:
        return 'assets/wave/wave2.png';
      case 2:
        return 'assets/wave/wave3.png';
      case 3:
        return 'assets/wave/wave4.png';
      default:
        return 'assets/wave/wave1.png';
    }
  }
}
