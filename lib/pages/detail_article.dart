import 'dart:async';

import 'package:counselor/api/api.dart';
import 'package:counselor/color/colors.dart';
import 'package:counselor/model/article_res_model/article_data.dart';
import 'package:counselor/utilities/html_style.dart';
import 'package:counselor/widget/image_cache.dart';
import 'package:counselor/widget/loading.dart';
import 'package:counselor/widget/persistent_tab/persistent_tab_util.dart';
import 'package:counselor/widget/safe_area.dart';
import 'package:counselor/widget/space.dart';
import 'package:counselor/widget/text.dart';
import 'package:counselor/widget/waiting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailArticlePage extends StatelessWidget {
  final ArticleData? articleData;
  DetailArticlePage({Key? key, required this.articleData}) : super(key: key);
  final _controller = Get.put(DetailArticleController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DetailArticleController>(
      initState: (st) {},
      builder: (_) {
        return SAFE_AREA(
          context: context,
          child: ListView(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: IMAGE_CACHE(
                          IMAGE_URL + ARTICLE + (articleData?.file ?? "")),
                    ),
                    SPACE(height: 20),
                    TEXT(articleData?.name,
                        maxLines: 3,
                        textOverflow: TextOverflow.visible,
                        style: titleApp20),
                    // SPACE(),
                    Html(
                      style: HTML_STYLE(),
                      data: articleData?.description,
                      onLinkTap: (l, r, o, e) {
                        var _loading = 0;
                        var _fixUrl = l!.contains("https") || l.contains("http")
                            ? l
                            : "https://$l";
                        pushNewScreen(
                          context,
                          screen: StatefulBuilder(
                            builder: (context, st) {
                              return SAFE_AREA(
                                context: context,
                                child: Stack(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: WebView(
                                            javascriptMode:
                                                JavascriptMode.unrestricted,
                                            initialUrl: _fixUrl,
                                            onProgress: (int p) {
                                              st(() {
                                                _loading = p;
                                              });
                                            })),
                                    if (_loading != 100)
                                      CustomWaiting().defaut(),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
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

class DetailArticleController extends GetxController {
  WebViewController? webViewController;
  final Completer<WebViewController> webController =
      Completer<WebViewController>();

  Future<void> onLoadHtml(String? html) async {
    await webViewController?.loadHtmlString(html!);
  }
}
