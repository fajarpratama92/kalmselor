import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:counselor/color/colors.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/model/faq_res_model/faq_data.dart';
import 'package:counselor/widget/box_border.dart';
import 'package:counselor/widget/safe_area.dart';
import 'package:counselor/widget/snack_bar.dart';
import 'package:counselor/widget/space.dart';
import 'package:counselor/widget/text.dart';

class FaqPage extends StatelessWidget {
  final _controller = Get.put(FaqController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<FaqController>(builder: (_) {
      return SAFE_AREA(
          context: context,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    SPACE(),
                    TEXT("FAQ", style: titleApp20),
                    SPACE(),
                    Column(
                      children: List.generate(_.data()?.length ?? 0, (i) {
                        var _data = _.data()![i];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: InkWell(
                                onTap: () => _.onChangeOpen(i),
                                child: BOX_BORDER(
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TEXT(_data.name,
                                          maxLines: 3,
                                          textOverflow: TextOverflow.visible,
                                          style: COSTUM_TEXT_STYLE(
                                              color: _.openController![i]
                                                  ? Colors.white
                                                  : BLUEKALM,
                                              fonstSize: 17,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    fillColor: _.openController![i]
                                        ? BLUEKALM
                                        : Colors.white),
                              ),
                            ),
                            if (_.openController![i])
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                    _data.descriptionChild?.length ?? 0, (j) {
                                  var _dChild = _data.descriptionChild![j];
                                  var strippedHtml = '${_dChild.description}';
                                  strippedHtml.replaceAll("&emsp", "");
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: InkWell(
                                          onTap: () =>
                                              _.onChildChangeOpen(i, j),
                                          child: BOX_BORDER(
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    TEXT(_dChild.name,
                                                        maxLines: 3,
                                                        textOverflow:
                                                            TextOverflow
                                                                .visible,
                                                        style: COSTUM_TEXT_STYLE(
                                                            color:
                                                                _.openChildController![
                                                                        i]![j]
                                                                    ? Colors
                                                                        .white
                                                                    : BLUEKALM,
                                                            fonstSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                ),
                                              ),
                                              fillColor:
                                                  _.openChildController![i]![j]
                                                      ? ORANGEKALM
                                                      : Colors.white),
                                        ),
                                      ),
                                      if (_.openChildController![i]![j])
                                        BOX_BORDER(Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Html(
                                              data: strippedHtml.replaceAll(
                                                  "&emsp;", ""),
                                              shrinkWrap: false,
                                              style: {
                                                "p": Style(
                                                  fontSize: FontSize(16),
                                                  fontFamily: "MavenPro",
                                                  whiteSpace: WhiteSpace.pre,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  margin: Margins.zero,
                                                  padding: EdgeInsets.zero,
                                                  textAlign: TextAlign.left,
                                                  color: TEXTBLUEKALM,
                                                  verticalAlign:
                                                      VerticalAlign.sup,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                "li": Style(
                                                  fontSize: FontSize(10),
                                                  fontFamily: "AlexBrush",
                                                  whiteSpace: WhiteSpace.pre,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  margin: Margins.zero,
                                                  padding: EdgeInsets.zero,
                                                  textAlign: TextAlign.left,
                                                  color: Colors.black,
                                                  verticalAlign:
                                                      VerticalAlign.sup,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                "span": Style(
                                                  fontSize: FontSize(10),
                                                  fontFamily: "MavenPro",
                                                  whiteSpace: WhiteSpace.pre,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  margin: Margins.zero,
                                                  padding: EdgeInsets.zero,
                                                  textAlign: TextAlign.left,
                                                  color: Colors.black,
                                                  verticalAlign:
                                                      VerticalAlign.sup,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                "b": Style(
                                                  fontSize: FontSize(10),
                                                  fontFamily: "MavenPro",
                                                  whiteSpace: WhiteSpace.pre,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  margin: Margins.zero,
                                                  padding: EdgeInsets.zero,
                                                  textAlign: TextAlign.left,
                                                  color: Colors.black,
                                                  verticalAlign:
                                                      VerticalAlign.sup,
                                                  fontWeight: FontWeight.normal,
                                                )
                                              },
                                            )))
                                    ],
                                  );
                                }),
                              )
                          ],
                        );
                      }),
                    )
                  ],
                ),
              )
            ],
          ));
    });
  }
}

class FaqController extends GetxController {
  List<FaqData>? data() {
    return PRO.faqResModel?.faqData;
  }

  late List<bool>? openController;

  void onChangeOpen(int i) {
    try {
      openController![i] = !openController![i];
      update();
    } catch (e) {
      ERROR_SNACK_BAR("Perhatian", "$e");
    }
  }

  late List<List<bool>?>? openChildController;
  void onChildChangeOpen(int i, int j) {
    try {
      openChildController![i]![j] = !openChildController![i]![j];
      update();
    } catch (e) {
      ERROR_SNACK_BAR("Perhatian", "$e");
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    openController = List.generate(data()?.length ?? 0, (i) => false);
    openChildController = List.generate(
        data()?.length ?? 0,
        (i) => List.generate(
            data()?[i].descriptionChild?.length ?? 0, (i) => false));
  }
}
