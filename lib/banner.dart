import 'package:flutter_applovin_max/flutter_applovin_max.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'dart:io';
import 'dart:async';

enum BannerAdSize {
  banner,
  mrec,
  leader,
}

class BannerPx {
  final double width;
  final double height;
  BannerPx(this.width, this.height);
}

class BannerMaxView extends StatelessWidget {
  final AppLovinListener listener;
  final Map<BannerAdSize, String> sizes = {
    BannerAdSize.banner: 'BANNER',
    BannerAdSize.leader: 'LEADER',
    BannerAdSize.mrec: 'MREC'
  };
  final Map<BannerAdSize, BannerPx> sizesNum = {
    BannerAdSize.banner: BannerPx(350, 50),
    BannerAdSize.leader: BannerPx(double.infinity, 90),
    BannerAdSize.mrec: BannerPx(300, 250)
  };
  final BannerAdSize size;
  final String adUnitId;
  final String unique;
  // late List<Widget> screens;
  // late AndroidView androidView;
  String banner_value = "";
  bool visible_banner = true;
  PageController controller = new PageController(initialPage: 0);
  BannerMaxView(this.listener, this.size, this.adUnitId, this.unique,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int where = 0;
    final AndroidView androidView = AndroidView(
        viewType: '/Banner',
        key: UniqueKey(),
        creationParams: {
          'Size': sizes[size],
          'id': adUnitId,
          'theme': 'dark',
          'unique': unique
        },
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (int i) {
          print("unique is " + unique);

          MethodChannel channel =
              MethodChannel('flutter_applovin_banner_' + unique);

          channel.setMethodCallHandler((MethodCall call) async => FlutterApplovinMax.handleMethod(call, listener));

          // channel.setMethodCallHandler((MethodCall call) async =>
          //     FlutterApplovinMax.handleMethod(call,
          //         (AppLovinAdListener? event) {
          //       print('event changed for ad unit ' + adUnitId);
          //       print(event.toString());
          //       if (event == AppLovinAdListener.adLoaded) {
          //         banner_value = "load";
          //         where = 0;
          //         controller.jumpToPage(0);
          //         // Timer(Duration(seconds: 2), () {
          //         //   print('timer ended');
          //         //   print(banner_value);
          //         //   if (banner_value == "load") {
          //         //     controller.jumpToPage(1);
          //         //   }
          //         // });
          //       } else if (event == AppLovinAdListener.adDisplayed) {
          //         banner_value = "display";
          //         if (where == 1) {
          //           controller.jumpToPage(0);
          //         }
          //       } else if (event == AppLovinAdListener.adLoadFailed) {
          //         banner_value = "failed";
          //         where = 1;
          //         controller.jumpToPage(1);
          //       }
          //       // else {
          //       //               banner_value = "other";
          //       //               controller.jumpToPage(1);
          //       //             }
          //     }));
        });
    return ExpandablePageView(
      physics: NeverScrollableScrollPhysics(),
      controller: controller,
      children: [
        Container(
            width: sizesNum[size]?.width,
            height: sizesNum[size]?.height,
            child: Platform.isAndroid ? androidView : Container()),
        Container(
          color: Colors.transparent,
        )
      ],
    );
  }
}
