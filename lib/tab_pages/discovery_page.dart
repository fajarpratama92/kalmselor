import 'dart:async';

import 'package:counselor/api/api.dart';
import 'package:counselor/color/colors.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/model/directory_res_model/item.dart';
import 'package:counselor/pages/detail_article.dart';
import 'package:counselor/pages/web_view.dart';
import 'package:counselor/widget/button.dart';
import 'package:counselor/widget/image_cache.dart';
import 'package:counselor/widget/loading.dart';
import 'package:counselor/widget/persistent_tab/persistent_tab_util.dart';
import 'package:counselor/widget/safe_area.dart';
import 'package:counselor/widget/space.dart';
import 'package:counselor/widget/text.dart';
import 'package:counselor/widget/widget_carousel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../model/article_res_model/article_data.dart';
import '../widget/snack_bar.dart';

class DiscoveryPage extends StatelessWidget {
  final _controllerDiscovery = Get.put(DiscoveryController());

  DiscoveryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DiscoveryController>(initState: (s) async {
      await PRO.getVideos();
      await PRO.getDirectoryArticles();
      await PRO.getDirectoryPlace();
      Loading.hide();
    }, builder: (_) {
      return SAFE_AREA(
          context: context,
          canBack: false,
          child: Builder(builder: (context) {
            return Scrollbar(
              child: ListView(
                controller: _controllerDiscovery.scrollController,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              BUTTON("Discovery",
                                  isExpanded: true,
                                  onPressed: () => _.onChangeTab(0),
                                  backgroundColor: _.selectedTab == 0
                                      ? ORANGEKALM
                                      : Colors.grey),
                              SPACE(),
                              BUTTON("Directory",
                                  isExpanded: true,
                                  onPressed: () => _.onChangeTab(1),
                                  backgroundColor: _.selectedTab == 1
                                      ? ORANGEKALM
                                      : Colors.grey),
                            ],
                          ),
                        ),
                        SPACE(height: 20),
                        if (_.selectedTab == 0) _discovery(_, context),
                        if (_.selectedTab == 1)
                          if (STATE(context).directoryResModel?.directoryData !=
                              null)
                            _directory(context)
                          else
                            Container()
                      ],
                    ),
                  ),
                ],
              ),
            );
          }));
    });
  }

  Widget _discovery(DiscoveryController _, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TEXT("Video", style: titleApp24BOLD,),
          ),
          SPACE(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: VIDEO_CAROUSEL(context, _),
          ),
          SPACE(height: 20),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TEXT("Artikel", style: titleApp24BOLD),
                    IconButton(
                        onPressed: () => _.onChangeArticleView(),
                        icon: Icon(
                            (_.isArticleGrid
                                ? Icons.map_rounded
                                : Icons.grid_on_outlined),
                            color: ORANGEKALM))
                  ],
                ),
              ),
            ],
          ),
          if (!_.isArticleGrid)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ARTICLE_CAROUSEL2(
                  context, STATE(context).articleDirectoryResModel,
                  setLength: 5),
            ),
          if (_.isArticleGrid) _articleGridView(context),
        ],
      ),
    );
  }

  Padding _articleGridView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1.5,
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 5),
        // children: STATE(context).articleDirectoryResModel!.data!.map((e) {
        itemCount: _controllerDiscovery.lengthArticleGrid,
        itemBuilder: (BuildContext context, i) {
          ArticleData? e = STATE(context).articleDirectoryResModel?.data?[i];
          if (e == null) return Container();

          return IMAGE_CACHE(IMAGE_URL + ARTICLE + (e.file ?? ""),
              onTapImage: () {
            pushNewScreen(context, screen: DetailArticlePage(articleData: e));
          },
              widgetInsideImage: Positioned(
                  bottom: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 0)),
                      height: 40,
                      width: Get.width / 2.2,
                      margin: const EdgeInsets.all(0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                            height: 40,
                            width: Get.width / 3,
                            child: TEXT(e.name,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                textOverflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 10))),
                      ),
                    ),
                  )));
        },
      ),
    );
  }

  Padding _directory(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: STATE(context).directoryResModel!.directoryData!.map((e) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SPACE(),
              Center(
                  child: TEXT(e.title,
                      style: titleApp24, textAlign: TextAlign.center)),
              SPACE(),
              Column(
                children: List.generate(e.dataItem!.length, (i) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      SPACE(),
                      TEXT(e.dataItem![i].title,
                          style: titleApp20, textAlign: TextAlign.center),
                      Column(
                        children: e.dataItem![i].item!.map((f) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SPACE(),
                              Container(
                                width: Get.width,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                      Border.all(width: 0.5, color: BLUEKALM),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SPACE(),
                                    TEXT(f.name, style: titleApp16),
                                    const Divider(),
                                    if (f.address != "")
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                  color: BLUEKALM,
                                                  border: Border.all(
                                                      width: 0.5,
                                                      color: BLUEKALM),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: const Icon(
                                                  Icons.location_city_outlined,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SPACE(width: 10),
                                              SizedBox(
                                                  width: Get.width / 1.3,
                                                  child: TEXT(f.address)),
                                            ],
                                          ),
                                          SPACE(),
                                        ],
                                      ),
                                    if (f.phone != "" && f.phone != null)
                                      _launchPhone1(f),
                                    if (f.phone2 != "" && f.phone2 != null)
                                      _launchPhone2(f),
                                    if (f.email != "" && f.email != null)
                                      _launchEmail(f),
                                    if (f.url != "" && f.url != null)
                                      _launchUrl(f, context),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                      SPACE(),
                    ],
                  );
                }),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  InkWell _launchUrl(Item f, BuildContext context) {
    return InkWell(
        onTap: () async {
          try {
            Get.to(() => WebViewPage(url: f.url!));
          } catch (e) {
            ERROR_SNACK_BAR("Perhatian", "Tidak dapat membuka link");
            return;
          }
        },
        child: Column(
          children: [
            Row(
              children: [
                Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: BLUEKALM,
                      border: Border.all(width: 0.5, color: BLUEKALM),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.link,
                      color: Colors.white,
                    )),
                SPACE(width: 10),
                Flexible(
                    child: TEXT(f.url,
                        style: URL_STYLE(),
                        textOverflow: TextOverflow.visible)),
              ],
            ),
            SPACE(height: 5),
          ],
        ));
  }

  InkWell _launchEmail(Item f) {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    return InkWell(
        onTap: () async {
          final Uri emailLaunchUri = Uri(
            scheme: 'mailto',
            path: f.email,
            query: encodeQueryParameters(
                <String, String>{'subject': 'Hello Kalm'}),
          );

          await launch(emailLaunchUri.toString());
        },
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: BLUEKALM,
                    border: Border.all(width: 0.5, color: BLUEKALM),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.email_outlined,
                    color: Colors.white,
                  ),
                ),
                SPACE(width: 10),
                TEXT(f.email, style: URL_STYLE()),
              ],
            ),
            SPACE(height: 5),
          ],
        ));
  }

  InkWell _launchPhone1(Item f) {
    return InkWell(
        onTap: () async {
          final Uri launchUri = Uri(
            scheme: 'tel',
            path: f.phone,
          );
          await launch(launchUri.toString());
        },
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: BLUEKALM,
                    border: Border.all(width: 0.5, color: BLUEKALM),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.phone_android_rounded,
                    color: Colors.white,
                  ),
                ),
                SPACE(width: 10),
                Flexible(
                    child: TEXT(f.phone,
                        maxLines: 2,
                        style: URL_STYLE(),
                        textOverflow: TextOverflow.visible)),
              ],
            ),
            SPACE(height: 5),
          ],
        ));
  }

  InkWell _launchPhone2(Item f) {
    return InkWell(
        onTap: () async {
          final Uri launchUri = Uri(
            scheme: 'tel',
            path: f.phone2,
          );
          await launch(launchUri.toString());
        },
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: BLUEKALM,
                    border: Border.all(width: 0.5, color: BLUEKALM),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.phone_android_outlined,
                    color: Colors.white,
                  ),
                ),
                SPACE(width: 10),
                TEXT(f.phone2,
                    style: URL_STYLE(), textOverflow: TextOverflow.visible),
              ],
            ),
            SPACE(height: 5),
          ],
        ));
  }
}

class DiscoveryController extends GetxController {
  ScrollController scrollController = ScrollController();
  bool isArticleGrid = false;

  int lengthArticle = 5;
  int lengthArticleGrid = 6;

  int? lengthContent(BuildContext context) =>
      STATE(context).articleDirectoryResModel?.data?.length;

  setAddLengthArticle(int addLength) {
    lengthArticle = lengthArticle + addLength;
    update();
  }

  setSameLengthArticle(int articleLength) {
    lengthArticle = articleLength;
    update();
  }

  void onChangeArticleView() {
    isArticleGrid = !isArticleGrid;
    update();
  }

  _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      lengthArticleGrid = lengthArticleGrid + 4;
      update();
    }
    // if (scrollController.offset <= scrollController.position.minScrollExtent &&
    //     !scrollController.position.outOfRange) {
    //   print("reach the top");
    // }
  }

  final Completer<WebViewController> webController =
      Completer<WebViewController>();
  int selectedTab = 0;

  void onChangeTab(int index) {
    selectedTab = index;
    update();
  }

  @override
  void onInit() {
    scrollController.addListener(_scrollListener);
    super.onInit();
  }
}
