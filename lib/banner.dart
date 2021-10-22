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
  late List<Widget> screens;
  late AndroidView androidView;
  String banner_value = "";
  bool visible_banner = true;
  PageController controller = new PageController(initialPage: 0);
  BannerMaxView(this.listener, this.size, this.adUnitId, {Key? key})
      : super(key: key);

  initState() {
    screens = [
      Container(
          width: sizesNum[size]?.width,
          height: sizesNum[size]?.height,
          child: Platform.isAndroid ? androidView : null),
      Container(
        // height: 30,
        color: Colors.transparent,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    initState();
    final AndroidView androidView = AndroidView(
        viewType: '/Banner',
        key: UniqueKey(),
        creationParams: {'Size': sizes[size], 'UnitId': adUnitId},
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (int i) {
          const MethodChannel channel = MethodChannel('flutter_applovin_max');
          channel.setMethodCallHandler((MethodCall call) async =>
              FlutterApplovinMax.handleMethod(call,
                  (AppLovinAdListener? event) {
                if (event == AppLovinAdListener.adLoaded) {
                  banner_value = "load";
                  controller.jumpToPage(0);
                  Timer(Duration(seconds: 2), () {
                    print('timer ended');
                    print(banner_value);
                    if (banner_value == "load") {
                      controller.jumpToPage(1);
                    }
                  });
                } else if (event == AppLovinAdListener.adDisplayed) {
                  banner_value = "display";
                  controller.jumpToPage(0);
                } else {
                  banner_value = "other";
                  controller.jumpToPage(1);
                }
              }));
        });
    return ExpandablePageView(
      physics: NeverScrollableScrollPhysics(),
      controller: controller,
      children: screens,
    );
  }
}
