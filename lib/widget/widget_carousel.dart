import 'package:carousel_slider/carousel_slider.dart';
import 'package:counselor/api/api.dart';
import 'package:counselor/color/colors.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/model/article_res_model/article_res_model.dart';
import 'package:counselor/pages/detail_article.dart';
import 'package:counselor/tab_pages/discovery_page.dart';
import 'package:counselor/utilities/html_style.dart';
import 'package:counselor/utilities/youtube_iframe.dart';
import 'package:counselor/widget/box_border.dart';
import 'package:counselor/widget/persistent_tab/persistent_tab_util.dart';
import 'package:counselor/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

Container SHIMMER() {
  return BOX_BORDER(
      Shimmer.fromColors(
          baseColor: Colors.grey,
          highlightColor: BLUEKALM.withOpacity(0.9),
          child: const Card()),
      decorationImage: const DecorationImage(
          image: AssetImage("assets/image/image_progress.png")));
}

CarouselSlider ARTICLE_CAROUSEL(BuildContext context, ArticleResModel? data,
    {int? setLength}) {
  return CarouselSlider(
      items: List.generate(setLength ?? data?.data?.length ?? 5, (i) {
        if (data == null) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: SHIMMER(),
          );
        } else {
          var _data = data.data![i];
          return InkWell(
            onTap: () async => await pushNewScreen(context,
                screen: DetailArticlePage(articleData: _data)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: BOX_BORDER(
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Divider(thickness: 2),
                      BOX_BORDER(
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: SizedBox(
                              height: 50,
                              child: TEXT(
                                _data.name,
                                textAlign: TextAlign.center,
                                textOverflow: TextOverflow.visible,
                                maxLines: 2,
                                style: headline6BLUEKALM(fontSize: 18),
                              ),
                            ),
                          ),
                          fillColor: Colors.white),
                    ],
                  ),
                ),
                decorationImage: DecorationImage(
                  image: NetworkImage(
                    IMAGE_URL + ARTICLE + _data.file!,
                  ),
                  fit: BoxFit.fill,
                  onError: (_, __) {},
                ),
              ),
            ),
          );
        }
      }),
      options: CarouselOptions(
        autoPlay: true,
        aspectRatio: 16 / 10,
        autoPlayCurve: Curves.easeIn,
        enableInfiniteScroll: false,
        viewportFraction: 1,
        enlargeStrategy: CenterPageEnlargeStrategy.scale,
        enlargeCenterPage: true,
      ));
}

CarouselSlider ARTICLE_CAROUSEL2(BuildContext context, ArticleResModel? data,
    {required int setLength, CarouselControllerImpl? controllerCarousel}) {
  int length = setLength;
  int? length2 = data?.data?.length;
  if (length2 != null) {
    if (length2 <= length) {
      length = length2;
    }
  }
  // print(length);
  return CarouselSlider(
      carouselController: controllerCarousel,
      items: List.generate(length, (i) {
        if (data == null) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: SHIMMER(),
          );
        } else {
          var _data = data.data![i];
          return InkWell(
            onTap: () async => await pushNewScreen(context,
                screen: DetailArticlePage(articleData: _data)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: BOX_BORDER(
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        BOX_BORDER(
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: SizedBox(
                                  height: 50,
                                  child: TEXT(_data.name,
                                      textAlign: TextAlign.center,
                                      textOverflow: TextOverflow.visible,
                                      maxLines: 2,
                                      style: const TextStyle(fontSize: 20))),
                            ),
                            fillColor: Colors.white),
                      ],
                    ),
                  ),
                  decorationImage: DecorationImage(
                      image: NetworkImage(IMAGE_URL + ARTICLE + _data.file!),
                      fit: BoxFit.fill)),
            ),
          );
        }
      }),
      options: CarouselOptions(
        autoPlay: true,
        aspectRatio: 16 / 10,
        autoPlayCurve: Curves.easeIn,
        enableInfiniteScroll: false,
        viewportFraction: 1,
        enlargeStrategy: CenterPageEnlargeStrategy.scale,
        enlargeCenterPage: true,
        initialPage: 2,
      ));
}

CarouselSlider VIDEO_CAROUSEL(BuildContext context, DiscoveryController _) {
  return CarouselSlider(
      items: List.generate(STATE(context).videoList?.length ?? 3, (i) {
        var data = STATE(context).videoList;
        if (data == null) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: SHIMMER(),
          );
        } else {
          return InkWell(
            onTap: () async => await pushNewScreen(context,
                screen: YoutubePlayerPage(i), withNavBar: false),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: BOX_BORDER(
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: BLUEKALM,
                        child: Icon(Icons.play_arrow_rounded,
                            color: ORANGEKALM, size: 30),
                      )
                    ],
                  ),
                  decorationImage: DecorationImage(
                      image: NetworkImage(YOUTUBE_THUMBNAIL(
                          videoId: STATE(context).videoList![i])),
                      fit: BoxFit.fill)),
            ),
          );
        }
      }),
      options: CarouselOptions(
        aspectRatio: 16 / 10,
        autoPlay: true,
        autoPlayCurve: Curves.easeIn,
        enableInfiniteScroll: false,
        viewportFraction: 1,
        enlargeStrategy: CenterPageEnlargeStrategy.height,
        enlargeCenterPage: true,
      ));
}

class YoutubePlayerPage extends StatelessWidget {
  int i;

  YoutubePlayerPage(this.i, {Key? key}) : super(key: key);
  final _controller = Get.put(YoutubePlayerControl());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<YoutubePlayerControl>(initState: (st) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }, dispose: (ds) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }, builder: (_) {
      return YOUTUBE_PLAYER(i);
    });
  }
}

class YoutubePlayerControl extends GetxController {}

YoutubePlayerController _controller(int i) {
  try {
    return YoutubePlayerController(
      initialVideoId: PRO.videoList![i]!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
      ),
    );
  } catch (e) {
    return YoutubePlayerController(
      initialVideoId: 'test',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
      ),
    );
  }
}

YoutubePlayer YOUTUBE_PLAYER(int i) {
  return YoutubePlayer(
    topActions: [
      Builder(builder: (context) {
        return IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ));
      })
    ],
    controller: _controller(i),
    showVideoProgressIndicator: true,
    onReady: () {
      // _controller.addListener(listener);
    },
    progressColors: const ProgressBarColors(
      playedColor: Colors.amber,
      handleColor: Colors.amberAccent,
    ),
  );
}
