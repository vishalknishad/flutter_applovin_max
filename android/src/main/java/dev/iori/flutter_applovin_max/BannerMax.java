package dev.iori.flutter_applovin_max;

import android.app.Activity;
import android.content.Context;
import android.view.Gravity;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import com.applovin.adview.AppLovinAdView;
import com.applovin.adview.AppLovinAdViewDisplayErrorCode;
import com.applovin.adview.AppLovinAdViewEventListener;

import com.applovin.mediation.MaxAd;
import com.applovin.mediation.MaxReward;
import com.applovin.mediation.MaxAdViewAdListener;
import com.applovin.mediation.MaxError;

import com.applovin.mediation.ads.MaxAdView;
import com.applovin.sdk.AppLovinAd;
import com.applovin.sdk.AppLovinAdClickListener;
import com.applovin.sdk.AppLovinAdDisplayListener;
import com.applovin.sdk.AppLovinAdLoadListener;
import com.applovin.sdk.AppLovinAdSize;
import com.applovin.sdk.AppLovinSdkUtils;
import java.util.HashMap;
import io.flutter.Log;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;


public class BannerMax extends FlutterActivity implements PlatformView, MaxAdViewAdListener {
    final MaxAdView Banner;
    private final MethodChannel channel;
    final HashMap<String, AppLovinAdSize> sizes = new HashMap<String, AppLovinAdSize>() {
        {
            put("BANNER", AppLovinAdSize.BANNER);
            put("MREC", AppLovinAdSize.MREC);
            put("LEADER", AppLovinAdSize.LEADER);
        }
    };

    AppLovinAdSize size;
    String AdUnitId;

    public BannerMax(Context context,int id, HashMap args, BinaryMessenger messenger) {
         this.channel = new MethodChannel(messenger,
                "flutter_applovin_banner_" + args.get("unique").toString());
        Log.d("Banner Max Android", "Constructor");
        try {
            this.size = this.sizes.get(args.get("Size"));
        } catch (Exception e) {
            this.size = AppLovinAdSize.BANNER;
        }
        try {
            this.AdUnitId = args.get("id").toString();
        } catch (Exception e) {
            this.AdUnitId = "YOUR_AD_UNIT_ID";
        }

        this.Banner = new MaxAdView( AdUnitId, FlutterApplovinMaxPlugin.getInstance().activity);
        final FrameLayout.LayoutParams layout = new FrameLayout.LayoutParams(
                this.dpToPx(context, this.size.getWidth()), this.dpToPx(context, this.size.getHeight()));
        layout.gravity = Gravity.CENTER;
        this.Banner.setLayoutParams(layout);
        this.Banner.setListener( this );
        this.Banner.loadAd();
    }



    int dpToPx(Context context, int dp) {
        return AppLovinSdkUtils.dpToPx(context, dp);
    }

    @Override
    public View getView() {
        return this.Banner;
    }

    @Override
    public void dispose() {
        //this.Banner.destroy();
    }

    @Override
    public void onAdLoaded(final MaxAd ad) {
        System.out.print("first statement. ");  
         this.channel.invokeMethod("AdLoaded", null);
        // FlutterApplovinMaxPlugin.getInstance().Callback("AdLoaded");
         }

    @Override
    public void onAdLoadFailed(final String adUnitId, final MaxError maxError) { 
        System.out.print("second statement. ");
        // FlutterApplovinMaxPlugin.getInstance().Callback("AdLoadFailed");
         this.channel.invokeMethod("AdLoadFailed", null);
        this.Banner.loadAd();
         }

    @Override
    public void onAdHidden(final MaxAd ad) { 
        System.out.print("third statement. ");
        //FlutterApplovinMaxPlugin.getInstance().Callback("AdHidden");
         this.channel.invokeMethod("AdHidden", null);
        
         }

    @Override
    public void onAdDisplayFailed(final MaxAd ad, final MaxError maxError) {
        System.out.print("forth statement. ");
        //FlutterApplovinMaxPlugin.getInstance().Callback("AdDisplayFailed");
         this.channel.invokeMethod("AdDisplayFailed", null);
        this.Banner.loadAd();
         }

    @Override
    public void onAdDisplayed(final MaxAd ad) {
        System.out.print("fifth statement. ");
        //FlutterApplovinMaxPlugin.getInstance().Callback("AdDisplayed");
         this.channel.invokeMethod("AdDisplayed", null);
         }

    @Override
    public void onAdClicked(final MaxAd ad) { 
        System.out.print("sixth statement. ");
       // FlutterApplovinMaxPlugin.getInstance().Callback("AdClicked"); 
         this.channel.invokeMethod("AdClicked", null);
        }

    @Override
    public void onAdExpanded(final MaxAd ad) { 
        System.out.print("seventh statement. ");
       // FlutterApplovinMaxPlugin.getInstance().Callback("AdCExpanded");
         this.channel.invokeMethod("AdCExpanded", null);
         }

    @Override
    public void onAdCollapsed(final MaxAd ad) {
        System.out.print("eighth statement. ");
        //FlutterApplovinMaxPlugin.getInstance().Callback("AdCollapsed");
         this.channel.invokeMethod("AdCollapsed", null);
         }
}
